defmodule Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :uid, Ecto.UUID
    field :active, :boolean
    field :config, :map
    timestamps()

    has_many :rounds, Round
    has_many :used_tags, UsedTag
  end

  def changeset(session, params \\ %{}) do
    session
    |> cast(params, [:uid, :active])
    |> validate_required([:uid])
  end

end
