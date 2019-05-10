defmodule Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :uid, Ecto.UUID
    field :active, :boolean
    timestamps()

    has_many :rounds, Round
  end

  def changeset(session, params \\ %{}) do
    session
    |> cast(params, [:uid, :active])
    |> validate_required([:uid])
  end

end
