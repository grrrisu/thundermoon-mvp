defmodule LotkaVolterra.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Sim.Realm.Supervisor, name: LotkaVolterra}
    ]

    opts = [strategy: :one_for_one, name: LotkaVolterra.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
