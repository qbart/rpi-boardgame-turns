defmodule Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :tag, :string

    belongs_to :player, Player
  end

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, [:player_id, :tag])
    |> validate_required([:player_id, :tag])
  end
end
