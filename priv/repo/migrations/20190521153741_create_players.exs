defmodule Balloonboard.Repo.Migrations.CreatePlayers do
  use Ecto.Migration
  alias Balloonboard.Repo

  def up do
    create table("players") do
      add :name, :varchar, null: false
      add :color, :varchar, null: false
      add :avatar, :varchar, null: false
    end

    create index("players", [:name], unique: true)

    flush()

    Repo.insert!(%Player{name: "Jake", color: "#FFB400", avatar: "file:///jake.png"})
    Repo.insert!(%Player{name: "Finn", color: "#119ADD", avatar: "file:///finn.png"})
    Repo.insert!(%Player{name: "BMO", color: "#59AA99", avatar: "file:///bmo.png"})
  end

  def down do
    drop table("players")
  end
end
