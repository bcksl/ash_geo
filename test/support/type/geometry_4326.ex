defmodule AshGeo.Test.Type.Geometry4326 do
  use AshGeo.Geometry,
    storage_type: :"geometry(geometry,4326)",
    check_srid: 4326
end
