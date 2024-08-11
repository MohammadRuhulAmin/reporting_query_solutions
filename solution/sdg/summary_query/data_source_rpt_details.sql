SELECT tbl_agency.*,ids.ind_id,si.data_status,si.due_data_years FROM(SELECT id ind_src_id,
TRIM(CASE WHEN office_agency_id >0 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(NAME, ',', 2), ',', -1) 
WHEN office_agency_id = 0 AND ministry_division_id>0 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(NAME, ',', 3), ',', -1)
WHEN office_agency_id = 0 AND ministry_division_id = 0  AND ministry_id>0 THEN SUBSTRING_INDEX(NAME, ',', -1)
END) AS agency FROM ind_sources
GROUP BY agency
HAVING agency IS NOT NULL)tbl_agency
LEFT JOIN ind_def_sources ids ON ids.source_id = tbl_agency.ind_src_id
LEFT JOIN sdg_indicators si ON si.id = ids.ind_id
WHERE ids.ind_id IS NOT NULL;