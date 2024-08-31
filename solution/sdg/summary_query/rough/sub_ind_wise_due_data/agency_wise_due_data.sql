SELECT sq2.prnt_indicator_number,sq2.agency,
CASE WHEN sq2.total_updated = sq2.total_records THEN "updated"
WHEN sq2.total_no_base_line = sq2.total_records THEN "no data"
ELSE "not updated" END AS data_status,sq2.due_data   FROM
(SELECT sq1.prnt_indicator_number,sq1.agency,GROUP_CONCAT( CONCAT(sq1.indicator_number , "(",sq1.source_id),")") source_list,
SUM(CASE WHEN sq1.data_status = "updated" THEN 1 ELSE 0 END) total_updated,
SUM(CASE WHEN sq1.data_status = "not updated" THEN 1 ELSE 0 END) total_not_update,
SUM(CASE WHEN sq1.data_status = "has no base line" THEN 1 ELSE 0 END) total_no_base_line,
COUNT(sq1.prnt_indicator_number) total_records,
GROUP_CONCAT(CONCAT(sq1.indicator_number , "(",sq1.source_id),")") due_data
FROM(SELECT sid2.indicator_number prnt_indicator_number,pind_info.parent_indicator_id,temp1.ind_id,sid.indicator_number,tbl_agency.agency,#ind_src.name,
temp1.source_id,
CASE WHEN temp1.curr_report_year = temp1.max_data_period THEN "updated"
WHEN temp1.total_next_report_year <> temp1.missing_data_year  THEN "not updated"
WHEN temp1.total_next_report_year = temp1.missing_data_year  THEN "has no base line"
END AS data_status,temp1.missing_data_year_list due_data
FROM (SELECT temp0.ind_id,temp0.source_id,MAX(temp0.next_report_year)curr_report_year,MAX(temp0.data_period) max_data_period,
GROUP_CONCAT(DISTINCT CASE WHEN temp0.data_period IS NULL AND temp0.deadline < NOW() THEN temp0.next_report_year
 END )AS missing_data_year_list,
COUNT(temp0.next_report_year) total_next_report_year,
SUM(CASE WHEN temp0.data_period IS NULL THEN 1 ELSE 0 END) AS missing_data_year
FROM(SELECT tempx.*,tempy.*,tempz.last_entry_date, CONCAT(tempx.next_report_year+1,"-",tempz.last_entry_date) deadline FROM
(SELECT ind_id,source_id,next_report_year FROM data_update_status 
WHERE  next_report_year <=YEAR(NOW()) ORDER BY ind_id,source_id)tempx
LEFT JOIN
(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data WHERE ind_data.status=4 ORDER BY ind_idx,source_idx)tempy ON tempx.ind_id = tempy.ind_idx 
AND tempx.source_id = tempy.source_idx AND tempx.next_report_year = tempy.data_period
LEFT JOIN
(SELECT ind_def.ind_id,DATE_FORMAT(ind_def.last_entry_date,"%m-%d")last_entry_date FROM ind_definitions ind_def)tempz
ON tempz.ind_id = tempx.ind_id)temp0
GROUP BY temp0.ind_id,temp0.source_id)temp1
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = temp1.ind_id AND sid.language_id = 1
LEFT JOIN ind_sources ind_src ON ind_src.id = temp1.source_id
LEFT JOIN 
(SELECT ind_sources.id ind_src_id, office_agency_id,office_agencies.name agency FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE office_agency_id > 0 
UNION 
SELECT ind_sources.id, ministry_division_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0
UNION 
SELECT ind_sources.id, ministry_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0
UNION  ALL
SELECT ind_sources.id, survey_id,ind_data_source_survey.name FROM ind_sources 
LEFT JOIN ind_data_source_survey ON ind_data_source_survey.id = ind_sources.survey_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id =0 AND survey_id >0)tbl_agency
ON tbl_agency.ind_src_id = temp1.source_id
INNER JOIN
(SELECT id,parent_indicator_id FROM sdg_indicators WHERE parent_indicator_id > 0)pind_info ON pind_info.id = temp1.ind_id
LEFT JOIN sdg_indicator_details sid2 ON sid2.indicator_id = pind_info.parent_indicator_id AND sid2.language_id = 1)sq1
GROUP BY sq1.prnt_indicator_number, sq1.agency)sq2;