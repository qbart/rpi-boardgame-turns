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

    tags =
      Repo.all(Tag)
      |> Enum.reduce(%{}, fn t, acc ->
        Map.put(acc, t.player, [t.tag | Map.get(acc, t.player, [])])
      end)

    render(conn, "show.html", session: session, tags: tags)
  end

  def stop(conn, %{"session_id" => session_id} = _params) do
    Round.clear_unstopped(String.to_integer(session_id))
    redirect(conn, to: Routes.page_path(conn, :index))
  end
end
