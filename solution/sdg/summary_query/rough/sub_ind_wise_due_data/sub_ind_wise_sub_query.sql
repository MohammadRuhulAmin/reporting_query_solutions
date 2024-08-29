SELECT sid.indicator_number,sq2.nlist,sq2.p_ind_id,sq2.source_list,
CASE WHEN sq2.total_updated = sq2.parent_records THEN "updated"
WHEN sq2.total_no_base_line = sq2.parent_records THEN "no data"
ELSE "not updated" END AS data_status,
sq2.due_data_list
 FROM(SELECT GROUP_CONCAT(sq1.indicator_number) nlist ,GROUP_CONCAT(sq1.ind_id)ind_idlist,
sq1.p_ind_id, GROUP_CONCAT(DISTINCT CONCAT(sq1.indicator_number,"(",sq1.source_id_list,")" )) source_list,
GROUP_CONCAT(DISTINCT CONCAT(sq1.indicator_number,"(",sq1.due_data,")" )) due_data_list,
SUM(CASE WHEN sq1.data_status = "updated" THEN 1 ELSE 0 END) AS total_updated,
SUM(CASE WHEN sq1.data_status = "not updated" THEN 1 ELSE 0 END) AS total_not_updated,
SUM(CASE WHEN sq1.data_status = "has no base line" THEN 1 ELSE 0 END) AS total_no_base_line,
COUNT(sq1.p_ind_id) parent_records
FROM(SELECT sid.indicator_number,
parent_ind_info.p_ind_id,parent_ind_info.source_id,temp_ind_wise_result.* 
FROM(SELECT temp1.ind_id,temp1.source_id_list,CASE WHEN temp1.curr_report_year = temp1.max_data_period THEN "updated"
WHEN temp1.total_next_report_year <> temp1.missing_data_year  THEN "not updated"
WHEN temp1.total_next_report_year = temp1.missing_data_year  THEN "has no base line"
END AS data_status,temp1.missing_data_year_list due_data
FROM 
(SELECT temp0.ind_id,GROUP_CONCAT(DISTINCT temp0.source_id) source_id_list,
MAX(temp0.next_report_year)curr_report_year,MAX(temp0.data_period) max_data_period,
GROUP_CONCAT(
DISTINCT CASE WHEN temp0.data_period IS NULL AND temp0.deadline < NOW() 
AND NOT EXISTS (
SELECT data_period FROM indicator_data ind_data
WHERE ind_data.ind_id = temp0.ind_id
AND ind_data.source_id IN (SELECT tempm.ind_src_id src_lst
FROM(SELECT ind_sources.id ind_src_id, office_agency_id,office_agencies.name agency FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE office_agency_id > 0 #GROUP BY office_agency_id
UNION 
SELECT ind_sources.id, ministry_division_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 #GROUP BY ministry_division_id
UNION 
SELECT ind_sources.id, ministry_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0 #GROUP BY ministry_id
UNION  ALL
SELECT ind_sources.id, survey_id,ind_data_source_survey.name FROM ind_sources 
LEFT JOIN ind_data_source_survey ON ind_data_source_survey.id = ind_sources.survey_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id =0 AND survey_id >0 #GROUP BY survey_id
)tempm LEFT JOIN ind_def_sources ids ON ids.source_id = tempm.ind_src_id
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = ids.ind_id AND language_id = 1
WHERE ids.ind_id = temp0.ind_id AND tempm.office_agency_id = temp0.office_agency_id)
AND ind_data.data_period = temp0.next_report_year
AND ind_data.status = 4)
THEN temp0.next_report_year END )AS missing_data_year_list,
COUNT(temp0.next_report_year) total_next_report_year,
SUM(CASE WHEN temp0.data_period IS NULL THEN 1 ELSE 0 END) AS missing_data_year,temp0.office_agency_id
FROM
(SELECT calculated_info.ind_id,calculated_info.source_id,calculated_info.next_report_year,calculated_info.data_period
,agency_info.office_agency_id,agency_info.agency,calculated_info.deadline
FROM(SELECT tempx.*,tempy.*,tempz.last_entry_date, CONCAT(tempx.next_report_year+1,"-",tempz.last_entry_date) deadline 
FROM(SELECT ind_id,source_id,next_report_year FROM data_update_status 
WHERE  next_report_year < YEAR(NOW()) ORDER BY ind_id,source_id)tempx # <= condition 
LEFT JOIN
(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data WHERE ind_data.status= 4 
ORDER BY ind_idx,source_idx)tempy ON tempx.ind_id = tempy.ind_idx 
AND tempx.source_id = tempy.source_idx AND tempx.next_report_year = tempy.data_period
LEFT JOIN
(SELECT ind_def.ind_id,DATE_FORMAT(ind_def.last_entry_date,"%m-%d")last_entry_date FROM ind_definitions ind_def)tempz
ON tempz.ind_id = tempx.ind_id)calculated_info
LEFT JOIN
(SELECT ind_sources.id ind_src_id, office_agency_id,office_agencies.name agency FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE office_agency_id > 0 #GROUP BY office_agency_id
UNION 
SELECT ind_sources.id, ministry_division_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 #GROUP BY ministry_division_id
UNION 
SELECT ind_sources.id, ministry_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0 #GROUP BY ministry_id
UNION  ALL
SELECT ind_sources.id, survey_id,ind_data_source_survey.name FROM ind_sources 
LEFT JOIN ind_data_source_survey ON ind_data_source_survey.id = ind_sources.survey_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id =0 AND survey_id >0)agency_info
ON agency_info.ind_src_id = calculated_info.source_id
WHERE calculated_info.ind_id IN(SELECT DISTINCT si.id ind_id  FROM sdg_indicators si 
LEFT JOIN ind_def_sources ids ON ids.ind_id = si.id
WHERE si.parent_indicator_id > 0)
ORDER BY agency_info.office_agency_id)temp0
GROUP BY temp0.ind_id)temp1)temp_ind_wise_result
LEFT JOIN 
(SELECT si.id ind_id ,si.parent_indicator_id p_ind_id,ids.source_id FROM sdg_indicators si 
LEFT JOIN ind_def_sources ids ON ids.ind_id = si.id
WHERE si.parent_indicator_id > 0 AND
 si.status = 1)parent_ind_info ON parent_ind_info.ind_id = temp_ind_wise_result.ind_id
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = parent_ind_info.ind_id  WHERE sid.language_id = 1
GROUP BY parent_ind_info.ind_id)sq1
GROUP BY sq1.p_ind_id)sq2
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = sq2.p_ind_id 
WHERE sid.language_id = 1;


SELECT  si.id ind_id ,si.parent_indicator_id p_ind_id,ids.source_id FROM sdg_indicators si 
LEFT JOIN ind_def_sources ids ON ids.ind_id = si.id
WHERE si.parent_indicator_id > 0;