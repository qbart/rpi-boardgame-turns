defmodule BalloonboardWeb.Live.SessionView do
  use Phoenix.LiveView

  def render(assigns) do
    round_rows = RoundLiveStats.for(assigns.session.id)

    rounds =
      Enum.reduce(assigns.active_players, %{}, fn ap, acc ->
        Map.put(acc, ap.player_id, [])
      end)

    rounds =
      Enum.reduce(round_rows, rounds, fn r, acc ->
        Map.put(acc, r.player_id, [r | acc[r.player_id]])
      end)

    BalloonboardWeb.SessionView.render("show.live.html", %{
      players: assigns.players,
      active_players: assigns.active_players,
      rounds: rounds
    })
  end

  def mount(session, socket) do
    if connected?(socket), do: Process.send_after(self(), :tick, 1000)
    {:ok, assign(socket, session)}
  end

  def handle_info(:tick, socket) do
    Process.send_after(self(), :tick, 1000)
    {:noreply, assign(socket, time: :calendar.local_time())}
  end

  def handle_event("next", _params, socket) do
    rows = RoundLiveStats.for(socket.assigns.session.id)
    row = Enum.find(rows, fn r -> r.round_active end)
    player_id = next_player_id(socket.assigns.active_players, row.player_id)

    if Round.can_player_finish?(socket.assigns.session.id, row.player_id) do
      {:ok, _round} = Round.switch_player(socket.assigns.session.id, player_id)
      {:noreply, socket_tick(socket)}
    else
      {:noreply, socket}
    end
  end

  defp next_player_id(players, current) do
    index = Enum.find_index(players, fn p -> p.player_id == current end)
    (Enum.at(players, index + 1) || List.first(players)).player_id
  end

  defp socket_tick(socket) do
    update(socket, :time, fn _ -> :calendar.local_time() end)
  end
end
