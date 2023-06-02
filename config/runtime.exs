import Config

if Mix.env() == :test do
  # Postgrex: Geo.PostGIS types
  Postgrex.Types.define(
    AshGeo.Test.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Jason
  )

  # Ecto: Geo.PostGIS types
  config :ash_geo, AshGeo.Test.Repo, types: AshGeo.Test.PostgresTypes
end
