defmodule RoundLiveStats do
  use Ecto.Schema
  import Ecto.Query
  alias Balloonboard.Repo

  @primary_key false

  schema "round_live_stats" do
    field :session_id, :integer, primary_key: true
    field :player_id, :integer, primary_key: true
    field :round_id, :integer, primary_key: true
    field :round_active, :boolean
    field :round_index, :integer
    field :round_count, :integer
    field :round_duration, :integer
    field :total_duration, :integer
  end

  def for(session_id) do
    Repo.all(
      from s in RoundLiveStats,
        where: s.session_id == ^session_id,
        select:
          map(s, [
            :player_id,
            :session_id,
            :round_id,
            :round_active,
            :round_index,
            :round_count,
            :round_duration,
            :total_duration
          ]),
          order_by: [asc: :round_id]
    )
  end
end
