defmodule Mate.Models.Signup do
  use Mate.Web, :model
  
  alias Mate.Repo
  alias RiakcCommon.Tools.Hash
  alias RiakcCommon.Tools.Time

  @send_mail_interval 3600

  @primary_key {:email, :string, []}
  @derive {Phoenix.Param, key: :email}
  schema "signups" do
    field :sha, :string
    field :sent, :boolean, default: false
    timestamps 
  end

  def changeset(signup, params \\ nil) do
    signup
    |> cast(params, ~w(email sha),~w(sent))
    |> validate_format(:email, ~r/@/, message: "无效邮箱")
  end
  
  def by_token(token) do
    query = from s in Mate.Models.Signup, where: s.sha == ^token
    Repo.one query
  end

  def create(email,sha) do
    params = %{sha: sha , email: email}
    changeset = changeset(%Mate.Models.Signup{} , params)
    if changeset.valid? do
      case Repo.insert(changeset) do
        {:ok, model}        -> 
          model
        {:error, _changeset} -> 
          nil
      end
    else
      nil
    end
  end


  def can_signup(email) do
    query = from s in Mate.Models.Signup, 
      where: s.email == ^email
    signup = Repo.one query

    if nil == signup do
      true
    else
      if can_send(signup) do
        case Repo.delete signup do
          {:ok, model} -> true
          {:error, changeset} -> false
        end
      else   
        false
      end
    end

  end

  defp can_send(signup) do
    timestamps = Time.current_time()
    update_timestamps = 
      :calendar.datetime_to_gregorian_seconds(Ecto.DateTime.to_erl(signup.inserted_at))
    if (timestamps - update_timestamps) >=  @send_mail_interval do
      true
    else
      false
    end
  end



end
