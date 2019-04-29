defmodule BalloonboardWeb.Api.RoundController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo

  def start(conn, %{"session_id" => session_id, "player" => player} = _params) do
    {:ok, round} = Repo.insert(
      %Round{
        session_id: String.to_integer(session_id),
        player: player,
        started_at: TimeUtils.now(),
        stopped_at: nil
      }
    )
    render conn, "start.json", round: round
  end
end
