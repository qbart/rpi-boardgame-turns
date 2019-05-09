defmodule BalloonboardWeb.Router do
  use BalloonboardWeb, :router

  pipeline :browser do
    plug BasicAuth, use_config: {:basic_auth, :simple_auth}
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # scope "/api", BalloonboardWeb do
  #   pipe_through :api
  # end

  scope "/", BalloonboardWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/tags", TagController, only: [:new, :create]

    resources "/sessions", SessionController, only: [:new, :create, :show] do
      post "/stop", SessionController, :stop, as: :stop
    end
  end
end
