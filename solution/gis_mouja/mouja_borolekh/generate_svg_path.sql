 WITH
    q AS (
		SELECT geom AS geometry,plot_no_en, geocode_en 
		FROM mouja_map 
		WHERE geocode_en like '605814%'and jl_no_en='072' and plot_no_en='6'
	),
    q2 AS (
		SELECT q.plot_no_en plot, b.plot_no_en splot, geom geometry, q.geocode_en FROM q, mouja_map b 
	 	WHERE q.geocode_en=b.geocode_en and st_dwithin(q.geometry,b.geom,1)
	),
	q3 AS (SELECT
        ST_XMin(ST_Collect(geometry)) as x_min,
        ST_XMax(ST_Collect(geometry)) as x_max,
        ST_YMin(ST_Collect(geometry)) as y_min,
        ST_YMax(ST_Collect(geometry)) as y_max,
        ARRAY_TO_STRING(ARRAY_AGG(CONCAT(splot,'@', ST_AsSVG(geometry,0,0))),'$') as svg 
		FROM q2 
	)
SELECT
CONCAT_WS(' ', x_min, -1 * y_max, x_max - x_min, y_max - y_min) AS viewbox,
svg AS paths 
FROM q3;