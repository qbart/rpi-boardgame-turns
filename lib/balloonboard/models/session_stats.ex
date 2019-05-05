defmodule SessionStats do
  use Ecto.Schema
  import Ecto.Query
  alias Balloonboard.Repo

  @primary_key false

  schema "session_stats" do
    field :session_id, :integer, primary_key: true
    field :player, :integer, primary_key: true
    field :finished_rounds, :integer
    field :round_duration, :integer
    field :total_duration, :integer
  end

  def for(session_id) do
    Repo.all(
      from s in SessionStats,
      where: s.session_id == ^session_id,
      select: map(s, [:player, :finished_rounds, :round_duration, :total_duration])
    )
  end
end
