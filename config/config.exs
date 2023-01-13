# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :glossary,
  ecto_repos: [Glossary.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :glossary, GlossaryWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: GlossaryWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Glossary.PubSub,
  live_view: [signing_salt: "mvKdYkzY"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :glossary, Glossary.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Configures Waffle
config :waffle,
  storage: Waffle.Storage.Local

# Configures Swagger
config :glossary, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: GlossaryWeb.Router,
      endpoint: GlossaryWeb.Endpoint
    ]
  }

config :phoenix_swagger, json_library: Jason
