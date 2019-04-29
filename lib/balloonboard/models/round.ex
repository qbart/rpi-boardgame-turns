defmodule Round do
  use Ecto.Schema

  schema "rounds" do
    field :started_at, :naive_datetime
    field :stopped_at, :naive_datetime
    field :player, :integer

    belongs_to :session, Session
  end
end
