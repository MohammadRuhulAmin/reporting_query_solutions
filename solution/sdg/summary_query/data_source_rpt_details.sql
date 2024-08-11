SELECT temp1.*,temp2.* FROM
(SELECT tbl_agency.*,ids.ind_id,sg.title,si.id sdg_indicators_id,si.goal_id,si.target_id,si.data_status,si.due_data_years FROM(SELECT id ind_src_id,
TRIM(CASE WHEN office_agency_id >0 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(NAME, ',', 2), ',', -1) 
WHEN office_agency_id = 0 AND ministry_division_id>0 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(NAME, ',', 3), ',', -1)
WHEN office_agency_id = 0 AND ministry_division_id = 0  AND ministry_id>0 THEN SUBSTRING_INDEX(NAME, ',', -1)
END) AS agency FROM ind_sources
GROUP BY agency
HAVING agency IS NOT NULL)tbl_agency
LEFT JOIN ind_def_sources ids ON ids.source_id = tbl_agency.ind_src_id
LEFT JOIN sdg_indicators si ON si.id = ids.ind_id
LEFT JOIN sdg_goals sg ON sg.id = si.goal_id
WHERE ids.ind_id IS NOT NULL)temp1
LEFT JOIN 
(SELECT si.id sdg_indicators_id,MAX(ind.data_period) last_reporting_year FROM sdg_indicators si
LEFT JOIN indicator_data ind ON ind.ind_id = si.id
GROUP BY si.id)temp2 ON temp2.sdg_indicators_id = temp1.sdg_indicators_id