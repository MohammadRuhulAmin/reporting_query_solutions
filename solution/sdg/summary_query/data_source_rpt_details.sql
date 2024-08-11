
SELECT temp3.*,temp4.* FROM(SELECT temp1.*,temp2.* FROM
(SELECT tbl_agency.*,ids.ind_id foreign_id,sg.title,sid.indicator_number,si.id sdg_indicators_id,si.goal_id,si.target_id,si.data_status,si.due_data_years FROM(SELECT id ind_src_id,
TRIM(CASE WHEN office_agency_id >0 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(NAME, ',', 2), ',', -1) 
WHEN office_agency_id = 0 AND ministry_division_id>0 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(NAME, ',', 3), ',', -1)
WHEN office_agency_id = 0 AND ministry_division_id = 0  AND ministry_id>0 THEN SUBSTRING_INDEX(NAME, ',', -1)
END) AS agency FROM ind_sources
GROUP BY agency
HAVING agency IS NOT NULL)tbl_agency
LEFT JOIN ind_def_sources ids ON ids.source_id = tbl_agency.ind_src_id
LEFT JOIN sdg_indicators si ON si.id = ids.ind_id AND is_child = 0 AND `is_npt_thirty_nine` = 0 AND is_sdg = 1  AND is_plus_one = 0
LEFT JOIN sdg_goals sg ON sg.id = si.goal_id
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = ids.ind_id AND sid.language_id = 1
WHERE ids.ind_id IS NOT NULL)temp1
LEFT JOIN 
(SELECT si.id sdg_indicators_idx,MAX(ind.data_period) last_reporting_year FROM sdg_indicators si
LEFT JOIN indicator_data ind ON ind.ind_id = si.id
GROUP BY si.id)temp2 ON temp2.sdg_indicators_idx = temp1.sdg_indicators_id)temp3

LEFT JOIN 
(SELECT ind_id,base_data_period,data_frequency_year, 
base_data_period +(data_frequency_year*CEIL((YEAR(NOW())-base_data_period)/data_frequency_year)) next_year_report
FROM ind_definitions WHERE base_data_period <> 0000)temp4 ON temp4.ind_id = temp3.foreign_id;

