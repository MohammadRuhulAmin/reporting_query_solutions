SELECT id,TRIM(CASE WHEN office_agency_id >0 THEN SUBSTRING_INDEX(NAME,",",1) 
WHEN office_agency_id = 0 AND ministry_division_id>0 THEN  SUBSTRING_INDEX(SUBSTRING_INDEX(NAME, ',', 2), ',', -1)
WHEN office_agency_id = 0 AND ministry_division_id = 0  AND ministry_id>0 THEN SUBSTRING_INDEX(SUBSTRING_INDEX(NAME, ',', 3), ',', -1)
END) AS agency FROM ind_sources
GROUP BY agency
HAVING agency IS NOT NULL;