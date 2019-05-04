defmodule BalloonboardWeb.SessionController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"player" => player} = _params) do
    {:ok, session} = Repo.insert(%Session{uid: Ecto.UUID.generate()})

    {:ok, round} =
      Repo.insert(%Round{
        session_id: session.id,
        player: String.to_integer(player),
        started_at: TimeUtils.now(),
        stopped_at: nil
      })

    render(conn, "show.html", session: session, round: round)
  end
end
