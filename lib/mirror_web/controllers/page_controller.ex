defmodule MirrorWeb.PageController do
  use MirrorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
