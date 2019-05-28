defmodule ActivePlayer do
  use Ecto.Schema

  schema "active_players" do
    field :position, :integer

    belongs_to :session, Session
    belongs_to :player, Player
  end
end
