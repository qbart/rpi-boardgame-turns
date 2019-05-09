defmodule BalloonboardWeb.Live.SessionView do
  use Phoenix.LiveView
  alias Balloonboard.Repo

  def render(assigns) do
    stats = stats(assigns[:session].id)
    tags = assigns[:tags]
    active_2 = stats[2].round_duration > 0
    active_1 = stats[1].round_duration > 0

    BalloonboardWeb.SessionView.render("show.live.html", %{
      active_1: active_1,
      active_2: active_2,
      stats: stats,
      tags: tags
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

  def handle_event("player_1", _, socket) do
    if Round.can_switch_player?(socket.assigns.session.id, 2) do
      {:ok, _round} = Round.switch_player(socket.assigns.session.id, 2)
      {:noreply, update(socket, :time, fn _ -> :calendar.local_time() end)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("player_2", _, socket) do
    if Round.can_switch_player?(socket.assigns.session.id, 1) do
      {:ok, _round} = Round.switch_player(socket.assigns.session.id, 1)
      {:noreply, update(socket, :time, fn _ -> :calendar.local_time() end)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("tag", params, socket) do
    case String.split(params, ",") do
      [player, tag_id] ->
        {:ok, _} = Repo.insert(%UsedTag{
          session_id: socket.assigns.session.id,
          player: String.to_integer(player),
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
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x.player, x) end)
  end
end
