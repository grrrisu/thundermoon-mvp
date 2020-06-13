defmodule GameOfLife.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Sim.Realm.Supervisor
    ]

    opts = [strategy: :one_for_one, name: GameOfLife.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
