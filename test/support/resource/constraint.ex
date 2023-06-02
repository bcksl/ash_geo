defmodule AshGeo.Test.Resource.Constraint do
  @moduledoc false

  use Ash.Resource, data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :geom, :geometry
  end

  actions do
    create :create_point do
      argument :point, :geo_any, constraints: [geo_types: :point]

      change set_attribute(:geom, arg(:point))
    end
  end

  code_interface do
    define_for AshGeo.Test.Api

    define :create_point, args: [:point]
  end

  postgres do
    repo AshGeo.Test.Repo
    table "constraints"
  end
end
