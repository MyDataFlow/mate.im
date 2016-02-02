defmodule Mate.UserView do
  use Mate.Web, :view

  def render("show.json", %{user: user}) do
    avatar = user.avatar
    if nil == avatar do
      avatar = avatar_url(user.email)
    end
    %{
      id: user.id,
      name: user.name,
      avatar: avatar,
      inserted_at: user.inserted_at
    }
  end
  def render("show.edit.json", %{user: user}) do
    avatar = user.avatar
    if nil == avatar do
      avatar = avatar_url(user.email)
    end
    %{
      id: user.id,
      name: user.name,
      avatar: avatar,
      email: user.email,
      inserted_at: user.inserted_at
    }
  end

end
