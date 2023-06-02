# AshGeo
### *All your Ash resources, in space!*

[![Hex](http://img.shields.io/hexpm/v/ash_geo.svg?style=flat)](https://hex.pm/packages/ash_geo)
[![Hex Docs](https://img.shields.io/badge/hex-docs-purple.svg)](https://hexdocs.pm/ash_geo/)
[![Downloads](https://img.shields.io/hexpm/dt/ash_geo.svg)](https://hex.pm/packages/ash_geo)
[![Build Status](https://img.shields.io/github/actions/workflow/status/bcksl/ash_geo/ci.yml)](https://github.com/bcksl/ash_geo)
[![Coverage Status](https://coveralls.io/repos/github/bcksl/ash_geo/badge.svg?branch=main)](https://coveralls.io/github/bcksl/ash_geo?branch=main)
[![License](https://img.shields.io/github/license/bcksl/ash_geo?color=blue)](https://github.com/bcksl/git_opts/blob/main/LICENSE.md)
[![GitHub Stars](https://img.shields.io/github/stars/bcksl/ash_geo?color=ffd700&label=github&logo=github)](https://github.com/bcksl/ash_geo)

**AshGeo** contains tools for using [PostGIS] with your [Ash] resources and
expressions, backed by [Geo] and [Geo.PostGIS].

It provides:

- All the `st_*` functions that you would get with `Geo.PostGIS` for use with
  Ash [`expr`][Ash expressions], and [more to come](#roadmap).
- An `Ash.Type` backed by each of `Geo.JSON`, `Geo.WKB` and `Geo.WKT` which may
  be used as `argument` types in your Ash actions, and will automatically cast
  input from GeoJSON, WKT and WKB encodings.
- An `Ash.Type` for `Geo.PostGIS.Geometry`, for use with resource attributes.
- All types may be overridden and narrowed with `use`, allowing you to add
  stricter constraints and storage types (e.g.  `geometry(Point,26918)`).
- Validations for `Geo` types (such as `is_point_zm(:arg)` for checking that
  argument `:arg` is a instance of `Geo.PointZM`)
- Validations backed by `Topo`, allowing checks of simple constraints such as
  `contains?` without needing to hit the database.

## Installation

```elixir
def deps do
  [
    {:ash_geo, "~> 0.1"},
  ]
end
```

## Configuration

### `config/config.exs`:

```elixir
# Geo.PostGIS: Use Jason coder
config :geo_postgis, json_library: Jason

# Ash: Type shorthands
config :ash, :custom_types, [
  geometry: AshGeo.Geometry,
  geo_json: AshGeo.GeoJson,
  geo_wkt: AshGeo.GeoWkt,
  geo_wkb: AshGeo.GeoWkb,
  geo_any: AshGeo.GeoAny,
  # You may add shorthands for any narrowed types here
  #point26918: CoolApp.Type.GeometryPoint26918,
]
```

### `config/runtime.exs`:

```elixir
# Postgrex: Geo.PostGIS types
Postgrex.Types.define(CoolApp.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason)

# Ecto: Geo.PostGIS types
config :cool_app, CoolApp.Repo, types: CoolApp.PostgresTypes
```

## Usage

```elixir
defmodule Area do
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  import AshGeo.Expr

  attributes do
    uuid_primary_key :id,
    attribute :geom, :geometry, allow_nil?: false
  end

  actions do
    action :create do
      argument :geom, :geo_any

      change set_attribute(:geom, arg(:geom))
    end

    read :containing do
      argument :geom, :geo_any do
        allow_nil? false
        constraints geo_types: :point
      end

      filter expr(^st_within(^arg(:geom), geom))
    end
  end

  code_interface do
    define_for Area
    define :create, args: [:geom]
    define :containing, args: [:geom]
  end
end
```

Try it out:

```elixir
Area.create! "POLYGON ((30 0, 20 30, 0 10, 30 0))"
Area.create! "POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))"
Area.containing! "POINT(30 30)"
Area.containing! "POINT(20 20)"
Area.containing! "POINT(10 40)"
Area.containing! "POLYGON((0 0, 30 20, 40 30, 0 0))"
```

The full documentation can be found [on HexDocs].

## Roadmap

- Add more PostGIS function wrappers (check out the [PostGIS reference] to see
  all that are available).
- Continue to improve the test suite.
- Replace validation macros with Spark DSL patches or similar.
- Replace PostGIS `fragment` macros with custom predicates
  ([`ash#374`](https://github.com/ash-project/ash/issues/374))
- Add more informative error messages
  ([`ash#365`](https://github.com/ash-project/ash/issues/365)).

## Developing

To get set up with the development environment, you will need a Postgres
instance with support for the PostGIS extensions listed in
`AshGeo.Test.Repo.installed_extensions()` (the [`postgis/postgis`][postgis
image] image works nicely) and a superuser account `ash_geo_test` credentialed
according to `config/config.exs`.

**AshGeo** uses `ex_check` to bundle the test configuration, and simply running
`mix check` should closely follow the configuration used in CI.

## Contributing

If you have ideas or come across any bugs, feel free to open a [pull request] or
an [issue]. You can also find me on the [Ash
Discord](https://discord.gg/D7FNG2q) as `@\`.

## License

MIT License

Copyright (c) 2023 [bcksl]

See [LICENSE.md] for details.

[bcksl]: https://github.com/bcksl
[LICENSE.md]: https://github.com/bcksl/ash_geo/blob/main/LICENSE.md
[pull request]: https://github.com/bcksl/ash_geo/pulls
[issue]: https://github.com/bcksl/ash_geo/issues
[on HexDocs]: https://hexdocs.pm/ash_geo
[PostGIS]: https://postgis.net/
[PostGIS reference]: https://postgis.net/docs/reference.html
[postgis image]: https://hub.docker.com/r/postgis/postgis
[Geo]: https://github.com/bryanjos/geo
[Geo.PostGIS]: https://github.com/bryanjos/geo_postgis
[Ash]: https://github.com/ash-project/ash
[Ash expressions]: https://hexdocs.pm/ash/expressions.html
