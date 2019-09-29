defmodule Balloonboard.Repo.Migrations.AddRoundStats do
  use Ecto.Migration

  def up do
    execute """
    CREATE VIEW round_live_stats AS
    SELECT
      s.id AS session_id,
      p.player_id AS player_id,
      r.id AS round_id,
      s.config,
      r.id IS NOT NULL AND stopped_at IS NULL AS round_active,
      ROW_NUMBER() OVER all_rounds AS round_index,
      COUNT(*) FILTER (WHERE stopped_at IS NOT NULL) OVER all_rounds AS round_count,
      COALESCE(seconds(COALESCE(stopped_at, now_utc()) - started_at), 0)::bigint AS round_duration,
      COALESCE(SUM(seconds(COALESCE(stopped_at, now_utc()) - started_at)) OVER all_rounds, 0)::bigint AS total_duration
    FROM
      sessions s
    JOIN active_players p ON p.session_id = s.id
    LEFT JOIN rounds r ON r.session_id = s.id AND r.player_id = p.player_id
    WHERE s.active
    WINDOW all_rounds AS (PARTITION BY s.id, p.id ORDER BY r.id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
  """
  end

  def down do
    execute "DROP VIEW round_live_stats"
  end
end
