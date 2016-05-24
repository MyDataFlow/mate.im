defmodule Mate.Common.Session do
  use RiakcPhoenix.Request.Session, otp_app: :mate
  
  alias Mate.Repo
  alias Mate.Models.User

  def user(conn) do
    uid = user_id(conn)
    if uid do
      Repo.get(User, uid)
    else
      nil
    end
  end

end