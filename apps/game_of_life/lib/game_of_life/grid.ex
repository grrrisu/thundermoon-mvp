defmodule GameOfLife.Grid do
  use GenServer, restart: :temporary

  alias Sim.Torus, as: Grid

  alias ThundermoonWeb.PubSub
  alias GameOfLife.Simulation

  def start_link(size) do
    GenServer.start_link(__MODULE__, size, name: __MODULE__)
  end

  def init(size) do
    {:ok, %{grid: create(size)}}
  end

  def handle_call(:get_grid, _from, state) do
    {:reply, state.grid, state}
  end

  def handle_call({:set_grid, grid}, _from, state) do
    broadcast(grid)
    {:reply, grid, %{state | grid: grid}}
  end

  def handle_call({:toggle, x, y}, _from, state) do
    value = Grid.get(state.grid, x, y)
    new_grid = Grid.put(state.grid, x, y, not value)
    broadcast(new_grid)
    {:reply, new_grid, %{state | grid: new_grid}}
  end

  def handle_call(:clear, _from, state) do
    new_grid = Grid.create(Grid.width(state.grid), Grid.height(state.grid), false)
    broadcast(new_grid)
    {:reply, new_grid, %{state | grid: new_grid}}
  end

  def handle_call(:sim, _from, %{grid: grid} = state) do
    case execute_task(grid) do
      {:exit, reason} ->
        {:reply, {:error, reason}, state}

      {:ok, grid} ->
        :ok = broadcast(grid)
        {:reply, :ok, %{state | grid: grid}}
    end
  end

  defp execute_task(grid) do
    Task.Supervisor.async_nolink(Sim.TaskSupervisor, fn ->
      Simulation.sim(grid)
    end)
    |> Task.yield()
  end

  def create(%{size: size}) do
    Grid.create(size, size, fn _x, _y ->
      :rand.uniform(3) == 1
    end)
  end

  defp broadcast(grid) do
    Phoenix.PubSub.broadcast(PubSub, "Thundermoon.GameOfLife", {:update, grid: grid})
  end
end