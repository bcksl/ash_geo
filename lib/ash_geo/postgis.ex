defmodule AshGeo.Postgis do
  @moduledoc """
  PostGIS functions for use with `Ash.Expr`
  """
  @moduledoc since: "0.1.0"

  @doc """
  Create
  """
  defmacro gis_index(column, name \\ nil) do
    quote bind_quoted: [column: column, name: name] do
      name =
        case name do
          nil -> :"#{column}_geom_idx"
          name -> name
        end

      statement unquote(name) do
        up "create index #{unquote(name)} on #{unquote(column)} using gist (#{unquote(column)});"
        down "drop index #{unquote(name)};"
      end
    end
  end

  defmacro st_transform(wkt, srid) do
    quote do: expr(fragment("ST_Transform(?,?)", unquote(wkt), unquote(srid)))
  end

  defmacro st_distance(geometryA, geometryB) do
    quote do: expr(fragment("ST_Distance(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  @doc """
  Casts the 2 geometries given to geographies in order to return distance in meters.
  """
  defmacro st_distance_in_meters(geometryA, geometryB) do
    quote do
      expr(
        fragment(
          "ST_Distance(?::geography,?::geography)",
          unquote(geometryA),
          unquote(geometryB)
        )
      )
    end
  end

  defmacro st_distancesphere(geometryA, geometryB) do
    quote do: expr(fragment("ST_DistanceSphere(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  @doc """
  Please note that ST_Distance_Sphere has been deprecated as of Postgis 2.2.
  Postgis 2.1 is no longer supported on PostgreSQL >= 9.5.
  This macro is still in place to support users of PostgreSQL <= 9.4.x.
  """
  defmacro st_distance_sphere(geometryA, geometryB) do
    quote do: expr(fragment("ST_Distance_Sphere(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_dwithin(geometryA, geometryB, float) do
    quote do
      expr(
        fragment(
          "ST_DWithin(?,?,?)",
          unquote(geometryA),
          unquote(geometryB),
          unquote(float)
        )
      )
    end
  end

  @doc """
  Casts the 2 geometries given to geographies in order to check for distance in meters.
  """
  defmacro st_dwithin_in_meters(geometryA, geometryB, float) do
    quote do
      expr(
        fragment(
          "ST_DWithin(?::geography,?::geography,?)",
          unquote(geometryA),
          unquote(geometryB),
          unquote(float)
        )
      )
    end
  end

  defmacro st_equals(geometryA, geometryB) do
    quote do: expr(fragment("ST_Equals(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_disjoint(geometryA, geometryB) do
    quote do: expr(fragment("ST_Disjoint(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_intersects(geometryA, geometryB) do
    quote do: expr(fragment("ST_Intersects(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_touches(geometryA, geometryB) do
    quote do: expr(fragment("ST_Touches(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_crosses(geometryA, geometryB) do
    quote do: expr(fragment("ST_Crosess(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_within(geometryA, geometryB) do
    quote do: expr(fragment("ST_Within(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_overlaps(geometryA, geometryB) do
    quote do: expr(fragment("ST_Overlaps(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_contains(geometryA, geometryB) do
    quote do: expr(fragment("ST_Contains(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_covers(geometryA, geometryB) do
    quote do: expr(fragment("ST_Covers(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_covered_by(geometryA, geometryB) do
    quote do: expr(fragment("ST_CoveredBy(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_relate(geometryA, geometryB, intersectionPatternMatrix) do
    quote do
      expr(
        fragment(
          "ST_Relate(?,?,?)",
          unquote(geometryA),
          unquote(geometryB),
          unquote(intersectionPatternMatrix)
        )
      )
    end
  end

  defmacro st_relate(geometryA, geometryB) do
    quote do: expr(fragment("ST_Relate(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_centroid(geometry) do
    quote do: expr(fragment("ST_Centroid(?)", unquote(geometry)))
  end

  defmacro st_area(geometry) do
    quote do: expr(fragment("ST_Area(?)", unquote(geometry)))
  end

  defmacro st_length(geometry) do
    quote do: expr(fragment("ST_Length(?)", unquote(geometry)))
  end

  defmacro st_point_on_surface(geometry) do
    quote do: expr(fragment("ST_PointOnSurface(?)", unquote(geometry)))
  end

  defmacro st_boundary(geometry) do
    quote do: expr(fragment("ST_Boundary(?)", unquote(geometry)))
  end

  defmacro st_buffer(geometry, double) do
    quote do: expr(fragment("ST_Buffer(?,?)", unquote(geometry), unquote(double)))
  end

  defmacro st_buffer(geometry, double, integer) do
    quote do
      expr(fragment("ST_Buffer(?,?,?)", unquote(geometry), unquote(double), unquote(integer)))
    end
  end

  defmacro st_convex_hull(geometry) do
    quote do: expr(fragment("ST_ConvexHull(?)", unquote(geometry)))
  end

  defmacro st_intersection(geometryA, geometryB) do
    quote do: expr(fragment("ST_Intersection(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_shift_longitude(geometry) do
    quote do: expr(fragment("ST_Shift_Longitude(?)", unquote(geometry)))
  end

  defmacro st_sym_difference(geometryA, geometryB) do
    quote do: expr(fragment("ST_SymDifference(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_difference(geometryA, geometryB) do
    quote do: expr(fragment("ST_Difference(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_collect(geometryList) do
    quote do: expr(fragment("ST_Collect(?)", unquote(geometryList)))
  end

  defmacro st_collect(geometryA, geometryB) do
    quote do: expr(fragment("ST_Collect(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_union(geometryList) do
    quote do: expr(fragment("ST_Union(?)", unquote(geometryList)))
  end

  defmacro st_union(geometryA, geometryB) do
    quote do: expr(fragment("ST_Union(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_mem_union(geometryList) do
    quote do: expr(fragment("ST_MemUnion(?)", unquote(geometryList)))
  end

  defmacro st_as_text(geometry) do
    quote do: expr(fragment("ST_AsText(?)", unquote(geometry)))
  end

  defmacro st_as_binary(geometry) do
    quote do: expr(fragment("ST_AsBinary(?)", unquote(geometry)))
  end

  defmacro st_srid(geometry) do
    quote do: expr(fragment("ST_SRID(?)", unquote(geometry)))
  end

  defmacro st_set_srid(geometry, srid) do
    quote do: expr(fragment("ST_SetSRID(?,?)", unquote(geometry), unquote(srid)))
  end

  defmacro st_make_box_2d(geometryA, geometryB) do
    quote do: expr(fragment("ST_MakeBox2D(?,?)", unquote(geometryA), unquote(geometryB)))
  end

  defmacro st_dimension(geometry) do
    quote do: expr(fragment("ST_Dimension(?)", unquote(geometry)))
  end

  defmacro st_envelope(geometry) do
    quote do: expr(fragment("ST_Envelope(?)", unquote(geometry)))
  end

  defmacro st_is_simple(geometry) do
    quote do: expr(fragment("ST_IsSimple(?)", unquote(geometry)))
  end

  defmacro st_is_closed(geometry) do
    quote do: expr(fragment("ST_IsClosed(?)", unquote(geometry)))
  end

  defmacro st_is_ring(geometry) do
    quote do: expr(fragment("ST_IsRing(?)", unquote(geometry)))
  end

  defmacro st_num_geometries(geometry) do
    quote do: expr(fragment("ST_NumGeometries(?)", unquote(geometry)))
  end

  defmacro st_geometry_n(geometry, int) do
    quote do: expr(fragment("ST_GeometryN(?,?)", unquote(geometry), unquote(int)))
  end

  defmacro st_num_points(geometry) do
    quote do: expr(fragment("ST_NumPoints(?)", unquote(geometry)))
  end

  defmacro st_point_n(geometry, int) do
    quote do: expr(fragment("ST_PointN(?,?)", unquote(geometry), unquote(int)))
  end

  defmacro st_point(x, y) do
    quote do: expr(fragment("ST_Point(?,?)", unquote(x), unquote(y)))
  end

  defmacro st_exterior_ring(geometry) do
    quote do: expr(fragment("ST_ExteriorRing(?)", unquote(geometry)))
  end

  defmacro st_num_interior_rings(geometry) do
    quote do: expr(fragment("ST_NumInteriorRings(?)", unquote(geometry)))
  end

  defmacro st_num_interior_ring(geometry) do
    quote do: expr(fragment("ST_NumInteriorRing(?)", unquote(geometry)))
  end

  defmacro st_interior_ring_n(geometry, int) do
    quote do: expr(fragment("ST_InteriorRingN(?,?)", unquote(geometry), unquote(int)))
  end

  defmacro st_end_point(geometry) do
    quote do: expr(fragment("ST_EndPoint(?)", unquote(geometry)))
  end

  defmacro st_start_point(geometry) do
    quote do: expr(fragment("ST_StartPoint(?)", unquote(geometry)))
  end

  defmacro st_geometry_type(geometry) do
    quote do: expr(fragment("ST_GeometryType(?)", unquote(geometry)))
  end

  defmacro st_x(geometry) do
    quote do: expr(fragment("ST_X(?)", unquote(geometry)))
  end

  defmacro st_y(geometry) do
    quote do: expr(fragment("ST_Y(?)", unquote(geometry)))
  end

  defmacro st_z(geometry) do
    quote do: expr(fragment("ST_Z(?)", unquote(geometry)))
  end

  defmacro st_m(geometry) do
    quote do: expr(fragment("ST_M(?)", unquote(geometry)))
  end

  defmacro st_geom_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_GeomFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_point_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_PointFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_line_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_LineFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_linestring_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_LinestringFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_polygon_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_PolygonFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_m_point_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_MPointFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_m_line_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_MLineFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_m_poly_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_MPolyFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_m_geom_coll_from_text(text, srid \\ -1) do
    quote do: expr(fragment("ST_GeomCollFromText(?,?)", unquote(text), unquote(srid)))
  end

  defmacro st_m_geom_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_GeomFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_m_geometry_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_GeometryFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_point_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_PointFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_line_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_LineFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_linestring_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_LinestringFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_poly_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_PolyFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_polygon_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_PolygonFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_m_point_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_MPointFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_m_line_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_MLineFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_m_poly_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_MPolyFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_geom_coll_from_wkb(bytea, srid \\ -1) do
    quote do: expr(fragment("ST_GeomCollFromWKB(?,?)", unquote(bytea), unquote(srid)))
  end

  defmacro st_bd_poly_from_text(wkt, srid) do
    quote do: expr(fragment("ST_BdPolyFromText(?,?)", unquote(wkt), unquote(srid)))
  end

  defmacro st_bd_m_poly_from_text(wkt, srid) do
    quote do: expr(fragment("ST_BdMPolyFromText(?,?)", unquote(wkt), unquote(srid)))
  end

  defmacro st_flip_coordinates(geometryA) do
    quote do: expr(fragment("ST_FlipCoordinates(?)", unquote(geometryA)))
  end

  defmacro st_generate_points(geometryA, npoints) do
    quote do: expr(fragment("ST_GeneratePoints(?,?)", unquote(geometryA), unquote(npoints)))
  end

  defmacro st_generate_points(geometryA, npoints, seed) do
    quote do
      expr(
        fragment(
          "ST_GeneratePoints(?,?,?)",
          unquote(geometryA),
          unquote(npoints),
          unquote(seed)
        )
      )
    end
  end

  defmacro st_extent(geometry) do
    quote do: expr(fragment("ST_Extent(?)::geometry", unquote(geometry)))
  end

  defmacro st_build_area(geometryA) do
    quote do: expr(fragment("ST_BuildArea(?)", unquote(geometryA)))
  end
end
