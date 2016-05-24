defmodule Mate.Common.RegisterController do
  use Mate.Web, :controller

  alias RiakcCommon.Tools.Hash

  alias Mate.Common.Message

  alias Mate.Models.Signup
  alias Mate.Models.User

  def new(conn,%{"token" => token} = params) do
    render(conn,"password.html",token: token)
  end

  def new(conn,_params) do
    render(conn,"email.html")
  end

  def create(conn,%{"email" => email} = params) do
    if User.signup?(email) do
      msg = Message.translate("Email is already taken!")
      render(conn, "email.html", error: msg)
    else
      send_signup_email(conn,email)
    end
  end

  def create(conn,%{"token" => token,"password" => password,
    "retype-password" => retype} = params) do
    signup = Signup.by_token(token)
    if nil == signup do
      msg = Message.translate("Please verify your email first!")
      render(conn,"password.html",error: msg,token: token)
    else
      if password != retype do
        msg = Message.translate("Passwords don't match")
        render(conn,"password.html",error: msg, token: token)
      else
        signup(conn,signup,token,password)
      end
    end
  end

  def create(conn,_params) do
    path = register_path(conn,:new)
    redirect(conn,to: path)
  end

  defp signup(conn,signup,token,password) do
    email = signup.email
    user = %{email: email, password: password}
    changeset = User.changeset(%User{}, user)
    if changeset.valid? do
      changeset = Ecto.Changeset.put_change(changeset, :password, 
          password
          |> User.encrypt_password 
          |> to_string) 
      case signup_with_verified_email(signup,changeset) do
        {:ok,model} ->
          path = page_path(conn,:index)
          redirect(conn,to: path)
        {:error,changeset}->
          msg = Message.translate("Some errors occurred!")
          render(conn, "password.html", error: msg,token: token) 
      end
    else
      msg = Message.translate("Email is already taken!")
      render(conn, "password.html", error: msg,token: token)
    end
  end

  defp send_signup_email(conn,email) do
    if Signup.can_signup(email) do
      send_signup_email(conn,email)
      msg = Message.translate("Congratulations! Please check your email to verify it.")
      render(conn, "email.html", success: msg)
    else
      msg = Message.translate("Sorry! You send too many emails!")
      render(conn, "email.html", error: msg)
    end
  end

  defp send_signup_email(conn,email) do

    sha = Hash.get_random_hash_256(email)
    signup = Signup.create(email,sha)
    if nil != signup do
      url =  register_url(conn, :new, token: sha)
      Mailer.signup_mail(email,url)
      msg = Message.translate("Congratulations! Please check your email to verify it.")
      render(conn, "email.html", success: msg)
    else
      msg = Message.translate("Some errors occurred!")
      render(conn, "email.html", error: msg)
    end
  end

  defp create_user(user) do
    case Repo.insert(user) do
      {:ok, model} ->
        model
      {:error, changeset}->
        Repo.rollback(changeset)
    end
  end

  defp delete_signup(signup) do
    case Repo.delete(signup) do
      {:ok, model} ->
        model
      {:error, changeset} ->
        Repo.rollback(changeset)
    end
  end

  defp signup_with_verified_email(signup,user)do
    Repo.transaction(fn ->
      u = create_user(user)
      delete_signup(signup)
      u
    end)
  end


end