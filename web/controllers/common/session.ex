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

  def render_with_user(conn,template,assigns \\ []) do
    user = user(conn)
    if nil == user do
      render(conn,template,assigns)
    else
      assigns = Keyword.merge(assigns, [user: user])
      render(conn,template,assigns)
    end
    
  end

end