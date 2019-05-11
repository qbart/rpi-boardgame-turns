defmodule Balloonboard.Repo.Migrations.CreateFnNowUtc do
  use Ecto.Migration

  def up do
    execute("""
    CREATE OR REPLACE FUNCTION now_utc() RETURNS TIMESTAMP WITHOUT TIME ZONE
      AS
      $$
        BEGIN
          RETURN CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
        END;
      $$
      STABLE
      STRICT
      LANGUAGE plpgsql
    """)
  end

  def down do
    execute("DROP FUNCTION now_utc()")
  end
end
