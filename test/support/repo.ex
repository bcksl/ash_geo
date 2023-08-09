defmodule AshGeo.Test.Repo do
  @moduledoc false

  use AshPostgres.Repo, otp_app: :ash_geo

  @doc false
  @impl AshPostgres.Repo
  def installed_extensions do
    [
      "uuid-ossp",
      "citext",
      "fuzzystrmatch",
      "address_standardizer",
      "address_standardizer_data_us",
      "postgis",
      "postgis_sfcgal",
      "postgis_tiger_geocoder",
      "postgis_topology",
      "postgis_raster"
    ]
  end
end
