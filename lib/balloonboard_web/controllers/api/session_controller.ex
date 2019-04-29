defmodule BalloonboardWeb.Api.SessionController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo

  def create(conn, _params) do
    {:ok, session} = Repo.insert(%Session{uid: Ecto.UUID.generate()})
    render conn, "create.json", session: session
  end
end
