SELECT #sq1.ind_id,sq1.source_id,
sq1.institution `source`,sq4.sdg_indicator indicator,ind_data.data_value value_of_data_awaiting_authentication,ind_data.data_period value_of_year_awaiting_authentication
,ind_datax.data_value value_of_data_already_authenticated,ind_datax.data_period value_of_year_already_authenticated
FROM(SELECT tbl_agency.*, CASE WHEN  idss.name = tbl_agency.institution THEN NULL 
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

(SELECT si.id ind_id,CONCAT(sid.indicator_number,' ',sid.short_title) sdg_indicator
FROM sdg_indicator_details sid
LEFT JOIN sdg_indicators si ON sid.indicator_id = si.id
LEFT JOIN tiers ti ON ti.id = si.tier_id
LEFT JOIN ind_def_sources ids ON si.id = ids.ind_id
LEFT JOIN ind_definitions id ON id.ind_id = sid.indicator_id AND sid.language_id = 1
WHERE si.index_id = 1 AND sid.language_id = 1 # AND si.parent_indicator_id = 0 AND si.is_child = 0 
AND si.is_npt_thirty_nine = 0 AND si.is_sdg = 1  AND si.is_plus_one = 0 
GROUP BY si.id,sdg_indicator)sq4 ON sq4.ind_id = sq1.ind_id

left join indicator_data ind_data on ind_data.ind_id = sq1.ind_id and ind_data.source_id = sq1.source_id 

left join indicator_data ind_datax on ind_datax.ind_id = sq1.ind_id and ind_datax.source_id = sq1.source_id

left join sdg_indicators si on si.id = sq1.ind_id

where ind_data.status = 3
and ind_datax.status = 4

GROUP BY  sq1.ind_id,sq1.source_id,
sq4.sdg_indicator,sq1.institution ,ind_data.data_value,ind_data.data_period,
ind_datax.data_value,ind_datax.data_period;




