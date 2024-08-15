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
(SELECT si.id ind_id,CONCAT(sid.indicator_number,' ',sid.short_title) sdg_indicator,ti.sequence_en 
FROM sdg_indicator_details sid
LEFT JOIN sdg_indicators si ON sid.indicator_id = si.id
LEFT JOIN tiers ti ON ti.id = si.tier_id
LEFT JOIN ind_def_sources ids ON si.id = ids.ind_id
WHERE sid.language_id = 1 AND si.parent_indicator_id = 0 AND si.is_child = 0 
AND si.is_npt_thirty_nine = 0 AND si.is_sdg = 1  AND si.is_plus_one = 0)temp1
ON temp1.ind_id = temp0.ind_id

