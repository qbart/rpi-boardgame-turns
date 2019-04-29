defmodule Balloonboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Balloonboard.Repo,
      # Start the endpoint when the application starts
      BalloonboardWeb.Endpoint
      # Starts a worker by calling: Balloonboard.Worker.start_link(arg)
      # {Balloonboard.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Balloonboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BalloonboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
