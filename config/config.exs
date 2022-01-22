import Config

config :paypi, Paypi.Repo,
  database: "paypi.db"

config :paypi, ecto_repos: [Paypi.Repo]
