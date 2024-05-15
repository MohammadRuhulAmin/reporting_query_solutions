SELECT sil.serial_no,temp_marge.indicator_id,temp_marge.provider_id,temp_marge.user_id,temp_spl.username,temp_spl.name
FROM 
(SELECT temp_sidp.provider_id,temp_sidp.indicator_id,temp_sidp.status,sp.id,sp.user_id,sp.created_by,
sp.`office_ministry_id`,sp.`office_layer_id`,sp.`office_origin_id`,sp.`office_id`
FROM(SELECT DISTINCT sidp.`provider_id`,sidp.`status`,sidp.indicator_id
FROM `sdg_v1_v2_live`.`sdg_indic_def_providers` sidp
WHERE sidp.`status` = 3 ORDER BY sidp.provider_id)temp_sidp
LEFT JOIN `sdg_v1_v2_live`.`sdg_providers` sp ON sp.id = temp_sidp.provider_id)temp_marge
LEFT JOIN(SELECT tmp.sdg_provider_id,tmp.username ,tmp.name
FROM(SELECT  spl.sdg_provider_id,spl.username,spl.name
FROM `sdg_v1_v2_live`.`sdg_provider_logs` spl 
GROUP BY spl.sdg_provider_id,spl.username
ORDER BY spl.sdg_provider_id,username DESC)tmp
GROUP BY tmp.sdg_provider_id)temp_spl ON temp_spl.sdg_provider_id = temp_marge.provider_id
LEFT JOIN `sdg_v1_v2_live`.`sdg_indicator_langs` sil ON sil.indicator_id = temp_marge.indicator_id AND sil.language_id = 1
ORDER BY sil.serial_no;