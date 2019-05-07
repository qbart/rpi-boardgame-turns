defmodule Balloonboard.Repo.Migrations.CreateRounds do
  use Ecto.Migration

  def change do
    create table("rounds") do
      add :session_id, references(:sessions), null: false
      add :started_at, :timestamp, null: false
      add :stopped_at, :timestamp, null: true
      add :player, :int, null: false
    end

    create index("rounds", [:session_id])
    create index("rounds", [:started_at, :stopped_at])
  end
end
