defmodule Mate.RedirectsPlug do
  import Plug.Conn

  def init(options), do: options

  def call(conn, options) do
    path = conn.request_path
    regex = ~r/^\/api\/.*/
    if path == "/" || Regex.match?(regex,path) do
      do_redirect(conn,nil)
    else
      do_redirect(conn,path)
    end

  end

  defp do_redirect(conn, nil), do: conn

  defp do_redirect(conn, path) do
    url = "/#" <>  path
    IO.puts url
    conn
      |> Phoenix.Controller.redirect(to: url)
      |> halt
  end
end
