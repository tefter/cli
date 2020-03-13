defmodule TefterCli.MixProject do
  use Mix.Project

  def project do
    [
      app: :tefter_cli,
      version: "0.2.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {TefterCli.Application, []}
    ]
  end

  defp deps do
    [
      {:ratatouille, "~> 0.5.0"},
      {:tesla, "~> 1.2.0"},
      {:jason, "~> 1.1"},
      {:logger_file_backend, "~> 0.0.11"},
      {:ace, "~> 0.18"},
      {:porcelain, "~> 2.0"}
    ]
  end
end
