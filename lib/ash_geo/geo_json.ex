defmodule AshGeo.GeoJson.Use do
  @moduledoc false
  @moduledoc since: "0.1.0"

  defmacro __using__(opts \\ []) do
    quote location: :keep do
      use AshGeo.Geometry, unquote(opts)

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
          # XXX blocked on https://github.com/ash-project/ash/issues/365
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

      def cast_input(value, constraints), do: super(value, constraints)

      @doc false
      def graphql_input_type(_), do: :json
      @doc false
      def graphql_type(_), do: :json

      defoverridable Ash.Type
      defoverridable graphql_input_type: 1, graphql_type: 1
    end
  end
end

defmodule AshGeo.GeoJson do
  @moduledoc """
  Geometry type which accepts and decodes GeoJSON input

  Accepts all options of `AshGeo.Geometry`, and may be narrowed with `use`
  in the same way.

  Options:

  #{Spark.OptionsHelpers.docs(AshGeo.Geometry.Use.opts_schema())}
  """
  @moduledoc since: "0.1.0"

  defmacro __using__(opts \\ []) do
    quote location: :keep,
          bind_quoted: [
            opts: opts
          ] do
      use AshGeo.GeoJson.Use, unquote(opts)
    end
  end

  use AshGeo.GeoJson.Use
end
