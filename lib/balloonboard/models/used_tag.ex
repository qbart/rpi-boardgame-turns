defmodule UsedTag do
  use Ecto.Schema
  alias Balloonboard.Repo

  schema "used_tags" do
    field :tagged_at, :naive_datetime
    field :comment, :string

    belongs_to :player, Player
    belongs_to :session, Session
    belongs_to :tag, Tag
  end

  def update_comment!(id, comment) do
    Repo.get!(UsedTag, id)
    |> Ecto.Changeset.change(comment: comment)
    |> Repo.update()
  end
end
