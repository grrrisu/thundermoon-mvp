defmodule Test.Dummy do
  use Sim.Realm, app_module: __MODULE__

  alias Test.Dummy.Factory

  def create(size) do
    create(Factory, %{initial: 0})
  end
end
