defmodule Session do
  use Ecto.Schema

  schema "sessions" do
    field :uid, Ecto.UUID
    timestamps()

    has_many :rounds, Round
  end
end
