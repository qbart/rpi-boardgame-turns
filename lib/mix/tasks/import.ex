defmodule Mix.Tasks.Import do
  use Mix.Task
  alias NimbleCSV.RFC4180, as: CSV
  alias Balloonboard.Repo
  alias Ecto.Multi, as: Tx
  import Mix.EctoSQL

  @shortdoc "Imports old entries"
  def run(_) do
    {:ok, _pid, _apps} = ensure_started(Repo, [])

    tx = Tx.new()
    Path.wildcard("lib/mix/tasks/csv/*.csv")
    |> Enum.each(fn path ->
      IO.puts("Importing #{path}")
      data = File.read!(path) |> CSV.parse_string(separator: ",")
      tx
        |> Tx.insert(:session, %Session{uid: Ecto.UUID.generate()})
        |> Tx.run("after_insert_#{path}", fn _repo, %{session: session} ->
          Enum.each(data, fn [player, started_at, stopped_at] ->
            tx
            |> Tx.insert(:round, %Round{
              session_id: session.id,
              player: String.to_integer(player),
              started_at: timestamp(String.to_integer(started_at)),
              stopped_at: timestamp(String.to_integer(stopped_at))
            })
            |> Repo.transaction()
          end)
          {:ok, nil}
        end)
        |> Repo.transaction()
    end)
  end

  def timestamp(unix_time) do
    DateTime.from_unix!(unix_time)
    |> DateTime.to_naive
end
end
