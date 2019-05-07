defmodule BalloonboardWeb.TagController do
  use BalloonboardWeb, :controller
  alias Balloonboard.Repo

  def new(conn, _params) do
    changeset = Tag.changeset(%Tag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params} = _params) do
    changeset = Tag.changeset(%Tag{}, tag_params)

    case Repo.insert(changeset) do
      {:ok, _tag} ->
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Failed to save")
        |> render("new.html", changeset: changeset)
    end
  end
end
