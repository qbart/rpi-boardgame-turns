defmodule Player do
  use Ecto.Schema

  schema "players" do
    field :name, :string
    field :color, :string
    field :avatar, :string
  end
end
