defmodule Balloonboard.Repo.Migrations.CreateFnAggJsonbCount do
  use Ecto.Migration

  def up do
    execute("""
    CREATE FUNCTION jsonb_count__transition(state jsonb, key anyelement) RETURNS jsonb
    AS
    $$
      BEGIN
        RETURN jsonb_set(
          state,
          ARRAY[key]::varchar[],
          (COALESCE((state->>(key::varchar))::numeric, 0) + 1)::varchar::jsonb
        );
      END;
    $$
    IMMUTABLE
    STRICT
    LANGUAGE plpgsql;
    """)

    execute("""
    CREATE AGGREGATE jsonb_count(anyelement)
    (
        sfunc = jsonb_count__transition,
        stype = jsonb,
        initcond = '{}'
    );
    """)
  end

  def down do
    execute("DROP AGGREGATE jsonb_count(anyelement)")
    execute("DROP FUNCTION jsonb_count__transition(jsonb, anyelement)")
  end
end
