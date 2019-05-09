defmodule Balloonboard.Repo.Migrations.CreateSessionLiveStats do
  use Ecto.Migration

  def up do
    execute("""
        CREATE VIEW session_live_stats AS
        WITH players AS (
            SELECT
                *
            FROM
                generate_series(1, 2) AS player
        ),
        active_sessions AS (
            SELECT
                *
            FROM
                sessions s
            WHERE
                EXISTS (
                    SELECT
                        1
                    FROM
                        rounds r
                    WHERE
                        r.stopped_at IS NULL
                        AND r.session_id = s.id)
        ),
        session_tags AS (
            SELECT
                s.id, ut.player, t.tag, COUNT(t.tag) AS total
            FROM
                active_sessions s
            LEFT JOIN used_tags ut ON ut.session_id = s.id
            LEFT JOIN tags t ON ut.tag_id = t.id
        GROUP BY
            s.id,
            ut.player,
            t.tag
        ),
        grouped_tags AS (
            SELECT
                s.id,
                s.player,
                jsonb_object_agg(tag, total) AS tags
            FROM
                session_tags s
            WHERE
                s.total > 0
            GROUP BY
                s.id,
                s.player
        ),
        stats AS (
            SELECT
                s.id AS session_id,
                p.player,
                COUNT(*) FILTER (WHERE stopped_at IS NOT NULL) AS finished_rounds,
                extract(epoch FROM coalesce(date_trunc('second', sum(coalesce(stopped_at, (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::TIMESTAMP WITHOUT TIME ZONE) - started_at) FILTER (WHERE stopped_at IS NULL)), '00:00:00')::INTERVAL)::BIGINT AS round_duration,
                extract(epoch FROM coalesce(date_trunc('second', sum(coalesce(stopped_at, (CURRENT_TIMESTAMP AT TIME ZONE 'UTC')::TIMESTAMP WITHOUT TIME ZONE) - started_at)), '00:00:00')::INTERVAL)::BIGINT AS total_duration,
                extract(epoch FROM coalesce(date_trunc('second', sum(stopped_at - started_at) FILTER (WHERE stopped_at IS NOT NULL)), '00:00:00')::INTERVAL)::BIGINT AS total_duration_without_active_round FROM active_sessions s
            CROSS JOIN players p
            LEFT JOIN rounds r ON r.session_id = s.id
                AND r.player = p.player
            GROUP BY
                s.id,
                p.player
        )
        SELECT
            s.*,
            COALESCE(st.tags, '{}')::jsonb AS tags
        FROM
            stats s
            LEFT JOIN grouped_tags st ON st.id = s.session_id
                AND st.player = s.player;
    """)
  end

  def down do
    execute("DROP VIEW session_live_stats")
  end
end
