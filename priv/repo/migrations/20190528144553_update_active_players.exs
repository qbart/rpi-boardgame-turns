defmodule Balloonboard.Repo.Migrations.UpdateActivePlayers do
  use Ecto.Migration

  def up do
    execute """
    WITH all_places AS (
      SELECT
        r.session_id,
        row_number() OVER (PARTITION BY r.session_id ORDER BY r.started_at) AS position,
        r.player AS player_id
      FROM rounds r
      ), places AS (
        SELECT session_id, player_id, position FROM all_places WHERE position <= 2
      ), old_sessions AS (
      SELECT
        s.id AS session_id,
        p.player_id,
        p.position
      FROM sessions s
      JOIN places p ON p.session_id = s.id
      LEFT JOIN active_players ap ON ap.session_id = s.id AND ap.player_id = p.player_id
      WHERE ap.id IS NULL
      )
      INSERT INTO active_players(session_id, player_id, position)
      SELECT session_id, player_id, position FROM old_sessions
    """
  end

  def down do
  end
end
