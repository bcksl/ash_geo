defmodule AshGeo.Validation do
  @moduledoc """
  Validation shorthands for `Geo.PostGIS` types for use with Ash `validate`

  ```elixir
  actions do
    read :containing do
      argument :point, :geo_any

      validate is_point(:point)

      filter expr(^st_contains(^arg(:point)))
    end
  end
  ```
  """
  @moduledoc since: "0.1.0"

  import AshGeo.Validation.Builder

  for {geo_alias, geo_type} <- AshGeo.geo_type_aliases() do
    build_is(geo_alias, geo_type)
  end

  for function <- AshGeo.topo_functions() do
    build_topo(function)
  end
end
