use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :checkers, CheckersWeb.Endpoint,
  secret_key_base: "4tjR+ysYldI6pufVpUWq5+Qlv6N/gvWo8X8ZaZoJP83S4EfUFXy7QKQN8vI6udYA"

# Configure your database
config :checkers, Checkers.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "checkers_prod",
  pool_size: 15
