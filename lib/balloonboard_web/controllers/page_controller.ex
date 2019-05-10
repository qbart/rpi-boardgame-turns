defmodule BalloonboardWeb.PageController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    active_sessions = Repo.all(from s in Session, where: s.active)
    tags = Repo.all(Tag)

    render(conn, "index.html", %{
      active_sessions: active_sessions,
      tags: tags
    })
  end
end
