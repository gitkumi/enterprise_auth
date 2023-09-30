defmodule AcmeWeb.Router do
  use AcmeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  pipeline :auth do
    plug :accepts, ["json"]
    plug Acme.AuthAccessPipeline
  end

  scope "/api", AcmeWeb do
    pipe_through [:api]

    post "/users/register", UserRegistrationController, :create
    post "/users/log_in", UserLoginController, :create

    post "/users/confirm", UserConfirmationController, :create
    post "/users/confirm/:token", UserConfirmationController, :update

    post "/users/reset_password", UserResetPasswordController, :create
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/api", AcmeWeb do
    pipe_through [:api, :auth]

    get "/users/me", UserMeController, :show
    put "/users/settings", UserSettingsController, :update
    post "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:acme, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: AcmeWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
