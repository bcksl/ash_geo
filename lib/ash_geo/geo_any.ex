defmodule AshGeo.GeoAny.Use do
  @moduledoc false
  @moduledoc since: "0.1.0"

  @opts_schema [
                 prefer_binary_encoding: [
                   type: {:in, [:wkt, :wkb]},
                   default: :wkt,
                   doc: "Which binary encoding format to attempt first: WKT or WKB."
                 ]
               ] ++ AshGeo.Geometry.Use.opts_schema()

  def opts_schema, do: @opts_schema

  defmacro __using__(opts \\ []) do
    quote location: :keep,
          bind_quoted: [
            opts: opts,
            opts_schema: @opts_schema
          ] do
      opts = Spark.OptionsHelpers.validate!(opts, opts_schema)
      geometry_opts = Keyword.delete(opts, :prefer_binary_encoding)

      use AshGeo.Geometry, geometry_opts

      @impl Ash.Type
      def cast_input(value, constraints)

      @doc """
      Use `Jason` to encode and then decode maps that might be otherwise valid
      with atom keys before attempting decoding with `Geo.JSON`.
      """
      def cast_input(%{type: _} = value, constraints) do
        with {:ok, value} <- Jason.encode(value),
             {:ok, value} <- Jason.decode(value),
             {:ok, value} <- Geo.JSON.decode(value) do
          {:ok, value}
        else
          # err -> err
          _ -> :error
        end
      end

      @doc "Try decoding with `Geo.JSON`."
      def cast_input(value, constraints) when is_map(value) and not is_struct(value) do
        case Geo.JSON.decode(value) do
          {:ok, _} = res -> res
          # XXX blocked on https://github.com/ash-project/ash/issues/365
          # err -> err
          _ -> :error
        end
      end

      @doc "Try decoding with `Geo.WKB` and `Geo.WKT`, in the order specified by `:prefer`."
      def cast_input(value, constraints) when is_binary(value) do
        prefer = constraints[:prefer_binary_encoding] || unquote(opts[:prefer_binary_encoding])

        {first, second} =
          case prefer do
            :wkt -> {&Geo.WKT.decode/1, &Geo.WKB.decode/1}
            :wkb -> {&Geo.WKB.decode/1, &Geo.WKT.decode/1}
          end

        case first.(value) do
          {:error, _} -> second.(value)
          res -> res
        end
      end

      def cast_input(value, constraints), do: super(value, constraints)

      # XXX union type `{:or, [:json, :string]}` would be nice
      @doc false
      def graphql_input_type(_), do: :json
      @doc false
      def graphql_type(_), do: :json

      defoverridable Ash.Type
      defoverridable graphql_input_type: 1, graphql_type: 1
    end
  end
end

defmodule AshGeo.GeoAny do
  @moduledoc """
  Geometry type which attempts to auto-detect and decode from JSON, WKT and WKB

  Accepts all options for `AshGeo.Geometry`, plus `prefer_binary_encoding`,
  and may also be narrowed with `use` in the same way.

  Options:

  #{Spark.OptionsHelpers.docs(AshGeo.GeoAny.Use.opts_schema())}
  """
  @moduledoc since: "0.1.0"

  defmacro __using__(opts \\ []) do
    quote location: :keep,
          bind_quoted: [
            opts: opts
          ] do
      use AshGeo.GeoAny.Use, opts
    end
  end

  use AshGeo.GeoAny.Use
end
