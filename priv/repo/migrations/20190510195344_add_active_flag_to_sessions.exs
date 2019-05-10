defmodule Balloonboard.Repo.Migrations.AddActiveFlagToSessions do
  use Ecto.Migration

  def up do
    alter table("sessions") do
      add :active, :boolean, null: false, default: true
    end

    execute """
    UPDATE sessions s SET active = FALSE
    WHERE NOT EXISTS (SELECT 1 FROM rounds r WHERE s.id = r.session_id AND r.stopped_at IS NULL)
    """

    create index("sessions", [:active], where: "active IS TRUE")
  end

  def down do
    alter table("sessions") do
      remove :active
    end
  end
end
