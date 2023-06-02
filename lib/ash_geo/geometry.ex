defmodule AshGeo.Geometry.Use do
  @moduledoc false
  @moduledoc since: "0.1.0"

  @geo_types [
    doc: """
    Allowed `Geo` types


    #### Examples

    ```elixir
    use AshGeo.Geometry, geo_types: :point
    ```

    ```elixir
    use AshGeo.Geometry, geo_types: [:point, :point_z, :point_zm]
    ```

    ```elixir
    use AshGeo.Geometry, geo_types: [:point, Geo.PointZ, :point_zm]
    ```

    #### See also

    - `AshGeo.geo_types/0`
    - `AshGeo.geo_type_aliases/0`
    """,
    type: {:or, [{:list, {:or, [:module, :atom]}}, {:or, [:module, :atom]}]}
  ]

  @opts_schema [
    storage_type: [
      doc: """
      Column type in the database

      #### Examples

      ```elixir
      use AshGeo.Geometry, storage_type: :\"geometry(Point,26918)\"
      ```
      """,
      type: :atom
    ],
    geo_types: @geo_types
  ]

  @constraints_schema [
    geo_types: @geo_types
  ]

  @doc false
  def opts_schema, do: @opts_schema
  @doc false
  def constraints_schema, do: @constraints_schema

  defmacro __using__(opts \\ []) do
    quote location: :keep,
          bind_quoted: [
            opts: opts,
            opts_schema: @opts_schema,
            constraints_schema: @constraints_schema
          ] do
      opts = Spark.OptionsHelpers.validate!(opts, opts_schema)

      storage_type = opts[:storage_type] || :geometry
      geo_types = opts[:geo_types]

      use Ash.Type
      import AshGeo

      @doc false
      @impl Ash.Type
      def constraints, do: unquote(constraints_schema)

      @doc false
      @impl Ash.Type
      def storage_type, do: unquote(storage_type)

      @doc false
      @impl Ash.Type
      def apply_constraints(value, constraints)

      def apply_constraints(nil, _), do: :ok

      def apply_constraints(%struct{} = value, constraints) when is_geo(struct) do
        errs =
          Enum.reduce(constraints, [], fn {:geo_types, geo_types}, errs ->
            if Enum.any?(List.wrap(geo_types), &(struct in [&1, geo_type_aliases()[&1]])) do
              errs
            else
              [constraint_error_keyword(geo_types, value) | errs]
            end
          end)

        case errs do
          [] -> {:ok, value}
          errs -> {:error, errs}
        end
      end

      def apply_constraints(value, _) do
        {:error, [constraint_error_keyword(AshGeo.geo_types(), value)]}
      end

      defp constraint_error_keyword(geo_types, value) do
        [
          message: "must be a struct with type among: %{types}, got: %{value}",
          types: Enum.map_join(geo_types, ", ", &inspect/1),
          value: value
        ]
      end

      @doc false
      @impl Ash.Type
      def cast_input(%struct{} = value, constraints) when is_geo(struct) do
        {:ok, value}
      end

      def cast_input(nil, _), do: {:ok, nil}
      def cast_input(_, _), do: :error

      @doc false
      @impl Ash.Type
      def cast_stored(%struct{} = value, constraints) when is_geo(struct) do
        {:ok, value}
      end

      def cast_stored(nil, _), do: {:ok, nil}
      def cast_stored(_, _), do: :error

      @doc false
      @impl Ash.Type
      def dump_to_native(%struct{} = value, constraints) when is_geo(struct) do
        {:ok, value}
      end

      def dump_to_native(nil, _), do: {:ok, nil}
      def dump_to_native(_, _), do: :error

      defoverridable Ash.Type
    end
  end
end

defmodule AshGeo.Geometry do
  @moduledoc """
  Base geometry type

  To create a constrained geometry type, `use AshGeo.Geometry` accepts several
  options that may be useful.

  ### Options

  #{Spark.OptionsHelpers.docs(AshGeo.Geometry.Use.opts_schema())}

  Constraints:

  #{Spark.OptionsHelpers.docs(AshGeo.Geometry.Use.constraints_schema())}

  ```elixir
  defmodule App.GeometryPoint26918 do
    use AshGeo.Geometry,
      storage_type: :"geometry(Point,26918)",
      geo_types: :point
  end
  ```
  """
  @moduledoc since: "0.1.0"

  defmacro __using__(opts \\ []) do
    quote location: :keep,
          bind_quoted: [
            opts: opts
          ] do
      use AshGeo.Geometry.Use, opts
    end
  end

  use AshGeo.Geometry.Use
end
