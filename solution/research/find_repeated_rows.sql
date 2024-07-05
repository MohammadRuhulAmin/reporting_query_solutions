SELECT * FROM indicator_disagg_data 
WHERE (ind_data_id, disagg_id) IN (
    SELECT ind_data_id, disagg_id
    FROM indicator_disagg_data
    GROUP BY ind_data_id, disagg_id
    HAVING COUNT(*) > 1
);

SELECT type_id, NAME
FROM disaggregation_name
WHERE (type_id, NAME) IN (
    SELECT type_id, NAME
    FROM disaggregation_name
    GROUP BY type_id, NAME
    HAVING COUNT(*) > 1
)
ORDER BY type_id, NAME;