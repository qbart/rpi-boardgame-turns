defmodule Session do
  alias Balloonboard.Repo
  use Ecto.Schema
  import Ecto.Changeset
  alias Balloonboard.Repo

  schema "sessions" do
    field :uid, Ecto.UUID
    field :active, :boolean
    field :config, :map
    timestamps()

    has_many :rounds, Round
    has_many :used_tags, UsedTag
  end

  def destroy(id) do
    session = Repo.get(Session, id)
    Repo.delete!(session)
  end

  def start(player_ids) do
    Repo.transaction(fn ->
      session = Repo.insert!(%Session{uid: Ecto.UUID.generate()})
      # TODO add active player
      Repo.insert!(%Round{
        session_id: session.id,
        player: List.first(player_ids),
        started_at: TimeUtils.now(),
        stopped_at: nil
      })

      session
    end)
  end

  def changeset(session, params \\ %{}) do
    session
    |> cast(params, [:uid, :active])
    |> validate_required([:uid])
  end
end
