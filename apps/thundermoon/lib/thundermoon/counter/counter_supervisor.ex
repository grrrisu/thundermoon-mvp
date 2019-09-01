defmodule Thundermoon.CounterSupervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {DynamicSupervisor, name: Thundermoon.DigitSupervisor, strategy: :one_for_one},
      {Thundermoon.Counter, name: Thundermoon.Counter}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end