defmodule BalloonboardWeb.Api.RoundController do
  use BalloonboardWeb, :controller

  def start(conn, %{"session_id" => session_id, "player" => player} = _params) do
    {:ok, round} = Round.switch_player(String.to_integer(session_id), String.to_integer(player))

    render(conn, "start.json", round: round)
  end
end
