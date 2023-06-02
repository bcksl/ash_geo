defmodule AshGeo.Test.Api do
  @moduledoc false

  use Ash.Api

  resources do
    registry AshGeo.Test.Registry
  end
end
