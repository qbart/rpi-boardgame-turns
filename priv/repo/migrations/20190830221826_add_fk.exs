defmodule Balloonboard.Repo.Migrations.AddFk do
  use Ecto.Migration

  def up do
    execute("ALTER TABLE rounds DROP CONSTRAINT rounds_session_id_fkey")
    execute(
      "ALTER TABLE rounds ADD CONSTRAINT rounds_session_id_fkey FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE"
    )

    execute("ALTER TABLE used_tags DROP CONSTRAINT used_tags_session_id_fkey")
    execute(
      "ALTER TABLE used_tags ADD CONSTRAINT used_tags_session_id_fkey FOREIGN KEY (session_id) REFERENCES sessions(id) ON DELETE CASCADE"
    )
  end

  def down do
    execute("ALTER TABLE rounds DROP CONSTRAINT rounds_session_id_fkey")
    execute(
      "ALTER TABLE rounds ADD CONSTRAINT rounds_session_id_fkey FOREIGN KEY (session_id) REFERENCES sessions(id)"
    )

    execute("ALTER TABLE used_tags DROP CONSTRAINT used_tags_session_id_fkey")
    execute(
      "ALTER TABLE used_tags ADD CONSTRAINT used_tags_session_id_fkey FOREIGN KEY (session_id) REFERENCES sessions(id)"
    )
  end
end
