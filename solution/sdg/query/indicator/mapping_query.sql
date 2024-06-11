SELECT tmp.serial_no,tmp.sdg_disaggregation_id,tmp.value,tmp.data_period,tmp.name,tmp.source_id,
tmp2.type_name,tmp.status,tmp.publish,tmp.created,tmp.modified,tmp.is_location,
tmp.geo_division_id,tmp.division_name_eng,
tmp.geo_district_id,tmp.district_name_eng,tmp.geo_upazila_id,tmp.upazila_name_eng,tmp.indicator_data_id,
LAG(tmp.indicator_data_id) OVER(ORDER BY tmp.indicator_data_id) AS prev_ind_data_id
FROM (SELECT sil.serial_no,sidc.indicator_data_id,sidc.sdg_disaggregation_id,sidc.value,
stp.name data_period,sdl.name,sid.source_id,sidc.is_location,
sidc.status,sidc.publish,sid.created,sid.modified,
sidc.geo_division_id,gdiv.division_name_eng,sidc.geo_district_id,
gdist.district_name_eng,
sidc.geo_upazila_id,gupazila.upazila_name_eng
FROM sdg_indicator_langs sil
LEFT JOIN sdg_indicator_data sid ON sid.indicator_id = sil.indicator_id
LEFT JOIN sdg_indicator_data_children sidc ON sidc.indicator_data_id = sid.id  
AND sidc.status BETWEEN 3 AND 5 AND sidc.publish BETWEEN 4 AND 5 
LEFT JOIN geo_divisions gdiv ON gdiv.id = sidc.geo_division_id
LEFT JOIN geo_districts gdist ON gdist.id = sidc.geo_district_id
LEFT JOIN geo_upazilas gupazila ON gupazila.id = sidc.geo_upazila_id
LEFT JOIN sdg_time_periods stp ON stp.id = sid.time_period_id
LEFT JOIN sdg_disaggregation_langs sdl ON sdl.disaggregation_id = sidc.sdg_disaggregation_id
WHERE sil.serial_no COLLATE utf8_bin =%s AND sil.language_id = 1 AND sid.status = 3 AND sid.publish IN(4,5))tmp
LEFT JOIN(SELECT child.disaggregation_id disaggregation_id,child.language_id,child.parent_id,
child.name disaggregation_name,parent.name type_name,parent.disaggregation_id type_id ,child.status disagg_status
FROM (SELECT id,disaggregation_id,language_id,parent_id,STATUS,NAME
FROM sdg_disaggregation_langs WHERE parent_id = 0 AND STATUS = 3)parent
LEFT JOIN (SELECT id,disaggregation_id,language_id,parent_id,STATUS,NAME
FROM sdg_disaggregation_langs WHERE parent_id > 0 AND STATUS = 3)child
ON parent.disaggregation_id = child.parent_id 
WHERE parent.status = 3 AND child.status = 3
)tmp2 
ON tmp.sdg_disaggregation_id = tmp2.disaggregation_id
# temp condition_1 start
WHERE tmp.status BETWEEN 3 AND 5 
AND tmp.publish BETWEEN 4 AND 5
# temp condition_1 end
GROUP BY tmp.serial_no,tmp.sdg_disaggregation_id,tmp.value,tmp.data_period,tmp.name,tmp.source_id,
tmp2.type_name,tmp.status,tmp.publish,tmp.created,tmp.modified,tmp.is_location,
tmp.geo_division_id,tmp.division_name_eng,
tmp.geo_district_id,tmp.district_name_eng,tmp.geo_upazila_id,tmp.upazila_name_eng,tmp.indicator_data_id
ORDER BY tmp.indicator_data_id;