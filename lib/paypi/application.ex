defmodule Paypi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Paypi.Repo,
      # Starts a worker by calling: Paypi.Worker.start_link(arg)
      # {Paypi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Paypi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
