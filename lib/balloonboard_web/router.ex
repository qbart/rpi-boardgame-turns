defmodule BalloonboardWeb.Router do
  use BalloonboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BalloonboardWeb do
    pipe_through :api

    resources "/sessions", Api.SessionController, only: [] do
      post "/rounds/start", Api.RoundController, :start
      post "/rounds/stop", Api.RoundController, :stop
    end
  end

  scope "/", BalloonboardWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", BalloonboardWeb do
  #   pipe_through :api
  # end
end
