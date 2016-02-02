defmodule Mate.UserController do
  use Mate.Web, :controller

  alias Mate.ControllerCommon
  alias Mate.User
  alias Mate.Post

  def show(conn, %{"id" => id, "edit" => edit}) do
    user_id = ControllerCommon.get_user_id_for_request(conn)
    uid = String.to_integer(id)
    if nil == user_id do
      ControllerCommon.unauthorized conn
    else
      case Repo.get(User, uid) do
      user when is_map(user) ->
        if user.id != user_id do
          render conn, "show.json", user: user
        else
          render conn, "show.edit.json", user: user
        end    
      _ ->
        ControllerCommon.home(conn)
    end
      
    end

  end
  def show(conn, %{"id" => id}) do
    case Repo.get(User, String.to_integer(id)) do
      user when is_map(user) ->
        render conn, "show.json", user: user
      _ ->
        ControllerCommon.home(conn)
    end
  end

  def update(conn,  params) do
    id = params["id"]
    user = Repo.get(User, String.to_integer(id))
    if params["oldpassword"] != nil && params["password"] != nil do
      if User.valid_password?(user,params["oldpassword"]) do
        params = :maps.remove("oldpassword",params)
        update_user_password(conn,user,params)
      else
        ControllerCommon.unauthorized conn
      end
    else
      user_id = ControllerCommon.get_user_id_for_request(conn)
      if user_id == user.id do
        params = :maps.remove("oldpassword",params)
        params = :maps.remove("password",params)
        update_user_profile(conn,user,params)
      else
        ControllerCommon.unauthorized conn
      end
    end

  end

  defp update_user_password(conn,user,params) do
    changeset = User.changeset(user, params)
    if changeset.valid? do
      changeset = Ecto.Changeset.put_change(changeset, :password, 
      params["password"] 
            |> User.encrypt_password 
            |> to_string)  

      Repo.update(changeset)
      show(conn,%{"id" => Integer.to_string(user.id)})
    else
      conn 
      |> put_status(400)
      |> text "error"
    end
  end

  defp update_user_profile(conn,user,params) do
    changeset = User.changeset(user, params)
    if changeset.valid? do
      Repo.update(changeset)
      show(conn,%{"id" => Integer.to_string(user.id)})
    else
      errors = Enum.map(changeset.errors, fn {f, d} ->
          %{ "error" => d }
        end)
      conn 
      |> put_status(400)
      |> json errors
      
    end
  end





end
