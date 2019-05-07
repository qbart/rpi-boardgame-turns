defmodule Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :player, :integer
    field :tag, :string
  end

  def changeset(tag, params \\ %{}) do
    tag
    |> cast(params, [:player, :tag])
    |> validate_required([:player, :tag])
  end
end
