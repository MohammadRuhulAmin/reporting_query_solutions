SELECT temp0.*,temp1.*,temp2.* FROM(SELECT  tbl_agency.institution,tbl_agency.ind_id,tbl_agency.type,si.data_status,si.due_data_years
FROM(SELECT idm.id ind_src_id,idm.ind_id, idm.type,idm.office_agency_id agency_id,office_agencies.name institution 
FROM ind_def_ministry idm
LEFT JOIN office_agencies ON office_agencies.id = idm.office_agency_id 
WHERE idm.office_agency_id > 0 
UNION
SELECT idm.id,idm.ind_id, idm.type,ministry_division_id,ministry_divisions.name FROM ind_def_ministry idm
LEFT JOIN ministry_divisions ON ministry_divisions.id = idm.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 
UNION
SELECT idm.id, idm.ind_id,idm.type,idm.ministry_id,ministries.name FROM ind_def_ministry idm
LEFT JOIN ministries ON ministries.id = idm.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0)tbl_agency
LEFT JOIN sdg_indicators si ON si.id = tbl_agency.ind_id)temp0
LEFT JOIN 
(SELECT si.id ind_id,MAX(ind.data_period) last_reporting_year FROM sdg_indicators si
LEFT JOIN indicator_data ind ON ind.ind_id = si.id
GROUP BY si.id)temp1 ON temp1.ind_id = temp0.ind_id
LEFT JOIN 
(SELECT ind_id,base_data_period +(data_frequency_year*CEIL((YEAR(NOW())-base_data_period)/data_frequency_year)) next_reporting_year
FROM ind_definitions WHERE base_data_period <> 0000)temp2 ON temp2.ind_id = temp0.ind_id;