defmodule Balloonboard.Repo.Migrations.CreateFnSeconds do
  use Ecto.Migration

  def up do
    execute("""
    CREATE FUNCTION seconds(i interval) RETURNS BIGINT
      AS
      $$
      BEGIN
        RETURN EXTRACT(EPOCH FROM date_trunc('second', i))::BIGINT;
      END;
      $$
      IMMUTABLE
      STRICT
      LANGUAGE plpgsql
    """)
  end

  def down do
    execute("DROP FUNCTION seconds(interval)")
  end
end
