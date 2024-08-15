SELECT temp0.*,temp1.*,idss.name Activity FROM
(SELECT tbl_agency.*,ids.source_id,ids.ind_id 
FROM(SELECT ind_sources.id ind_src_id, office_agency_id,survey_id,office_agencies.name agency FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE ind_sources.office_agency_id > 0 
UNION
SELECT ind_sources.id, ministry_division_id,survey_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 
UNION
SELECT ind_sources.id, ministry_id,survey_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0
UNION
SELECT ind_sources.id ind_src_id, ind_sources.survey_id,ind_sources.survey_id,`ind_data_source_survey`.name agency FROM ind_sources 
LEFT JOIN `ind_data_source_survey` ON `ind_data_source_survey`.id = ind_sources.survey_id 
WHERE ind_sources.ministry_id = 0 AND ind_sources.ministry_division_id = 0 AND ind_sources.office_agency_id = 0)tbl_agency
LEFT JOIN ind_def_sources ids ON ids.source_id = tbl_agency.ind_src_id)temp0
LEFT JOIN ind_data_source_survey idss ON idss.id = temp0.survey_id
LEFT JOIN 
(SELECT si.id ind_id,CONCAT(sid.indicator_number,' ',sid.short_title) sdg_indicator,
ti.sequence_en, CASE WHEN id.data_frequency_year = 1 THEN "Annual" WHEN id.data_frequency_year = 2 THEN "Bi-annual"
WHEN id.data_frequency_year = 3 THEN "Triennial" WHEN id.data_frequency_year = 4 THEN "Quadrennial"
WHEN id.data_frequency_year = 5 THEN "Five-yearly" WHEN id.data_frequency_year = 10 THEN "Ten-yearly"
ELSE NULL END AS reporting_frequency
FROM sdg_indicator_details sid
LEFT JOIN sdg_indicators si ON sid.indicator_id = si.id
LEFT JOIN tiers ti ON ti.id = si.tier_id
LEFT JOIN ind_def_sources ids ON si.id = ids.ind_id
LEFT JOIN ind_definitions id ON id.ind_id = sid.indicator_id AND sid.language_id = 1
WHERE sid.language_id = 1 AND si.parent_indicator_id = 0 AND si.is_child = 0 
AND si.is_npt_thirty_nine = 0 AND si.is_sdg = 1  AND si.is_plus_one = 0)temp1
ON temp1.ind_id = temp0.ind_id;


#######################################
SELECT temp2.*,idss.name  b_source
FROM(SELECT ind_data.ind_id, ind_data.source_id,ind_src.survey_id, ind_data.data_value b_data,ind_data.data_period b_year
FROM indicator_data ind_data
INNER JOIN (
    SELECT ind.ind_id, ind.source_id, MIN(ind.data_period) AS b_year
    FROM indicator_data ind
    GROUP BY ind.ind_id, ind.source_id
) temp_min_data
ON ind_data.ind_id = temp_min_data.ind_id
AND ind_data.source_id = temp_min_data.source_id
AND ind_data.data_period = temp_min_data.b_year
LEFT JOIN ind_sources ind_src ON ind_src.id = ind_data.source_id)temp2
LEFT JOIN ind_data_source_survey idss ON idss.id = temp2.survey_id


#########################################
SELECT temp3.*,idss.name  c_source
FROM(SELECT ind_data.ind_id, ind_data.source_id,ind_src.survey_id, ind_data.data_value c_data,ind_data.data_period c_year
FROM indicator_data ind_data
INNER JOIN (
    SELECT ind.ind_id, ind.source_id, MAX(ind.data_period) AS b_year
    FROM indicator_data ind
    GROUP BY ind.ind_id, ind.source_id
) temp_min_data
ON ind_data.ind_id = temp_min_data.ind_id
AND ind_data.source_id = temp_min_data.source_id
AND ind_data.data_period = temp_min_data.b_year
LEFT JOIN ind_sources ind_src ON ind_src.id = ind_data.source_id)temp3
LEFT JOIN ind_data_source_survey idss ON idss.id = temp3.survey_id


#######################

SELECT temp4.ind_id,GROUP_CONCAT(temp4.disagg_nm_lst SEPARATOR ';') min_disagg_dimention
FROM(SELECT idd.ind_id,CONCAT(dt.name,":",GROUP_CONCAT(idd.disagg_name)) disagg_nm_lst FROM ind_def_disagg idd
LEFT JOIN disaggregation_type dt ON dt.id = idd.disagg_type_id
GROUP BY idd.ind_id,idd.disagg_type_id)temp4
GROUP BY temp4.ind_id;


########################


SELECT ind_def.ind_id,CONCAT(CASE 
WHEN DAY(DATE(ind_def.last_entry_date)) IN (1, 21, 31) THEN CONCAT(DAY(DATE(ind_def.last_entry_date)), 'st')
WHEN DAY(DATE(ind_def.last_entry_date)) IN (2, 22) THEN CONCAT(DAY(DATE(ind_def.last_entry_date)), 'nd')
WHEN DAY(DATE(ind_def.last_entry_date)) IN (3, 23) THEN CONCAT(DAY(DATE(ind_def.last_entry_date)), 'rd')
ELSE CONCAT(DAY(DATE(ind_def.last_entry_date)), 'th')
END,", ",DATE_FORMAT(ind_def.last_entry_date, '%M')) AS formatted_date
FROM ind_definitions ind_def;