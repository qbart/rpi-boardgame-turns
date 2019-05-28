defmodule BalloonboardWeb.Live.SessionView do
  use Phoenix.LiveView
  alias Balloonboard.Repo

  def render(assigns) do
    stats = stats(assigns.session.id)

    active =
      Enum.reduce(assigns.active_players, %{}, fn id, acc ->
        Map.put(acc, id, stats[id].round_duration > 0)
      end)

    BalloonboardWeb.SessionView.render("show.live.html", %{
      active: active,
      stats: stats,
      tags: assigns.tags,
      players: assigns.players,
      active_players: assigns.active_players
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

  def handle_event("player", param_id, socket) do
    player_id = String.to_integer(param_id)

    if Round.can_player_finish?(socket.assigns.session.id, player_id) do
      next_player_id = next_player(socket.assigns.active_players, player_id)
      {:ok, _round} = Round.switch_player(socket.assigns.session.id, next_player_id)
      {:noreply, update(socket, :time, fn _ -> :calendar.local_time() end)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("tag", params, socket) do
    case String.split(params, ",") do
      [player, tag_id] ->
        {:ok, _} =
          Repo.insert(%UsedTag{
            session_id: socket.assigns.session.id,
            player_id: String.to_integer(player),
            tag_id: String.to_integer(tag_id),
            tagged_at: TimeUtils.now()
          })

        {:noreply, update(socket, :time, fn _ -> :calendar.local_time() end)}

      _ ->
        {:noreply, socket}
    end
  end

  defp stats(session_id) do
    SessionLiveStats.for(session_id)
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x.player_id, x) end)
  end

  defp next_player(players, current) do
    index = Enum.find_index(players, fn p -> p == current end)
    Enum.at(players, index + 1) || List.first(players)
  end
end
