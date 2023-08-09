defmodule AshGeo.Test.Resource.Geom do
  @moduledoc false

  use Ash.Resource, data_layer: AshPostgres.DataLayer
  import AshGeo.Postgis
  alias AshGeo.Test.Type.{Geometry4326, GeoAny4326}

  attributes do
    uuid_primary_key :id

    attribute :geom, Geometry4326
  end

  actions do
    create :create do
      argument :geom, GeoAny4326, allow_nil?: false

      change set_attribute(:geom, arg(:geom))
    end

    read :containing do
      argument :geom, GeoAny4326, allow_nil?: false

      filter expr(^st_within(^arg(:geom), geom))
    end

    read :within_distance do
      argument :geom, GeoAny4326, allow_nil?: false
      argument :distance, :float, allow_nil?: false

      filter expr(^st_dwithin(geom, ^arg(:geom), ^arg(:distance)))
    end
  end

  code_interface do
    define_for AshGeo.Test.Api

    define :create, args: [:geom]
    define :containing, args: [:geom]
    define :within_distance, args: [:geom, :distance]
  end

  postgres do
    repo AshGeo.Test.Repo
    table "geoms"
  end
end
