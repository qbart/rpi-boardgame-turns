defmodule BalloonboardWeb.SessionController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo
  alias Phoenix.LiveView
  import Ecto.Query, only: [from: 2]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"player" => player} = _params) do
    {:ok, session} = Repo.insert(%Session{uid: Ecto.UUID.generate()})

    {:ok, _round} =
      Repo.insert(%Round{
        session_id: session.id,
        player: String.to_integer(player),
        started_at: TimeUtils.now(),
        stopped_at: nil
      })

    redirect(conn, to: Routes.session_path(conn, :show, session.id))
  end

  def show(conn, %{"id" => session_id} = _params) do
    session = Repo.get!(Session, session_id)
    render(conn, "show.html", session: session)
  end

  def stop(conn, %{"session_id" => session_id} = _params) do
    query =
      from r in Round,
        where: r.session_id == ^session_id and is_nil(r.stopped_at)

    Repo.update_all(query, set: [stopped_at: TimeUtils.now()])

    round =
      Repo.one(
        from r in Round,
          where: r.session_id == ^session_id,
          order_by: [desc: r.started_at],
          limit: 1
      )

    render(conn, "stop.json", round: round)
  end
end
