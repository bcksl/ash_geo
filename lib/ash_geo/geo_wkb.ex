defmodule AshGeo.GeoWkb.Use do
  @moduledoc false
  @moduledoc since: "0.1.0"

  defmacro __using__(opts \\ []) do
    quote location: :keep do
      use AshGeo.Geometry, unquote(opts)

      @impl Ash.Type
      def cast_input(value, constraints)

      @doc "Try decoding with `Geo.WKB`."
      def cast_input(value, _) when is_binary(value) do
        Geo.WKB.decode(value)
      end

      def cast_input(value, constraints), do: super(value, constraints)

      @doc false
      def graphql_input_type(_), do: :string
      @doc false
      def graphql_type(_), do: :string

      defoverridable Ash.Type
      defoverridable graphql_input_type: 1, graphql_type: 1
    end
  end
end

defmodule AshGeo.GeoWkb do
  @moduledoc """
  Geometry type which accepts and decodes WKB input

  Accepts all options of `AshGeo.Geometry`, and may be narrowed with `use`
  in the same way.

  ### Options

  #{Spark.OptionsHelpers.docs(AshGeo.Geometry.Use.opts_schema())}
  """
  @moduledoc since: "0.1.0"

  defmacro __using__(opts \\ []) do
    quote location: :keep,
          bind_quoted: [
            opts: opts
          ] do
      use AshGeo.GeoWkb.Use, unquote(opts)
    end
  end

  use AshGeo.GeoWkb.Use
end
