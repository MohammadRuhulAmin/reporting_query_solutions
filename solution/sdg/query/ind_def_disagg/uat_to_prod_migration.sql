SELECT idd.ind_id,idd.ind_def_id,dt.name disagg_type,idd.disagg_type_id,idd.disagg_id,
idd.disagg_name, sdt.name AS sp_disagg_type_name
FROM `uat_sdg_tracker_clone`.`ind_def_disagg` idd
LEFT JOIN `uat_sdg_tracker_clone`.disaggregation_type dt ON dt.id = idd.disagg_type_id
LEFT JOIN `sdg-prod`.disaggregation_type sdt ON sdt.name = dt.name
WHERE idd.ind_id IN (SELECT DISTINCT ind_id FROM 
`uat_sdg_tracker_clone`.`ind_def_disagg` ORDER BY ind_id)
GROUP BY dt.name, idd.disagg_name
HAVING sdt.name IS NULL;