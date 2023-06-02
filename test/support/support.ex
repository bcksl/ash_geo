defmodule AshGeo.Test.TestStruct do
  @moduledoc false

  defstruct [:name]
end

defmodule AshGeo.Test.Point26918 do
  @moduledoc false

  use AshGeo.Geometry,
    storage_type: :"geometry(Point,26918)",
    geo_types: :point
end
