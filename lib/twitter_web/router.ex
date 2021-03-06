defmodule TwitterWeb.Router do
  use TwitterWeb, :router

  import TwitterWeb.Plug.Session, only: [redirect_unauthorized: 2, validate_session: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TwitterWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :validate_session
  end

  pipeline :restricted do
    plug :browser
    plug :redirect_unauthorized
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TwitterWeb do
    pipe_through :browser

    get "/logout", LogoutController, :index
    live "/", LoginLive, :index
  end

  scope "/friends", TwitterWeb do
    pipe_through :restricted

    live "/", FriendsLive, :index
    live "/invites", InvitesLive, :index
    live "/search", SearchLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TwitterWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TwitterWeb.Telemetry
    end
  end
end
