defmodule BalloonboardWeb.Api.RoundView do
  use BalloonboardWeb, :view

  def render("start.json", %{round: round}) do
    %{
      id: round.id,
      started_at: round.started_at,
      stopped_at: round.stopped_at,
      player: round.player
    }
  end
end
