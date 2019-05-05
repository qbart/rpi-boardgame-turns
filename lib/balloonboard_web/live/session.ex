defmodule BalloonboardWeb.Live.SessionView do
  use Phoenix.LiveView

  def render(assigns) do
    stats = stats(assigns[:session].id)
    active_2 = stats[2].round_duration > 0
    active_1 = stats[1].round_duration > 0

    ~L"""
    <div id="session">
      <div class="row">
        <div class="col-sm">
        <a phx-click="player_2" class="btn btn-danger btn-block btn-lg" href="">
          <%= stats[2].finished_rounds %>
          <br>
          <span class="badge badge-pill <%= badge_class(active_2) %>">
            <%= format(stats[2].round_duration) %>
          </span>
          <span class="badge badge-pill <%= badge_class(active_2) %>">
            <%= format(stats[2].total_duration) %>
          </span>
        </a>
        </div>
        <div class="col-sm">
          <a phx-click="player_1" class="btn btn-primary btn-block btn-lg" href="">
            <%= stats[1].finished_rounds %>
            <br>
            <span class="badge badge-pill <%= badge_class(active_1) %>">
              <%= format(stats[1].round_duration) %>
            </span>
            <span class="badge badge-pill <%= badge_class(active_1) %>">
              <%= format(stats[1].total_duration) %>
            </span>
          </a>
        </div>
      </div>
    </div>
    """
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
    {:noreply, update(socket, :time, fn _ -> :calendar.local_time() end)}
  end

  def handle_event("player_2", _, socket) do
    {:noreply, update(socket, :time, fn _ -> :calendar.local_time() end)}
  end

  defp stats(session_id) do
    SessionStats.for(session_id)
    |> Enum.reduce(%{}, fn x, acc -> Map.put(acc, x.player, x) end)
  end

  defp badge_class(true), do: "badge-success"
  defp badge_class(false), do: "badge-warning"

  defp format(duration) do
    m = div(duration, 60) |> Integer.to_string() |> String.pad_leading(2, "0")
    s = rem(duration, 60) |> Integer.to_string() |> String.pad_leading(2, "0")
    "#{m}:#{s}"
  end
end
