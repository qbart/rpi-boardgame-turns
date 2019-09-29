defmodule BalloonboardWeb.Live.TagsView do
  use Phoenix.LiveView

  def render(assigns) do
    BalloonboardWeb.SessionView.render("tags.live.html", assigns)
  end

  def mount(session, socket) do
    {:ok, assign(socket, session)}
  end

  def handle_event("select", player_id, socket) do
    # assigns =
    #   assigns
    #   |> assign(:selected_players, players)
    #   |> assign(:selected_tags, active_players)

    id = String.to_integer(player_id)
    player = Enum.find(socket.assigns.players, fn p -> p.id == id end)

    if player do
      players =
        socket.assigns.players
        |> Enum.filter(fn p -> p.id != player.id end)

      active_players = socket.assigns.active_players ++ [player]

      socket =
        socket
        |> assign(:players, players)
        |> assign(:active_players, active_players)

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def handle_event("deselect", player_id, socket) do
    id = String.to_integer(player_id)
    player = Enum.find(socket.assigns.active_players, fn p -> p.id == id end)

    if player do
      active_players =
        socket.assigns.active_players
        |> Enum.filter(fn p -> p.id != player.id end)

      players = socket.assigns.players ++ [player]

      socket =
        socket
        |> assign(:players, players)
        |> assign(:active_players, active_players)

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end
end
