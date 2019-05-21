defmodule Balloonboard.Repo.Migrations.AddConfigToSession do
  use Ecto.Migration

  def up do
    alter table(:sessions) do
      add :config, :map, null: false, default: %{}
    end
  end

  def down do
    alter table(:sessions) do
      remove :config
    end
  end
end
