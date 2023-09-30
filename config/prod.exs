import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Acme.Finch

# Do not print debug messages in production
config :logger, level: :info

config :acme, MyApp.Mailer, adapter: Resend.Swoosh.Adapter

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
