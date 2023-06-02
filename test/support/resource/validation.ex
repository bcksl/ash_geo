defmodule AshGeo.Test.Resource.Validation do
  @moduledoc false

  use Ash.Resource, data_layer: AshPostgres.DataLayer
  import AshGeo.Validation

  attributes do
    uuid_primary_key :id

    attribute :geom, :geometry
    attribute :geom_within, :geometry
  end

  actions do
    create :create_point do
      argument :point, :geo_any

      validate is_point(:point)

      change set_attribute(:geom, arg(:point))
    end

    create :create_polygon do
      argument :polygon, :geo_any

      validate is_polygon(:polygon)

      change set_attribute(:geom, arg(:polygon))
    end

    update :update_within do
      argument :within, :geo_any

      validate contains(:geom, :within)

      change set_attribute(:geom_within, arg(:within))
    end
  end

  code_interface do
    define_for AshGeo.Test.Api

    define :create_point, args: [:point]
  end

  postgres do
    repo AshGeo.Test.Repo
    table "validations"
  end
end
