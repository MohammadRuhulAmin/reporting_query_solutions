SELECT *
FROM indicator_disagg_data 
WHERE (ind_data_id, disagg_id) IN (
    SELECT ind_data_id, disagg_id
    FROM indicator_disagg_data
    GROUP BY ind_data_id, disagg_id
    HAVING COUNT(*) > 1
) AND ind_data_id IN (
    SELECT id 
    FROM indicator_data
    WHERE ind_id IN (
        SELECT sid.indicator_id 
        FROM sdg_indicator_details sid 
        LEFT JOIN sdg_indicators si ON si.id = sid.indicator_id
        WHERE sid.indicator_number COLLATE utf8_bin IN (
            SELECT DISTINCT indicator_number 
            FROM sdg_indicator_details
            WHERE language_id = 1 AND indicator_number != ""
            ORDER BY indicator_number
        ) AND sid.language_id = 1
        AND si.is_npt_thirty_nine = 0 
        AND si.is_plus_one = 0
    )
);
