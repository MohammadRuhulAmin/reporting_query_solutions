# sub query 1

SELECT tbl_agency.*,temp1.* FROM
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
LEFT JOIN
(SELECT tempx.*,tempy.* FROM(SELECT sg.title,si.id ind_id,si.goal_id,sdg_td.target_number,
si.target_id FROM sdg_indicators  si 
LEFT JOIN sdg_target_details sdg_td ON sdg_td.target_id = si.target_id AND sdg_td.language_id = 1
LEFT JOIN sdg_goals sg ON sg.id = si.goal_id
WHERE  si.is_child = 0 AND si.`is_npt_thirty_nine` = 0 AND si.is_sdg = 1  AND si.is_plus_one = 0)tempx
LEFT JOIN 
(SELECT ids.ind_id ind_idy,ids.source_id,sid.indicator_number FROM ind_def_sources ids
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = ids.ind_id AND sid.language_id = 1)tempy 
ON tempx.ind_id = tempy.ind_idy)temp1 ON tbl_agency.ind_src_id = temp1.source_id


##########################

# sub query 2
(SELECT si.id ind_id,MAX(ind.data_period) last_reporting_year FROM sdg_indicators si
LEFT JOIN indicator_data ind ON ind.ind_id = si.id
GROUP BY si.id)temp2 

#sub query 3

(SELECT ind_id,base_data_period,data_frequency_year, 
base_data_period +(data_frequency_year*CEIL((YEAR(NOW())-base_data_period)/data_frequency_year)) next_reporting_year
FROM ind_definitions WHERE base_data_period <> 0000)temp3;


#sub query 4

#SELECT * FROM indicator_data WHERE ind_id = 123 AND source_id IN(63,82,187) AND STATUS = 4;

SELECT sid.indicator_number,ids.ind_id,GROUP_CONCAT(distinct temp0.ind_src_id) src_lst ,temp0.office_agency_id,temp0.agency
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
)temp0 LEFT JOIN ind_def_sources ids ON ids.source_id = temp0.ind_src_id
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = ids.ind_id AND language_id = 1
WHERE sid.indicator_number = "9.5.2"
GROUP BY temp0.office_agency_id;

#sub query 5
SELECT temp1.ind_id,temp1.source_id_list,CASE WHEN temp1.curr_report_year = temp1.max_data_period THEN "updated"
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
WHERE ids.ind_id = temp0.ind_id AND tempm.office_agency_id = temp0.office_agency_id
GROUP BY tempm.office_agency_id)
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
WHERE  next_report_year <=YEAR(NOW()) ORDER BY ind_id,source_id)tempx
LEFT JOIN
(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data WHERE ind_data.status=4 ORDER BY ind_idx,source_idx)tempy ON tempx.ind_id = tempy.ind_idx 
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
WHERE calculated_info.ind_id = 123 
ORDER BY agency_info.office_agency_id)temp0
GROUP BY temp0.office_agency_id)temp1;


