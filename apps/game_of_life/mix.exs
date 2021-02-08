defmodule GameOfLife.MixProject do
  use Mix.Project

  def project do
    [
      app: :game_of_life,
      version: "0.3.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.10",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {GameOfLife.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(env) when env in [:test, :integration], do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:sim, in_umbrella: true},
      {:phoenix_pubsub, "~> 2.0"},
      {:credo, "~> 1.5.0-rc.2",
       git: "git://github.com/grrrisu/credo.git",
       branch: "fix-option-min-priority",
       only: [:dev, :test],
       runtime: false}
    ]
  end
end
