defmodule BalloonboardWeb.SessionController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo
  import Ecto.Query

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

    active_players =
      from(a in ActivePlayer, where: a.session_id == ^session.id, order_by: [:position])
      |> Repo.all()

    active_player_ids = Enum.map(active_players, fn p -> p.player_id end)

    players =
      Player
      |> where([p], p.id in ^active_player_ids)
      |> Repo.all()
      |> Enum.reduce(%{}, fn p, acc ->
        Map.put(acc, p.id, p)
      end)

    render(conn, "show.html",
      session: session,
      active_players: active_players,
      players: players,
      rounds: %{}
    )
  end

  def stop(conn, %{"session_id" => session_id} = _params) do
    session = Repo.get!(Session, session_id)
    render(conn, "stop.html", session: session)
  end

  def tags(conn, %{"session_id" => session_id} = _params) do
    session = Repo.get!(Session, session_id)

    active_players =
      from(a in ActivePlayer, where: a.session_id == ^session.id, order_by: [:position])
      |> Repo.all()

    active_player_ids = Enum.map(active_players, fn p -> p.player_id end)

    players =
      Player
      |> where([p], p.id in ^active_player_ids)
      |> Repo.all()
      |> Enum.reduce(%{}, fn p, acc ->
        Map.put(acc, p.id, p)
      end)

    render(conn, "tags.html",
      session: session,
      active_players: active_players,
      players: players,
      tags: []
    )
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
