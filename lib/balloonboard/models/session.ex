defmodule Session do
  use Ecto.Schema

    # Ecto.UUID.generate

  schema "sessions" do
    field :uid, Ecto.UUID
    timestamps()

    has_many :rounds, Round
  end
end
