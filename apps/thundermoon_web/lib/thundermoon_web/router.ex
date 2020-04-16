defmodule ThundermoonWeb.Router do
  use ThundermoonWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ThundermoonWeb.AuthPlug
    plug :put_root_layout, {ThundermoonWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :public do
    plug :browser
  end

  pipeline :private do
    plug :browser
    plug ThundermoonWeb.MemberareaPlug
  end

  scope "/", ThundermoonWeb do
    pipe_through :public

    get "/", PageController, :index

    get "/auth/github", AuthController, :request
    get "/auth/integration", AuthController, :integration
    get "/auth/github/callback", AuthController, :callback
    delete "/auth", AuthController, :delete
  end

  scope "/", ThundermoonWeb do
    pipe_through :private

    get "/dashboard", PageController, :dashboard
    resources "/users", UserController, only: [:index, :edit, :update, :delete]
    live "/chat", ChatLive
    live "/counter", CounterLive
    live "/game_of_life", GameOfLifeLive
  end
end
