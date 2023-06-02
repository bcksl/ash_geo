defmodule AshGeo.Validation.Builder do
  @moduledoc false

  defmacro build_is(geo_alias, geo_type) do
    quote location: :keep,
          bind_quoted: [
            geo_alias: geo_alias,
            geo_type: geo_type
          ] do
      @doc "Check argument is a `#{inspect(geo_alias)}` (`#{inspect(geo_type)}`)"
      defmacro unquote(:"is_#{geo_alias}")(argument) do
        geo_type = unquote(geo_type)

        quote location: :keep,
              bind_quoted: [
                argument: argument,
                geo_type: geo_type
              ] do
          {AshGeo.Validation.ArgumentStructType, argument: argument, struct_type: geo_type}
        end
      end
    end
  end

  defmacro build_topo(function) do
    quote location: :keep,
          bind_quoted: [function: function] do
      @doc "Check geometry A against geometry B using `Topo.#{function}`"
      defmacro unquote(:"#{String.replace("#{function}", "?", "")}")(geometry_a, geometry_b) do
        function = unquote(function)

        quote location: :keep,
              bind_quoted: [
                function: function,
                geometry_a: geometry_a,
                geometry_b: geometry_b
              ] do
          {AshGeo.Validation.Topo,
           function: function, geometry_a: geometry_a, geometry_b: geometry_b}
        end
      end
    end
  end
end
