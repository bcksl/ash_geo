defmodule AshGeo.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/bcksl/ash_geo"
  @description "Tools for using Geo, Topo and PostGIS with Ash"

  def project do
    [
      app: :ash_geo,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: preferred_cli_env(),
      deps: deps(),
      package: package(),
      test_coverage: test_coverage(),
      docs: docs(),
      name: "AshGeo",
      description: @description
    ]
  end

  IO.puts(Mix.env())

  if Mix.env() == :test do
    def application() do
      [
        mod: {AshGeo.Test.Application, []}
      ]

      # applications: [:ecto, :ecto_sql, :jason, :ash, :postgrex, :geo, :ash_postgres]
    end
  end

  defp elixirc_paths(:test), do: ~w(lib test/support)
  defp elixirc_paths(_), do: ~w(lib)

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:geo, "~> 3.4"},
      {:topo, "~> 1.0"},
      {:ash, "~> 2.9"},
      {:geo_postgis, "~> 3.4", only: :test},
      {:ash_postgres, "~> 1.3", only: :test},

      # Testing, documentation, and release tools
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.12.2", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.21.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.6", only: :test},
      {:ex_check, "~> 0.15.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.29.4", only: [:dev, :test], runtime: false},
      {:git_ops, "~> 2.5.6", only: :dev}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      formatters: ~w(html epub),
      extras: ~w(README.md)
    ]
  end

  defp test_coverage do
    [tool: ExCoveralls]
  end

  defp package do
    [
      name: "ash_geo",
      files: ~w(.formatter.exs config lib mix.exs README* LICENSE*),
      maintainers: ~w(bcksl),
      licenses: ~w(MIT),
      links: %{
        Documentation: "https://hexdocs.pm/ash_geo",
        GitHub: @source_url
      }
    ]
  end

  def cli do
    [
      preferred_envs: preferred_cli_env()
    ]
  end

  def preferred_cli_env do
    [
      test: :test,
      docs: :test,
      format: :test,
      check: :test,
      coveralls: :test,
      "coveralls.detail": :test,
      "coveralls.post": :test,
      "coveralls.html": :test,
      "coveralls.github": :test,
      "ash_postgres.create": :test,
      "ash_postgres.generate_migrations": :test,
      "ash_postgres.migrate": :test,
      "ash_postgres.drop": :test
    ]
  end
end
