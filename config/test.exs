import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :stripe_setup, StripeSetup.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "stripe_setup_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :stripe_setup, StripeSetupWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+OSKwsoHraKd6dq+uMVML0oftVfR/YbUtgbB4grpXH59TLUMBB3fVUIkjHf2BkX/",
  server: false

# In test we don't send emails.
config :stripe_setup, StripeSetup.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :stripe_setup, stripe_service: MockStripe
