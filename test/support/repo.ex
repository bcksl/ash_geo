defmodule AshGeo.Test.Repo do
  @moduledoc false

  use AshPostgres.Repo, otp_app: :ash_geo

  @doc false
  @impl AshPostgres.Repo
  def installed_extensions do
    [
      "uuid-ossp",
      "citext",
      "postgis",
      "postgis_sfcgal",
      "fuzzystrmatch",
      "address_standardizer",
      "address_standardizer_data_us",
      "postgis_tiger_geocoder",
      "postgis_topology",
      "postgis_raster"
    ]
  end
end
