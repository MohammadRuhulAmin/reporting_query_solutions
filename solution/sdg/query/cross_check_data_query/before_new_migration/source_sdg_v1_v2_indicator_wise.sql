
SELECT sil.serial_no,sgl.title,sid.indicator_id,
stp.name data_period,sasl.name,sid.source_id,sidc.value,sidc.status,sidc.publish,sidc.created
FROM sdg_indicator_langs sil
LEFT JOIN sdg_indicator_data sid ON sid.indicator_id = sil.indicator_id
LEFT JOIN sdg_goal_langs sgl ON sgl.goal_id = sid.goal_id
LEFT JOIN sdg_indicator_data_children sidc ON sidc.indicator_data_id = sid.id 
LEFT JOIN geo_divisions gdiv ON gdiv.id = sidc.geo_division_id
LEFT JOIN geo_districts gdist ON gdist.id = sidc.geo_district_id
LEFT JOIN geo_upazilas gupazila ON gupazila.id = sidc.geo_upazila_id
LEFT JOIN sdg_time_periods stp ON stp.id = sid.time_period_id
LEFT JOIN sdg_disaggregation_langs sdl ON sdl.disaggregation_id = sidc.sdg_disaggregation_id
LEFT JOIN sdg_arrange_source_langs sasl ON sasl.source_id = sid.source_id
WHERE  -- sil.serial_no COLLATE utf8_bin ="1.1.1" AND
sidc.status BETWEEN 3 AND 5 AND sidc.publish BETWEEN 4 AND 5 
AND sidc.sdg_disaggregation_id = 1
AND sil.language_id = 1 AND sid.status = 3  AND sid.publish IN(4,5)
GROUP BY 
sil.serial_no,stp.name ,sid.source_id,sidc.status,sidc.publish;

