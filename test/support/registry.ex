defmodule AshGeo.Test.Registry do
  @moduledoc false

  use Ash.Registry

  entries do
    entry AshGeo.Test.Resource.Validation
    entry AshGeo.Test.Resource.Constraint
    entry AshGeo.Test.Resource.Area
  end
end
