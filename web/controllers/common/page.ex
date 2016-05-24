defmodule Mate.Common.Page do

  alias Mate.Common.Session

  def render_with_user(conn,template,assigns \\ []) do
    user = Session.user(conn)
    if nil == user do
      render(conn,template,assigns)
    else
      assigns = Keyword.merge(assigns, [user: user])
      render(conn,template,assigns)
    end
  end

end