defmodule Balloonboard.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table("sessions") do
      add :uid, :uuid, null: false
      timestamps()
    end

    create index("sessions", [:uid], unique: true)
  end
end
