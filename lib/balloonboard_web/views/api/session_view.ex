defmodule BalloonboardWeb.Api.SessionView do
  use BalloonboardWeb, :view

  def render("create.json", %{session: session}) do
    %{
      id: session.id,
      uid: session.uid
    }
  end
end
