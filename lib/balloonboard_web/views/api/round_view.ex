defmodule BalloonboardWeb.Api.RoundView do
  use BalloonboardWeb, :view

  def render("start.json", %{round: round}) do
    render_round(round)
  end

  def render("stop.json", %{round: round}) do
    render_round(round)
  end

  defp render_round(round) do
    %{
      round: %{
        id: round.id,
        started_at: round.started_at,
        stopped_at: round.stopped_at,
        player: round.player
      }
    }
  end
end
