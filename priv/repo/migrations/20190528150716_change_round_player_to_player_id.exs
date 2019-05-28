defmodule Balloonboard.Repo.Migrations.ChangeRoundPlayerToPlayerId do
  use Ecto.Migration

  def up do
    execute "DROP VIEW session_live_stats"

    rename table(:rounds), :player, to: :player_id
    rename table(:used_tags), :player, to: :player_id
    rename table(:tags), :player, to: :player_id

    alter table(:rounds) do
      modify :player_id, references(:players)
    end
    alter table(:used_tags) do
      modify :player_id, references(:players)
    end

    execute """
    CREATE OR REPLACE VIEW session_live_stats AS
    WITH session_tags AS (
        SELECT
            s.id, ut.player_id, jsonb_count(t.tag) AS tags
        FROM
            sessions s
        LEFT JOIN used_tags ut ON ut.session_id = s.id
        LEFT JOIN tags t ON ut.tag_id = t.id
        WHERE s.active
      GROUP BY
        s.id,
        ut.player_id
      ), stats AS (
        SELECT
          s.id AS session_id,
          p.player_id,
          COUNT(*) FILTER (WHERE stopped_at IS NOT NULL) AS finished_rounds,
          COALESCE(SUM(seconds(COALESCE(stopped_at, now_utc()) - started_at)) FILTER (WHERE stopped_at IS NULL), 0)::bigint AS round_duration,
          COALESCE(SUM(seconds(COALESCE(stopped_at, now_utc()) - started_at)), 0)::bigint AS total_duration,
          COALESCE(SUM(seconds(stopped_at - started_at)) FILTER (WHERE stopped_at IS NOT NULL), 0)::bigint AS total_duration_without_active_round
        FROM sessions s
        JOIN active_players p ON p.session_id = s.id
        LEFT JOIN rounds r ON r.session_id = s.id AND r.player_id = p.player_id
        WHERE s.active
        GROUP BY
            s.id,
            p.player_id
      )
      SELECT
        s.*,
        COALESCE(st.tags, '{}')::jsonb AS tags
      FROM
        stats s
        LEFT JOIN session_tags st ON st.id = s.session_id
              AND st.player_id = s.player_id;
    """
  end

  def down do
    raise Ecto.MigrationError, "Can't restore it"
  end
end
