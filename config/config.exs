# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# Configures Ecto Repo Bank API.
config :bank_api,
  ecto_repos: [BankAPI.Repo]

# Configures the Bank API endpoint
config :bank_api, BankAPIWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BankAPIWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BankAPI.PubSub,
  live_view: [signing_salt: "2BoiLZwy"]

# Configures the Bank UI endpoint
config :bank_ui, BankUIWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BankUIWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BankUI.PubSub,
  live_view: [signing_salt: "9I1yp41s"]

config :bank_ui,
  api_url: System.fetch_env!("API_URL")

# Configure esbuild for Bank UI project (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/bank_ui/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

  # Configure TailwindCSS for BankUI project
config :tailwind, version: "3.2.6", default: [
  args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
  cd: Path.expand("../apps/bank_ui/assets", __DIR__)
]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"