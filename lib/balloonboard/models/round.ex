defmodule Round do
  use Ecto.Schema

  alias Balloonboard.Repo
  import Ecto.Query, only: [from: 2]

  schema "rounds" do
    field :started_at, :naive_datetime
    field :stopped_at, :naive_datetime

    belongs_to :player, Player
    belongs_to :session, Session
  end

  # TODO: wrap into transaction
  def switch_player(session_id, player) do
    now = TimeUtils.now()

    query =
      from r in Round,
        where: r.session_id == ^session_id and is_nil(r.stopped_at)

    Repo.update_all(query, set: [stopped_at: now])

    Repo.insert(%Round{
      session_id: session_id,
      player_id: player,
      started_at: now,
      stopped_at: nil
    })
  end

  def can_player_finish?(session_id, player) do
    Repo.exists?(
      from r in Round,
        where:
          r.session_id == ^session_id and
            is_nil(r.stopped_at) and
            r.player_id == ^player
    )
  end

  def clear_unstopped(session_id) do
    Repo.delete_all(
      from r in Round,
        where:
          r.session_id == ^session_id and
            is_nil(r.stopped_at)
    )
  end
end
