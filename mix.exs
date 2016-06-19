defmodule Issues.Mixfile do
  use Mix.Project

  def project do
    [
      app: :issues,
      version: "0.0.1",
      elixir: "~> 1.2",
      escript: [main_module: Issues.CLI],
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps
    ]
  end

  def application do
    [applications: [:logger, :httpoison, :poison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.8"},
      {:poison, "~> 2.1"}
    ]
  end
end
