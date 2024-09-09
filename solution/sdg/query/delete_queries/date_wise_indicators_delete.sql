DELETE indicator_data, indicator_geo_data, indicator_disagg_data
FROM indicator_data 
LEFT JOIN indicator_disagg_data ON indicator_disagg_data.ind_data_id = indicator_data.id
LEFT JOIN indicator_geo_data  ON indicator_geo_data.ind_data_id = indicator_data.id
LEFT JOIN indicator_series_data ON indicator_series_data.ind_data_id = indicator_data.id
WHERE DATE(indicator_data.created_at) = "2019-07-03";