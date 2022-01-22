defmodule Paypi.Repo do
  use Ecto.Repo,
    otp_app: :paypi,
    adapter: Ecto.Adapters.SQLite3
end
