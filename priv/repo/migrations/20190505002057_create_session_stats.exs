defmodule Balloonboard.Repo.Migrations.CreateSessionStats do
  use Ecto.Migration

  def up do
    execute("""
    CREATE view session_stats AS
      SELECT
                s.id AS session_id,
                p.player,
                COUNT(*) FILTER (WHERE stopped_at IS NOT NULL) AS finished_rounds,
                extract(epoch FROM coalesce( date_trunc('second', sum( coalesce(stopped_at, (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::TIMESTAMP WITHOUT TIME ZONE) - started_at ) FILTER (WHERE stopped_at IS NULL)), '00:00:00' )::INTERVAL)::BIGINT AS round_duration,
                extract(epoch FROM coalesce( date_trunc('second', sum( coalesce(stopped_at, (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::TIMESTAMP WITHOUT TIME ZONE) - started_at )), '00:00:00' )::INTERVAL )::BIGINT                                  AS total_duration
      FROM
        sessions s
      CROSS JOIN
                (
                        SELECT *
                        FROM   generate_series(1,2) AS player) p
      LEFT JOIN  rounds r
      ON         r.session_id = s.id
      AND        r.player = p.player
      GROUP BY   s.id,
                p.player
      ORDER BY   s.id,
                p.player;
    """)
  end

  def down do
    execute("DROP VIEW session_stats")
  end
end
