defmodule AshGeo.MixProject do
  use Mix.Project

  @name :ash_geo
  @version "0.1.3"
  @description "Tools for using Geo, Topo and PostGIS with Ash"
  @source_url "https://github.com/bcksl/ash_geo"

  def project do
    [
      app: @name,
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      preferred_cli_env: preferred_cli_env(),
      cli: cli(),
      aliases: aliases(),
      deps: deps(),
      package: package(),
      test_coverage: test_coverage(),
      docs: docs(),
      name: Macro.camelize("#{@name}"),
      description: @description
    ]
  end

  def application() do
    case Mix.env() do
      :test -> [mod: {AshGeo.Test.Application, []}]
      _ -> []
    end
  end

  defp elixirc_paths(:test), do: ~w(lib test/support)
  defp elixirc_paths(_), do: ~w(lib)

  defp deps do
    [
      {:jason, "~> 1.4"},
      {:geo, "~> 3.5"},
      {:topo, "~> 1.0"},
      {:ash, "~> 2.13"},
      {:geo_postgis, "~> 3.4", only: :test},
      {:ash_postgres, "~> 1.3", only: :test},

      # Testing, analysis, documentation, and release tools
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:sobelow, "~> 0.13.0", only: [:dev, :test], runtime: false},
      {:doctor, "~> 0.21.0", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.16.1", only: :test, runtime: false},
      {:ex_check, "~> 0.15.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.30.4", only: [:dev, :test], runtime: false},
      {:git_ops, "~> 2.6", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      formatters: ~w(html epub),
      extras: ~w(README.md CHANGELOG.md)
    ]
  end

  defp test_coverage do
    [tool: ExCoveralls]
  end

  defp package do
    [
      name: "#{@name}",
      files: ~w(.formatter.exs config lib mix.exs README* LICENSE*),
      maintainers: ~w(bcksl),
      licenses: ~w(MIT),
      links: %{
        GitHub: @source_url
      }
    ]
  end

  def cli do
    [
      default_task: :compile,
      preferred_envs: preferred_cli_env()
    ]
  end

  defp preferred_cli_env do
    [
      check: :test,
      "hex.outdated": :test,
      audit: :test,
      "hex.audit": :test,
      format: :test,
      docs: :dev,
      dialyzer: :dev,
      credo: :dev,
      sobelow: :dev,
      doctor: :dev,
      test: :test,
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

  defp aliases do
    [
      test: ["ash_postgres.create --quiet", "ash_postgres.migrate --quiet", "test"]
    ]
  end
end
