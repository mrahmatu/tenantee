defmodule TenanteeWeb.Router do
  use TenanteeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TenanteeWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TenanteeWeb do
    pipe_through :browser

    live "/", HomeLive

    scope "/properties" do
      live "/", PropertyLive.List
      live "/new", PropertyLive.Add
      live "/:id", PropertyLive.Edit
    end

    scope "/tenants" do
      live "/", TenantLive.List
      live "/new", TenantLive.Add
      live "/:id", TenantLive.Edit
    end

    live "/settings", ConfigLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", TenanteeWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:tenantee, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TenanteeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end