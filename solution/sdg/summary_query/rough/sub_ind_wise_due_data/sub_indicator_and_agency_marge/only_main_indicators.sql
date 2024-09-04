SELECT sid.indicator_number,temp1.ind_id,temp1.source_id_list,temp1.agency,CASE WHEN temp1.curr_report_year = temp1.max_data_period THEN "updated"
WHEN temp1.total_next_report_year <> temp1.missing_data_year  THEN "not updated"
WHEN temp1.total_next_report_year = temp1.missing_data_year  THEN "has no base line"
END AS data_status,temp1.missing_data_year_list due_data
FROM 
(SELECT temp0.ind_id,temp0.agency,GROUP_CONCAT(DISTINCT temp0.source_id) source_id_list,
MAX(temp0.next_report_year)curr_report_year,MAX(temp0.data_period) max_data_period,
GROUP_CONCAT(
DISTINCT CASE WHEN temp0.data_period IS NULL AND temp0.deadline < NOW() 
AND NOT EXISTS (
SELECT data_period FROM indicator_data ind_data
WHERE ind_data.ind_id = temp0.ind_id
AND ind_data.source_id IN (SELECT tempm.ind_src_id src_lst
FROM(SELECT ind_sources.id ind_src_id, office_agency_id,office_agencies.name agency FROM ind_sources 
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
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id =0 AND survey_id >0 
)tempm LEFT JOIN ind_def_sources ids ON ids.source_id = tempm.ind_src_id
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = ids.ind_id 
WHERE ids.ind_id = temp0.ind_id AND tempm.office_agency_id = temp0.office_agency_id AND  sid.language_id = 1
GROUP BY tempm.office_agency_id)
AND ind_data.data_period = temp0.next_report_year
AND ind_data.status = 4)
THEN temp0.next_report_year END )AS missing_data_year_list,
COUNT(temp0.next_report_year) total_next_report_year,
SUM(CASE WHEN temp0.data_period IS NULL THEN 1 ELSE 0 END) AS missing_data_year,temp0.office_agency_id
FROM
(SELECT calculated_info.ind_id,calculated_info.source_id,
calculated_info.next_report_year,calculated_info.data_period
,agency_info.office_agency_id,agency_info.agency,calculated_info.deadline
FROM(SELECT si.id si_id, tp.* FROM(SELECT tempx.*,tempy.*,tempz.last_entry_date, 
CONCAT(tempx.next_report_year+1,"-",tempz.last_entry_date) deadline 
FROM(SELECT ind_id,source_id,next_report_year FROM data_update_status 
WHERE  next_report_year < YEAR(NOW()) ORDER BY ind_id,source_id)tempx # <= condition 
LEFT JOIN
(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data WHERE ind_data.status = 4 
ORDER BY ind_idx,source_idx)tempy ON tempx.ind_id = tempy.ind_idx 
AND tempx.source_id = tempy.source_idx AND tempx.next_report_year = tempy.data_period
LEFT JOIN
(SELECT ind_def.ind_id,DATE_FORMAT(ind_def.last_entry_date,"%m-%d")last_entry_date FROM ind_definitions ind_def)tempz
ON tempz.ind_id = tempx.ind_id)tp
INNER JOIN sdg_indicators  si ON si.id =tp.ind_id
WHERE  si.status = 1 AND si.parent_indicator_id = 0 AND si.has_child = 0 AND si.is_sdg= 1 AND si.is_plus_one =0 AND si.is_npt_thirty_nine = 0)calculated_info
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
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id =0 AND survey_id >0)agency_info
ON agency_info.ind_src_id = calculated_info.source_id
ORDER BY agency_info.office_agency_id)temp0
GROUP BY temp0.ind_id,temp0.office_agency_id)temp1
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = temp1.ind_id AND sid.language_id = 1