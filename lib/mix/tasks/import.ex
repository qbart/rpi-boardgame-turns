defmodule Mix.Tasks.Import do
  use Mix.Task
  alias NimbleCSV.RFC4180, as: CSV
  alias Balloonboard.Repo
  alias Ecto.Multi, as: Tx
  import Mix.EctoSQL

  @shortdoc "Imports old entries"
  def run(_) do
    {:ok, _pid, _apps} = ensure_started(Repo, [])

    Repo.transaction(fn ->
      Repo.insert!(%Tag{player: 0, tag: "👮"})
      Repo.insert!(%Tag{player: 0, tag: "🧐"})
      Repo.insert!(%Tag{player: 0, tag: "🤯"})
      Repo.insert!(%Tag{player: 0, tag: "🤣"})
      Repo.insert!(%Tag{player: 0, tag: "🤫"})
      Repo.insert!(%Tag{player: 0, tag: "💬"})
      Repo.insert!(%Tag{player: 0, tag: "😱"})
      Repo.insert!(%Tag{player: 1, tag: "🤮"})


      Path.wildcard("lib/mix/tasks/csv/*.csv")
      |> Enum.each(fn path ->
        IO.puts("Importing #{path}")
        data = File.read!(path) |> CSV.parse_string(separator: ",")
        session = Repo.insert!(%Session{uid: Ecto.UUID.generate()})

        Enum.each(data, fn [player, started_at, stopped_at] ->
          Repo.insert!(%Round{
            session_id: session.id,
            player: String.to_integer(player),
            started_at: timestamp(String.to_integer(started_at)),
            stopped_at: timestamp(String.to_integer(stopped_at))
          })
        end)
      end)
    end)
  end

  def timestamp(unix_time) do
    DateTime.from_unix!(unix_time)
    |> DateTime.to_naive()
  end
end
