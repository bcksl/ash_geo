defmodule AshGeo.Validation.ArgumentStructType do
  @opts_schema [
    argument: [
      type: :atom,
      required: true,
      doc: "Argument to assert struct type"
    ],
    struct_type: [
      type: :atom,
      required: true,
      doc: "Struct type to assert"
    ]
  ]

  @moduledoc """
  Validate that the argument's value matches the specified struct type.

  Options:

  #{Spark.OptionsHelpers.docs(@opts_schema)}
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
  def validate(changeset, opts) do
    argument = opts[:argument]
    struct_type = opts[:struct_type]

    case Ash.Changeset.get_argument(changeset, argument) do
      nil ->
        :ok

      %^struct_type{} ->
        :ok

      value ->
        {:error,
         InvalidArgument.exception(
           message: "argument %{field} must be a #{inspect(struct_type)} struct, got: %{value}",
           field: argument,
           value: value
         )}
    end
  end
end
