defmodule Balloonboard.Repo.Migrations.CreateActivePlayers do
  use Ecto.Migration

  def change do
    create table("active_players") do
      add :session_id, references(:sessions), null: false
      add :player_id, references(:players), null: false
      add :position, :integer, null: false
    end

    create index("active_players", [:session_id, :player_id, :position], unique: true)
  end
end
