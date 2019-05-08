defmodule BalloonboardWeb.PageController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo
  import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    rounds_query = from r in Round, where: is_nil(r.stopped_at)
    active_sessions = Repo.all(from s in Session, join: r in subquery(rounds_query), on: s.id == r.session_id)
    render(conn, "index.html", %{active_sessions: active_sessions})
  end
end
