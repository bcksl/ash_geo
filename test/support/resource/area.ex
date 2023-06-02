defmodule AshGeo.Test.Resource.Area do
  @moduledoc false

  use Ash.Resource, data_layer: AshPostgres.DataLayer
  import AshGeo.Postgis

  attributes do
    uuid_primary_key :id

    attribute :area, AshGeo.Geometry, constraints: [geo_types: :polygon]
  end

  actions do
    create :create do
      argument :area, :geo_any, allow_nil?: false

      change set_attribute(:area, arg(:area))
    end

    read :containing do
      argument :geom, :geo_any, allow_nil?: false

      filter expr(^st_within(^arg(:geom), area))
    end
  end

  code_interface do
    define_for AshGeo.Test.Api

    define :create, args: [:area]
    define :containing, args: [:geom]
  end

  postgres do
    repo AshGeo.Test.Repo
    table "areas"
  end
end
