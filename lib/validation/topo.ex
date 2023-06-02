defmodule AshGeo.Validation.Topo do
  @opts_schema [
    function: [
      type: {:in, AshGeo.topo_functions()},
      required: true,
      doc: "Topo function to use for comparison"
    ],
    geometry_a: [
      type: :atom,
      required: true,
      doc: "Geometry A"
    ],
    geometry_b: [
      type: :atom,
      required: true,
      doc: "Geometry B"
    ]
  ]

  @moduledoc """
  Validate that the specified `Topo` function return true.

  Options:

  #{Spark.OptionsHelpers.docs(@opts_schema)}

  See also:

  - https://hexdocs.pm/topo/Topo.html
  """
  @moduledoc since: "0.1.0"

  use Ash.Resource.Validation
  alias Ash.Error.Changes.InvalidArgument

  @impl Ash.Resource.Validation
  def init(opts) do
    case Spark.OptionsHelpers.validate(opts, @opts_schema) do
      {:ok, opts} ->
        {:ok, opts}

      {:error, error} ->
        {:error, Exception.message(error)}
    end
  end

  @impl Ash.Resource.Validation
  def validate(cs, opts) do
    geometry_a = attribute_value(cs, opts[:geometry_a])
    geometry_b = attribute_value(cs, opts[:geometry_b])

    case apply(Topo, opts[:function], [geometry_a, geometry_b]) do
      true -> :ok
      false -> invalid_argument_error(opts, geometry_a, geometry_b)
    end
  end

  defp attribute_value(_cs, attribute) when is_function(attribute, 0) do
    attribute.()
  end

  defp attribute_value(cs, attribute) when is_atom(attribute) do
    Ash.Changeset.get_argument_or_attribute(cs, attribute)
  end

  defp attribute_value(_, attribute), do: attribute

  defp invalid_argument_error(opts, geometry_a, geometry_b) do
    {:error,
     InvalidArgument.exception(
       field: opts[:geometry_a],
       value: geometry_a,
       message:
         case opts[:function] do
           :contains? -> "#{geometry_a} does not contain #{geometry_b}"
           :disjoint? -> "#{geometry_a} is not disjoint with #{geometry_b}"
           :equals? -> "#{geometry_a} does not equal #{geometry_b}"
           :intersects? -> "#{geometry_a} does not intersect #{geometry_b}"
           :within? -> "#{geometry_a} is not within #{geometry_b}"
         end
     )}
  end
end
