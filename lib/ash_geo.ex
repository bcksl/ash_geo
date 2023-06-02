defmodule AshGeo do
  @moduledoc false
  @moduledoc since: "0.1.0"

  @doc "Transform the last element of a module path into a snake-cased atom."
  @doc since: "0.1.0"
  # sobelow_skip ["DOS.StringToAtom"]
  def module_suffix_to_snake(module) do
    module
    |> Module.split()
    |> List.last()
    |> Macro.underscore()
    |> String.to_atom()
  end

  @doc "Macro to check whether a module is a `Geo` type, suitable for use in guards"
  @doc since: "0.1.0"
  # credo:disable-for-lines:17 Credo.Check.Refactor.CyclomaticComplexity
  defmacro is_geo(struct) do
    quote location: :keep do
      unquote(struct) == Geo.Point or
        unquote(struct) == Geo.PointZ or
        unquote(struct) == Geo.PointM or
        unquote(struct) == Geo.PointZM or
        unquote(struct) == Geo.LineString or
        unquote(struct) == Geo.LineStringZ or
        unquote(struct) == Geo.Polygon or
        unquote(struct) == Geo.PolygonZ or
        unquote(struct) == Geo.MultiPoint or
        unquote(struct) == Geo.MultiPointZ or
        unquote(struct) == Geo.MultiLineString or
        unquote(struct) == Geo.MultiLineStringZ or
        unquote(struct) == Geo.MultiPolygon or
        unquote(struct) == Geo.MultiPolygonZ or
        unquote(struct) == Geo.GeometryCollection
    end
  end

  @doc "All `Geo` types"
  @doc since: "0.1.0"
  def geo_types do
    [
      Geo.Point,
      Geo.PointZ,
      Geo.PointM,
      Geo.PointZM,
      Geo.LineString,
      Geo.LineStringZ,
      Geo.Polygon,
      Geo.PolygonZ,
      Geo.MultiPoint,
      Geo.MultiPointZ,
      Geo.MultiLineString,
      Geo.MultiLineStringZ,
      Geo.MultiPolygon,
      Geo.MultiPolygonZ,
      Geo.GeometryCollection
    ]
  end

  @doc """
  Type aliases for `Geo` types, auto-generated from the module names

  For example, the alias derived from `Geo.PointZM` is `:point_zm`.
  """
  @doc since: "0.1.0"
  def geo_type_aliases do
    Enum.map(geo_types(), fn type ->
      {module_suffix_to_snake(type), type}
    end)
  end

  @doc """
  `Topo` functions
  """
  @doc since: "0.1.0"
  def topo_functions do
    [
      :contains?,
      :disjoint?,
      :equals?,
      :intersects?,
      :within?
    ]
  end
end
