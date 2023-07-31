defmodule AshGeo.Test do
  use ExUnit.Case
  doctest AshGeo

  alias AshGeo.Test.TestStruct
  alias Ash.Changeset

  def checkout(_ctx \\ nil) do
    Ecto.Adapters.SQL.Sandbox.checkout(AshGeo.Test.Repo)
  end

  setup :checkout

  describe "GeoJson" do
    test "casts input from nil" do
      assert AshGeo.GeoJson.cast_input(nil, []) == {:ok, nil}
    end

    test "casts input from atom-keyed map" do
      assert AshGeo.GeoJson.cast_input(%{type: "Point", coordinates: [42, 42]}, []) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts input from string-keyed map" do
      assert AshGeo.GeoJson.cast_input(%{"type" => "Point", "coordinates" => [42, 42]}, []) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts input from Geo struct" do
      assert AshGeo.GeoJson.cast_input(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts stored from Geo struct" do
      assert AshGeo.GeoJson.cast_stored(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "dumps native from Geo struct" do
      assert AshGeo.GeoJson.dump_to_native(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "rejects input from WKB binary" do
      assert AshGeo.GeoJson.cast_input("000000000140450000000000004045000000000000", []) ==
               :error
    end

    test "rejects input from WKT binary" do
      assert AshGeo.GeoJson.cast_input("POINT(42 42)", []) == :error
    end

    test "rejects input from unknown struct" do
      assert AshGeo.GeoJson.cast_input(%AshGeo.Test.TestStruct{}, []) == :error
    end
  end

  describe "GeoWKT" do
    test "casts input from nil" do
      assert AshGeo.GeoWkt.cast_input(nil, []) == {:ok, nil}
    end

    test "casts input from WKT binary" do
      assert AshGeo.GeoAny.cast_input("POINT(42 42)", []) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts input from Geo struct" do
      assert AshGeo.GeoWkt.cast_input(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts stored from Geo struct" do
      assert AshGeo.GeoWkt.cast_stored(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "dumps native from Geo struct" do
      assert AshGeo.GeoWkt.dump_to_native(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end
  end

  describe "GeoWKB" do
    test "casts input from nil" do
      assert AshGeo.GeoWkb.cast_input(nil, []) == {:ok, nil}
    end

    test "casts input from WKB binary" do
      assert AshGeo.GeoAny.cast_input("000000000140450000000000004045000000000000", []) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts input from Geo struct" do
      assert AshGeo.GeoWkb.cast_input(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts stored from Geo struct" do
      assert AshGeo.GeoWkb.cast_stored(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "dumps native from Geo struct" do
      assert AshGeo.GeoWkb.dump_to_native(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end
  end

  describe "GeoAny" do
    test "casts input from nil" do
      assert AshGeo.GeoAny.cast_input(nil, []) == {:ok, nil}
    end

    test "casts input from atom-keyed map" do
      assert AshGeo.GeoAny.cast_input(%{type: "Point", coordinates: [42, 42]}, []) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts input from string-keyed map" do
      assert AshGeo.GeoAny.cast_input(%{"type" => "Point", "coordinates" => [42, 42]}, []) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts input from WKT binary" do
      assert AshGeo.GeoAny.cast_input("POINT(42 42)", []) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts input from WKB binary" do
      assert AshGeo.GeoAny.cast_input("000000000140450000000000004045000000000000", []) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts input from Geo struct" do
      assert AshGeo.GeoAny.cast_input(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "casts stored from Geo struct" do
      assert AshGeo.GeoAny.cast_stored(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end

    test "dumps native from Geo struct" do
      assert AshGeo.GeoAny.dump_to_native(
               %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}},
               []
             ) ==
               {:ok, %Geo.Point{coordinates: {42, 42}, srid: nil, properties: %{}}}
    end
  end

  describe "Argument struct validation" do
    alias AshGeo.Validation.ArgumentStructType
    alias AshGeo.Test.Resource.Validation

    test "accepts specified struct type" do
      cs =
        Ash.Changeset.new(Validation)
        |> Ash.Changeset.set_argument(:point, Geo.WKT.decode!("POINT(42 42)"))

      assert :ok == ArgumentStructType.validate(cs, argument: :point, struct_type: Geo.Point)
    end

    test "accepts implicit nil" do
      cs =
        Ash.Changeset.new(Validation)
        |> Ash.Changeset.set_argument(:point, nil)

      assert :ok == ArgumentStructType.validate(cs, argument: :point, struct_type: Geo.Point)
    end

    test "accepts explicit nil" do
      cs = Ash.Changeset.new(Validation)

      assert :ok == ArgumentStructType.validate(cs, argument: :point, struct_type: Geo.Point)
    end

    test "rejects unknown struct type" do
      cs =
        Ash.Changeset.new(Validation)
        |> Ash.Changeset.set_argument(:point, %TestStruct{})

      assert {:error, _} =
               ArgumentStructType.validate(cs, argument: :point, struct_type: Geo.Point)
    end
  end

  describe "Argument validations: is_point" do
    alias AshGeo.Test.Resource.Validation

    test "accepts Geo.Point" do
      assert {:ok, _} = Validation.create_point("POINT(42 42)")
    end

    test "accepts nil" do
      assert {:ok, _} = Validation.create_point(nil)
    end

    test "rejects unknown struct" do
      assert {:error, _} = Validation.create_point(%TestStruct{})
    end

    test "rejects integer" do
      assert {:error, _} = Validation.create_point(42)
    end
  end

  describe "Topo validations: init" do
    test "accepts known functions" do
      opts = [geometry_a: :a, geometry_b: :b]

      for function <- AshGeo.topo_functions() do
        opts = Keyword.put(opts, :function, function)

        assert {:ok, _} = AshGeo.Validation.Topo.init(opts)
      end
    end

    test "rejects unknown functions" do
      opts = [function: :contains, geometry_a: :a, geometry_b: :b]

      assert {:error, _} = AshGeo.Validation.Topo.init(opts)
    end
  end

  describe "Topo validations: contains" do
    alias AshGeo.Test.Resource.Validation

    test "accepts point within polygon" do
      cs =
        Changeset.new(Validation)
        |> Changeset.change_attribute(
          :geom,
          Geo.WKT.decode!("POLYGON((30 10, 40 40, 20 40, 10 20, 30 10))")
        )
        |> Changeset.set_argument(:point, Geo.WKT.decode!("POINT(20 20)"))

      assert :ok ==
               AshGeo.Validation.Topo.validate(cs,
                 function: :contains?,
                 geometry_a: :geom,
                 geometry_b: :point
               )
    end

    test "rejects point outside polygon" do
      cs =
        Changeset.new(Validation)
        |> Changeset.change_attribute(
          :geom,
          Geo.WKT.decode!("POLYGON((30 10, 40 40, 20 40, 10 20, 30 10))")
        )
        |> Changeset.set_argument(:point, Geo.WKT.decode!("POINT(420 420)"))

      assert {:error, _} =
               AshGeo.Validation.Topo.validate(cs,
                 function: :contains?,
                 geometry_a: :geom,
                 geometry_b: :point
               )
    end

    test "accepts polygon within polygon" do
      cs =
        Changeset.new(Validation)
        |> Changeset.change_attribute(
          :geom,
          Geo.WKT.decode!("POLYGON((30 10, 40 40, 20 40, 10 20, 30 10))")
        )
        |> Changeset.set_argument(
          :point,
          Geo.WKT.decode!("POLYGON((20 20, 21 21, 21 22, 20 20))")
        )

      assert :ok ==
               AshGeo.Validation.Topo.validate(cs,
                 function: :contains?,
                 geometry_a: :geom,
                 geometry_b: :point
               )
    end

    test "rejects polygon outside polygon" do
      cs =
        Changeset.new(Validation)
        |> Changeset.change_attribute(
          :geom,
          Geo.WKT.decode!("POLYGON((30 10, 40 40, 20 40, 10 20, 30 10))")
        )
        |> Changeset.set_argument(
          :point,
          Geo.WKT.decode!("POLYGON((42 42, 420 420, 0 0, 42 42))")
        )

      assert {:error, _} =
               AshGeo.Validation.Topo.validate(cs,
                 function: :contains?,
                 geometry_a: :geom,
                 geometry_b: :point
               )
    end
  end

  describe "Argument constraints: geo_types: [:point]" do
    alias AshGeo.Test.Resource.Constraint

    test "accepts Geo.Point" do
      assert {:ok, _} = Constraint.create_point("POINT(42 42)")
    end

    test "accepts nil" do
      assert {:ok, _} = Constraint.create_point(nil)
    end

    test "rejects unknown struct" do
      assert {:error, _} = Constraint.create_point(%TestStruct{})
    end

    test "rejects integer" do
      assert {:error, _} = Constraint.create_point(42)
    end
  end

  describe "Expressions: st_within" do
    import Ash.Test
    alias AshGeo.Test.Resource.Area

    test "correctly queries point inside one polygon" do
      Area.create!("POLYGON((30.0 0.0, 20.0 30.0, 0.0 10.0, 30.0 0.0))")

      area2 =
        strip_metadata(
          Area.create!("POLYGON((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0))")
        )

      result = strip_metadata(Area.containing!("POINT(30.0 30.0)"))

      assert length(result) == 1
      assert Enum.at(result, 0) == area2
    end

    test "correctly queries point inside both polygons" do
      area1 = strip_metadata(Area.create!("POLYGON((30.0 0.0, 20.0 30.0, 0.0 10.0, 30.0 0.0))"))

      area2 =
        strip_metadata(
          Area.create!("POLYGON((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0))")
        )

      result = strip_metadata(Area.containing!("POINT(20.0 20.0)"))

      assert length(result) == 2
      assert Enum.at(result, 0) == area1
      assert Enum.at(result, 1) == area2
    end

    test "correctly queries point inside neither polygon" do
      Area.create!("POLYGON((30.0 0.0, 20.0 30.0, 0.0 10.0, 30.0 0.0))")
      Area.create!("POLYGON((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0))")
      result = Area.containing!("POINT(10.0 40.0)")

      assert result == []
    end

    test "correctly queries polygon inside one polygon" do
      Area.create!("POLYGON((30.0 0.0, 20.0 30.0, 0.0 10.0, 30.0 0.0))")

      area2 =
        strip_metadata(
          Area.create!("POLYGON((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0))")
        )

      result =
        strip_metadata(Area.containing!("POLYGON((30.0 30.0, 31.0 31.0, 31.0 32.0, 30.0 30.0))"))

      assert length(result) == 1
      assert Enum.at(result, 0) == area2
    end

    test "correctly queries polygon inside both polygons" do
      area1 = strip_metadata(Area.create!("POLYGON((30.0 0.0, 20.0 30.0, 0.0 10.0, 30.0 0.0))"))

      area2 =
        strip_metadata(
          Area.create!("POLYGON((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0))")
        )

      result =
        strip_metadata(Area.containing!("POLYGON((20.0 20.0, 21.0 21.0, 21.0 22.0, 20.0 20.0))"))

      assert length(result) == 2
      assert Enum.at(result, 0) == area1
      assert Enum.at(result, 1) == area2
    end

    test "correctly queries polygon inside neither polygon" do
      Area.create!("POLYGON((30.0 0.0, 20.0 30.0, 0.0 10.0, 30.0 0.0))")
      Area.create!("POLYGON((30.0 10.0, 40.0 40.0, 20.0 40.0, 10.0 20.0, 30.0 10.0))")
      result = Area.containing!("POLYGON((42.0 0.0, 0.0 42.0, 100.0 42.0, 42.0 0.0))")

      assert result == []
    end
  end
end
