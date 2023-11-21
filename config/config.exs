# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :acme,
  ecto_repos: [Acme.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :acme, AcmeWeb.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: AcmeWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Acme.PubSub,
  live_view: [signing_salt: "4GiiOayF"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :acme, Acme.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :acme, Acme.Guardian,
  issuer: "acme",
  secret_key: "n5n7bZTH9I6SVX6Fh5XAwbSgC0eYTj+1ti6rc7XfZRdIec2UpcKv7NucOnGrCv1A"

config :acme, Acme.AuthAccessPipeline,
  module: Acme.Guardian,
  error_handler: Acme.AuthErrorHandler

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
