defmodule BalloonboardWeb.Api.RoundController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo
  import Ecto.Query, only: [from: 2]

  def start(conn, %{"session_id" => session_id, "player" => player} = _params) do
    now = TimeUtils.now()

    query =
      from r in Round,
        where: r.session_id == ^session_id and is_nil(r.stopped_at)

    Repo.update_all(query, set: [stopped_at: now])

    {:ok, round} =
      Repo.insert(%Round{
        session_id: String.to_integer(session_id),
        player: player,
        started_at: now,
        stopped_at: nil
      })

    render(conn, "start.json", round: round)
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
