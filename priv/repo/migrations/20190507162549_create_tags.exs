defmodule Balloonboard.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table("tags") do
      add :player, :int, null: false
      add :tag, :varchar, null: false
    end

    create index("tags", [:player, :tag], unique: true)
  end
end
