SELECT temp_marge.provider_id,temp_marge.status,temp_marge.id,temp_marge.user_id,temp_marge.created_by,
temp_marge.`office_ministry_id`,temp_marge.`office_layer_id`,
temp_marge.`office_origin_id`,temp_marge.`office_id`,temp_spl.sdg_provider_id,temp_spl.username
FROM 
(SELECT temp_sidp.provider_id,temp_sidp.status,sp.id,sp.user_id,sp.created_by,
sp.`office_ministry_id`,sp.`office_layer_id`,sp.`office_origin_id`,sp.`office_id`
FROM(SELECT DISTINCT sidp.`provider_id`,sidp.`status` 
FROM `sdg_v1_v2_live`.`sdg_indic_def_providers` sidp
WHERE sidp.`status` = 3 ORDER BY sidp.provider_id)temp_sidp
LEFT JOIN `sdg_v1_v2_live`.`sdg_providers` sp ON sp.id = temp_sidp.provider_id)temp_marge
LEFT JOIN(SELECT tmp.sdg_provider_id,tmp.username 
FROM(SELECT  spl.sdg_provider_id,spl.username 
FROM `sdg_v1_v2_live`.`sdg_provider_logs` spl 
GROUP BY spl.sdg_provider_id,spl.username
ORDER BY spl.sdg_provider_id,username DESC)tmp
GROUP BY tmp.sdg_provider_id)temp_spl ON temp_spl.sdg_provider_id = temp_marge.provider_id;