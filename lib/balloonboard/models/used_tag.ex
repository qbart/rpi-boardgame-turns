defmodule UsedTag do
  use Ecto.Schema

  schema "used_tags" do
    field :player, :integer
    field :tagged_at, :naive_datetime
    field :comment, :string

    belongs_to :session, Session
    belongs_to :tag, Tag
  end
end
