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

    create :create_check_srid_4326 do
      argument :geom, :geo_any, allow_nil?: false, constraints: [check_srid: 4326]

      change set_attribute(:geom, arg(:geom))
    end

    create :create_force_srid_4326 do
      argument :geom, :geo_any, allow_nil?: false, constraints: [force_srid: 4326]

      change set_attribute(:geom, arg(:geom))
    end
  end

  code_interface do
    define_for AshGeo.Test.Api

    define :create_point, args: [:point]
    define :create_check_srid_4326, args: [:geom]
    define :create_force_srid_4326, args: [:geom]
  end

  postgres do
    repo AshGeo.Test.Repo
    table "constraints"
  end
end
