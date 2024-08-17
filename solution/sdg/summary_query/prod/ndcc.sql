SELECT sq1.ind_id,sq1.source_id,sq4.sdg_indicator,sq4.sequence_en tier_classification,sq1.institution,sq1.activity,sq4.reporting_frequency,sq2.b_year,sq2.data_value_b,
sq3.c_year,sq3.data_value_c
,sq5.min_disagg_dimention,sq6.formatted_date deadline FROM(SELECT tbl_agency.*, CASE WHEN  idss.name = tbl_agency.institution THEN NULL 
ELSE idss.name END AS activity,ids.ind_id,ids.source_id FROM
(SELECT ind_sources.id ind_src_id, office_agency_id,survey_id,office_agencies.name institution FROM ind_sources 
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
LEFT JOIN ind_data_source_survey idss ON idss.id = tbl_agency.survey_id
INNER JOIN ind_def_sources ids ON ids.source_id = tbl_agency.ind_src_id)sq1
LEFT JOIN 
(SELECT tmd.ind_id,tmd.source_id,tmd.b_year,ind_data.data_value data_value_b FROM indicator_data ind_data
INNER JOIN 
(SELECT ind.ind_id, ind.source_id, MIN(ind.data_period) AS b_year
FROM indicator_data ind
WHERE STATUS = 4
GROUP BY ind.ind_id, ind.source_id)tmd
ON ind_data.ind_id = tmd.ind_id AND 
ind_data.source_id = tmd.source_id AND
ind_data.data_period = tmd.b_year
WHERE ind_data.data_value IS NOT NULL)sq2 ON sq1.ind_id = sq2.ind_id AND sq1.source_id = sq2.source_id

LEFT JOIN 
(SELECT tmd.ind_id,tmd.source_id,tmd.c_year,ind_data.data_value data_value_c FROM indicator_data ind_data
INNER JOIN 
(SELECT ind.ind_id, ind.source_id, MAX(ind.data_period) AS c_year
FROM indicator_data ind
WHERE STATUS = 4
GROUP BY ind.ind_id, ind.source_id)tmd
ON ind_data.ind_id = tmd.ind_id AND 
ind_data.source_id = tmd.source_id AND
ind_data.data_period = tmd.c_year 
WHERE ind_data.data_value IS NOT NULL)sq3 ON sq3.ind_id = sq1.ind_id AND sq3.source_id = sq1.source_id

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
WHERE si.index_id = 1 AND sid.language_id = 1 # AND si.parent_indicator_id = 0 AND si.is_child = 0 
AND si.is_npt_thirty_nine = 0 AND si.is_sdg = 1  AND si.is_plus_one = 0 
GROUP BY si.id,sdg_indicator,sequence_en,reporting_frequency)sq4 ON sq4.ind_id = sq1.ind_id

LEFT JOIN 
(SELECT temp4.ind_id,GROUP_CONCAT(temp4.disagg_nm_lst SEPARATOR ';') min_disagg_dimention
FROM(SELECT idd.ind_id,CONCAT(dt.name,":",GROUP_CONCAT(idd.disagg_name)) disagg_nm_lst FROM ind_def_disagg idd
LEFT JOIN disaggregation_type dt ON dt.id = idd.disagg_type_id
GROUP BY idd.ind_id,idd.disagg_type_id)temp4
GROUP BY temp4.ind_id)sq5 ON sq5.ind_id = sq1.ind_id

LEFT JOIN 

(SELECT ind_def.ind_id,CONCAT(CASE 
WHEN DAY(DATE(ind_def.last_entry_date)) IN (1, 21, 31) THEN CONCAT(DAY(DATE(ind_def.last_entry_date)), 'st')
WHEN DAY(DATE(ind_def.last_entry_date)) IN (2, 22) THEN CONCAT(DAY(DATE(ind_def.last_entry_date)), 'nd')
WHEN DAY(DATE(ind_def.last_entry_date)) IN (3, 23) THEN CONCAT(DAY(DATE(ind_def.last_entry_date)), 'rd')
ELSE CONCAT(DAY(DATE(ind_def.last_entry_date)), 'th')
END,", ",DATE_FORMAT(ind_def.last_entry_date, '%M')) AS formatted_date
FROM ind_definitions ind_def GROUP BY ind_id,formatted_date)sq6 ON sq6.ind_id = sq1.ind_id;


