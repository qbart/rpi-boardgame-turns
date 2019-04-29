defmodule Balloonboard.Repo do
  use Ecto.Repo,
    otp_app: :balloonboard,
    adapter: Ecto.Adapters.Postgres
end
