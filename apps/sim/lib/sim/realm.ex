defmodule Sim.Realm do
  @moduledoc """
  The context for realm
  """
  alias Sim.Realm.CommandGuard

  def server_name(name, server) do
    Module.concat(name, server)
  end

  defmacro __using__(opts) do
    app_module = opts[:app_module]

    quote do
      alias Sim.Realm
      alias Sim.Realm.{Data, SimulationLoop}

      @supervisor Realm.server_name(unquote(app_module), "Supervisor")
      @server Realm.server_name(unquote(app_module), "CommandGuard")
      @simulation_loop Realm.server_name(unquote(app_module), "SimulationLoop")
      @data Realm.server_name(unquote(app_module), "Data")

      def get_root() do
        Data.get_data(@data)
      end

      def send_command(command) do
        CommandGuard.receive(@server, command)
      end

      def create(config) do
        send_command(%{command: :create, config: config})
      end

      def recreate(config) do
        stop_sim()
        create(config)
      end

      def restart() do
        @supervisor
        |> Process.whereis()
        |> Process.exit(:normal)
      end

      def start_sim(delay \\ 1_000, command \\ %{command: :sim}) do
        send_command(%{command: :start, delay: delay})
      end

      def stop_sim() do
        send_command(%{command: :stop})
      end

      def started?() do
        SimulationLoop.running?(@simulation_loop)
      end
    end
  end
end
