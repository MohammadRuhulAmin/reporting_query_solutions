#with joining as required
SELECT sid.indicator_number,ind_srs.name,temp2.* FROM(SELECT ind_data.source_id,ind_data.data_period,
ind_data.ind_id indicator_id ,temp.ind_data_id,temp.disagg_id,temp.disagg_name FROM(SELECT *
FROM indicator_disagg_data 
WHERE (ind_data_id, disagg_id) IN (SELECT ind_data_id, disagg_id
FROM indicator_disagg_data GROUP BY ind_data_id, disagg_id
HAVING COUNT(*) > 1) AND ind_data_id IN (
SELECT id FROM indicator_data WHERE ind_id IN (
SELECT sid.indicator_id FROM sdg_indicator_details sid 
LEFT JOIN sdg_indicators si ON si.id = sid.indicator_id
WHERE sid.indicator_number COLLATE utf8_bin IN (
SELECT DISTINCT indicator_number 
FROM sdg_indicator_details
WHERE language_id = 1 AND indicator_number != ""
ORDER BY indicator_number) AND sid.language_id = 1
AND si.is_npt_thirty_nine = 0 AND si.is_plus_one = 0)))temp
LEFT JOIN indicator_data ind_data ON ind_data.id = temp.ind_data_id)temp2
LEFT JOIN ind_sources ind_srs ON ind_srs.id = temp2.source_id
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = temp2.indicator_id AND language_id = 1

