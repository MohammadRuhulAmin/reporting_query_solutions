SELECT temp3.*,temp4.* FROM(SELECT temp1.*,temp2.* FROM
(SELECT tbl_agency.*,ids.ind_id foreign_id,sg.title,sid.indicator_number,si.id sdg_indicators_id,si.goal_id,sdg_td.target_number,
si.target_id,si.data_status,si.due_data_years FROM
(SELECT ind_sources.id ind_src_id, office_agency_id,office_agencies.name agency FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE office_agency_id > 0 GROUP BY office_agency_id
UNION
SELECT ind_sources.id, ministry_division_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 GROUP BY ministry_division_id
UNION
SELECT ind_sources.id, ministry_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0 GROUP BY ministry_id)tbl_agency
LEFT JOIN ind_def_sources ids ON ids.source_id = tbl_agency.ind_src_id
LEFT JOIN sdg_indicators si ON si.id = ids.ind_id AND is_child = 0 AND `is_npt_thirty_nine` = 0 AND is_sdg = 1  AND is_plus_one = 0
LEFT JOIN sdg_target_details sdg_td ON sdg_td.target_id = si.target_id AND sdg_td.language_id = 1
LEFT JOIN sdg_goals sg ON sg.id = si.goal_id
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = ids.ind_id AND sid.language_id = 1
WHERE ids.ind_id IS NOT NULL)temp1
LEFT JOIN 
(SELECT si.id sdg_indicators_idx,MAX(ind.data_period) last_reporting_year FROM sdg_indicators si
LEFT JOIN indicator_data ind ON ind.ind_id = si.id
GROUP BY si.id)temp2 ON temp2.sdg_indicators_idx = temp1.sdg_indicators_id)temp3
LEFT JOIN 
(SELECT ind_id,base_data_period,data_frequency_year, 
base_data_period +(data_frequency_year*CEIL((YEAR(NOW())-base_data_period)/data_frequency_year)) next_reporting_year
FROM ind_definitions WHERE base_data_period <> 0000)temp4 ON temp4.ind_id = temp3.foreign_id;


##### agency mapping  ################

SELECT ind_sources.id ind_src_id, office_agency_id,office_agencies.name FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE office_agency_id > 0 GROUP BY office_agency_id
UNION
SELECT ind_sources.id, ministry_division_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 GROUP BY ministry_division_id
UNION
SELECT ind_sources.id, ministry_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0 GROUP BY ministry_id