defmodule SessionLiveStats do
  use Ecto.Schema
  import Ecto.Query
  alias Balloonboard.Repo

  @primary_key false

  schema "session_live_stats" do
    field :session_id, :integer, primary_key: true
    field :player, :integer, primary_key: true
    field :finished_rounds, :integer
    field :round_duration, :integer
    field :total_duration, :integer
    field :total_duration_without_active_round, :integer
    field :tags, :map
  end

  def for(session_id) do
    Repo.all(
      from s in SessionLiveStats,
        where: s.session_id == ^session_id,
        select:
          map(s, [
            :player,
            :finished_rounds,
            :tags,
            :round_duration,
            :total_duration,
            :total_duration_without_active_round
          ])
    )
  end
end
