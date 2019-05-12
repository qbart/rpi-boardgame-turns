defmodule BalloonboardWeb.Archive.SessionController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    sessions = Repo.all(from s in Session, order_by: [desc: :id])
    render(conn, "index.html", %{sessions: sessions})
  end

  def show(conn, %{"id" => session_id} = _params) do
    session =
      Repo.get!(Session, session_id)
      |> Repo.preload(used_tags: [:tag])

    rounds =
      Repo.all(
        from r in Round,
          where: r.session_id == ^session.id,
          order_by: :started_at
      )
      |> Enum.chunk_every(2)

    render(conn, "show.html", session: session, rounds: rounds)
  end
end
