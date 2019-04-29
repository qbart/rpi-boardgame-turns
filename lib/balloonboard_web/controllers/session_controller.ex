defmodule BalloonboardWeb.SessionController do
  use BalloonboardWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end
end
