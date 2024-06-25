SELECT * FROM indicator_disagg_data 
WHERE (ind_data_id, disagg_id) IN (
    SELECT ind_data_id, disagg_id
    FROM indicator_disagg_data
    GROUP BY ind_data_id, disagg_id
    HAVING COUNT(*) > 1
);
