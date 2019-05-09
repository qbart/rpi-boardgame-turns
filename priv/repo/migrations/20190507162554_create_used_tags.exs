defmodule Balloonboard.Repo.Migrations.CreateUsedTags do
  use Ecto.Migration

  def change do
    create table("used_tags") do
      add :session_id, references(:sessions), null: false
      add :tag_id, references(:tags), null: false
      add :player, :integer, null: false
      add :tagged_at, :timestamp, null: false
      add :comment, :varchar, null: true
    end

    create index("used_tags", [:session_id])
    create index("used_tags", [:tag_id])
    create index("used_tags", [:tagged_at])
  end
end
