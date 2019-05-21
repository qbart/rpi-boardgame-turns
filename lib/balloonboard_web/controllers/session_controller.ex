defmodule BalloonboardWeb.SessionController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo
  import Ecto.Query, only: [from: 2]

  def new(conn, _params) do
    players = Repo.all(Player)
    render(conn, "new.html", players: players, active_players: [])
  end

  def create(conn, %{"players" => players} = _params) do
    {:ok, session} = Session.start(Enum.map(players, &String.to_integer(&1)))
    redirect(conn, to: Routes.session_path(conn, :show, session.id))
  end

  def show(conn, %{"id" => session_id} = _params) do
    session = Repo.get!(Session, session_id)

    tags =
      Repo.all(Tag)
      |> Enum.reduce(%{}, fn t, acc ->
        Map.put(acc, t.player, [%{tag: t.tag, id: t.id} | Map.get(acc, t.player, [])])
      end)

    render(conn, "show.html", session: session, tags: tags)
  end

  def stop(conn, %{"session_id" => session_id} = _params) do
    session = Repo.get!(Session, session_id)
    render(conn, "stop.html", session: session)
  end

  def quit(conn, %{"session_id" => session_id} = _params) do
    Repo.transaction(fn ->
      Round.clear_unstopped(String.to_integer(session_id))

      from(s in Session, where: s.id == ^session_id)
      |> Repo.update_all(set: [active: false])
    end)

    redirect(conn, to: Routes.page_path(conn, :index))
  end
end
