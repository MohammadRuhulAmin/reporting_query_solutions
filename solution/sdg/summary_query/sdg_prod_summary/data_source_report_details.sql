SELECT sx1.agency,target_info.goal_id,target_info.target_number,sx1.prnt_indicator_number indicator_number,
sx1.data_status,sx1.due_data,sx3.last_reporting_year ,sx2.next_reporting_year
FROM(SELECT sq2.prnt_indicator_number,sq2.indicator_id,sq2.agency,
CASE WHEN sq2.total_updated = sq2.total_records THEN "updated"
WHEN sq2.total_no_base_line = sq2.total_records THEN "no data"
ELSE "not updated" END AS data_status,sq2.due_data FROM
(SELECT sq1.prnt_indicator_number,sq1.indicator_id,sq1.agency,GROUP_CONCAT( CONCAT(sq1.indicator_number , "(",sq1.source_id),")") source_list,
SUM(CASE WHEN sq1.data_status = "updated" THEN 1 ELSE 0 END) total_updated,
SUM(CASE WHEN sq1.data_status = "not updated" THEN 1 ELSE 0 END) total_not_update,
SUM(CASE WHEN sq1.data_status = "no data" THEN 1 ELSE 0 END) total_no_base_line,
COUNT(sq1.prnt_indicator_number) total_records,
GROUP_CONCAT(CONCAT(sq1.indicator_number , "(",sq1.due_data),")") due_data
FROM(SELECT sid2.indicator_number prnt_indicator_number,sid2.indicator_id,tbl_agency.agency, pind_info.parent_indicator_id,sid.indicator_number,
temp1.ind_id,temp1.source_id,CASE WHEN temp1.curr_report_year = temp1.max_data_period THEN "updated"
WHEN temp1.total_next_report_year <> temp1.missing_data_year  THEN "not updated"
WHEN temp1.total_next_report_year = temp1.missing_data_year  THEN "no data"
END AS data_status,temp1.missing_data_year_list due_data
FROM(SELECT temp0.ind_id,temp0.source_id, MAX(temp0.next_report_year)curr_report_year,MAX(temp0.data_period) max_data_period,
GROUP_CONCAT(DISTINCT CASE WHEN temp0.year_status = 0 AND temp0.max_deadline < NOW() THEN temp0.next_report_year END )AS missing_data_year_list,
COUNT(temp0.next_report_year) total_next_report_year,
SUM(CASE WHEN temp0.year_status = 0 THEN 1 ELSE 0 END) AS missing_data_year
 FROM(SELECT q1.ind_id,q1.source_id,q1.next_report_year,q1.data_period,
SUM(CASE WHEN q1.data_period IS NULL THEN 0 ELSE 1 END)AS year_status, MAX(q1.deadline) max_deadline FROM 
(SELECT tempx.*,tempy.*,tempz.last_entry_date, CONCAT(tempx.next_report_year+1,"-",tempz.last_entry_date) deadline FROM
(SELECT ind_id,source_id,next_report_year FROM data_update_status 
WHERE  next_report_year <=YEAR(NOW()) ORDER BY ind_id,source_id)tempx
LEFT JOIN
(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data WHERE ind_data.status=4 ORDER BY ind_idx,source_idx)tempy ON tempx.ind_id = tempy.ind_idx 
AND tempx.source_id = tempy.source_idx AND tempx.next_report_year = tempy.data_period
LEFT JOIN
(SELECT ind_def.ind_id,DATE_FORMAT(ind_def.last_entry_date,"%m-%d")last_entry_date FROM ind_definitions ind_def)tempz
ON tempz.ind_id = tempx.ind_id 
ORDER BY tempx.ind_id,tempx.source_id)q1
GROUP BY q1.ind_id,q1.next_report_year,q1.source_id)temp0
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
GROUP BY sq1.prnt_indicator_number, sq1.agency)sq2 
WHERE sq2.prnt_indicator_number  IN(SELECT temp2.indicator_number 
FROM(SELECT sid.indicator_number,temp1.ind_id, GROUP_CONCAT(DISTINCT temp1.ind_src_id) source_list,
temp1.office_agency_id, temp1.agency FROM
(SELECT ids.ind_id,temp0.* FROM ind_def_sources ids
LEFT JOIN
(SELECT ind_sources.id ind_src_id, office_agency_id,office_agencies.name agency FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE office_agency_id > 0 
UNION ALL
SELECT ind_sources.id, ministry_division_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 
UNION ALL
SELECT ind_sources.id, ministry_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0 
UNION  ALL
SELECT ind_sources.id, survey_id,ind_data_source_survey.name FROM ind_sources 
LEFT JOIN ind_data_source_survey ON ind_data_source_survey.id = ind_sources.survey_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id =0 AND survey_id >0)temp0
ON temp0.ind_src_id = ids.source_id)temp1
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = temp1.ind_id AND sid.language_id = 1
GROUP BY temp1.office_agency_id,temp1.ind_id)temp2
WHERE LENGTH(temp2.source_list) - LENGTH(REPLACE(temp2.source_list, ',', '')) = 0)


UNION


SELECT sq2.prnt_indicator_number,sq2.indicator_id,sq2.agency,
CASE WHEN sq2.total_updated = sq2.total_records THEN "updated"
WHEN sq2.total_no_base_line = sq2.total_records THEN "no data"
ELSE "not updated" END AS data_status,sq2.due_data   FROM
(SELECT sq1.prnt_indicator_number,sq1.indicator_id,sq1.agency,GROUP_CONCAT( CONCAT(sq1.indicator_number , "(",sq1.source_id),")") source_list,
SUM(CASE WHEN sq1.data_status = "updated" THEN 1 ELSE 0 END) total_updated,
SUM(CASE WHEN sq1.data_status = "not updated" THEN 1 ELSE 0 END) total_not_update,
SUM(CASE WHEN sq1.data_status = "no data" THEN 1 ELSE 0 END) total_no_base_line,
COUNT(sq1.prnt_indicator_number) total_records,
GROUP_CONCAT(CONCAT(sq1.indicator_number , "(",sq1.due_data),")") due_data
FROM(SELECT sid2.indicator_number prnt_indicator_number,sid2.indicator_id,tbl_agency.agency, pind_info.parent_indicator_id,sid.indicator_number,
#ind_src.name,
temp1.ind_id,temp1.source_id,CASE WHEN temp1.curr_report_year = temp1.max_data_period THEN "updated"
WHEN temp1.total_next_report_year <> temp1.missing_data_year  THEN "not updated"
WHEN temp1.total_next_report_year = temp1.missing_data_year  THEN "no data"
END AS data_status,temp1.missing_data_year_list due_data
FROM(SELECT temp0.ind_id,temp0.source_id, MAX(temp0.next_report_year)curr_report_year,MAX(temp0.data_period) max_data_period,
GROUP_CONCAT(DISTINCT CASE WHEN temp0.year_status = 0 AND temp0.max_deadline < NOW() THEN temp0.next_report_year END )AS missing_data_year_list,
COUNT(temp0.next_report_year) total_next_report_year,
SUM(CASE WHEN temp0.year_status = 0 THEN 1 ELSE 0 END) AS missing_data_year
 FROM(SELECT q1.ind_id,q1.source_id,q1.next_report_year,q1.data_period,
SUM(CASE WHEN q1.data_period IS NULL THEN 0 ELSE 1 END)AS year_status, MAX(q1.deadline) max_deadline FROM 
(SELECT tempx.*,tempy.*,tempz.last_entry_date, CONCAT(tempx.next_report_year+1,"-",tempz.last_entry_date) deadline FROM
(SELECT ind_id,source_id,next_report_year FROM data_update_status 
WHERE  next_report_year <=YEAR(NOW()) ORDER BY ind_id,source_id)tempx
LEFT JOIN
(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data WHERE ind_data.status=4 ORDER BY ind_idx,source_idx)tempy ON tempx.ind_id = tempy.ind_idx 
AND tempx.source_id = tempy.source_idx AND tempx.next_report_year = tempy.data_period
LEFT JOIN
(SELECT ind_def.ind_id,DATE_FORMAT(ind_def.last_entry_date,"%m-%d")last_entry_date FROM ind_definitions ind_def)tempz
ON tempz.ind_id = tempx.ind_id  
ORDER BY tempx.ind_id,tempx.source_id)q1
GROUP BY q1.ind_id,q1.next_report_year)temp0
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
GROUP BY sq1.prnt_indicator_number, sq1.agency)sq2 
WHERE sq2.prnt_indicator_number  IN(SELECT temp2.indicator_number 
FROM(SELECT sid.indicator_number,temp1.ind_id, GROUP_CONCAT(DISTINCT temp1.ind_src_id) source_list,
temp1.office_agency_id, temp1.agency FROM
(SELECT ids.ind_id,temp0.* FROM ind_def_sources ids
LEFT JOIN
(SELECT ind_sources.id ind_src_id, office_agency_id,office_agencies.name agency FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE office_agency_id > 0 
UNION ALL
SELECT ind_sources.id, ministry_division_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 
UNION ALL
SELECT ind_sources.id, ministry_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0 
UNION  ALL
SELECT ind_sources.id, survey_id,ind_data_source_survey.name FROM ind_sources 
LEFT JOIN ind_data_source_survey ON ind_data_source_survey.id = ind_sources.survey_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id =0 AND survey_id >0)temp0
ON temp0.ind_src_id = ids.source_id)temp1
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = temp1.ind_id AND sid.language_id = 1
GROUP BY temp1.office_agency_id,temp1.ind_id)temp2
WHERE LENGTH(temp2.source_list) - LENGTH(REPLACE(temp2.source_list, ',', '')) > 0)
AND prnt_indicator_number NOT IN("4.1.1")


UNION


SELECT sid.indicator_number prnt_indicator_number,sid.indicator_id,
temp1.agency,CASE WHEN temp1.curr_report_year = temp1.max_data_period THEN "updated"
WHEN temp1.total_next_report_year <> temp1.missing_data_year  THEN "not updated"
WHEN temp1.total_next_report_year = temp1.missing_data_year  THEN "no data"
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
WHERE  next_report_year < YEAR(NOW()) ORDER BY ind_id,source_id)tempx 
LEFT JOIN
(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data WHERE ind_data.status = 4 
ORDER BY ind_idx,source_idx)tempy ON tempx.ind_id = tempy.ind_idx 
AND tempx.source_id = tempy.source_idx AND tempx.next_report_year = tempy.data_period
LEFT JOIN
(SELECT ind_def.ind_id,DATE_FORMAT(ind_def.last_entry_date,"%m-%d")last_entry_date FROM ind_definitions ind_def)tempz
ON tempz.ind_id = tempx.ind_id)tp
INNER JOIN sdg_indicators  si ON si.id =tp.ind_id
WHERE  si.status = 1 AND si.parent_indicator_id = 0 AND si.has_child = 0 AND si.is_sdg= 1 AND si.is_plus_one =0 
AND si.is_npt_thirty_nine = 0)calculated_info
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
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = temp1.ind_id AND sid.language_id = 1)sx1
LEFT JOIN
(SELECT si.id,si.goal_id,s_td.target_number FROM sdg_indicators si
LEFT JOIN sdg_target_details s_td ON s_td.target_id = si.target_id AND s_td.language_id = 1)target_info
ON sx1.indicator_id = target_info.id

LEFT JOIN 

(SELECT ind_id,base_data_period,data_frequency_year,
base_data_period +(data_frequency_year*CEIL((YEAR(NOW())-base_data_period)/data_frequency_year)) next_reporting_year
FROM ind_definitions WHERE base_data_period <> 0000)sx2 ON sx1.indicator_id = sx2.ind_id

LEFT JOIN

(SELECT templ.* FROM(SELECT si.id sdg_indicators_idx,si.has_child,CASE WHEN si.has_child = 0  THEN MAX(ind.data_period) 
WHEN si.has_child = 1 THEN (SELECT MAX(data_period) FROM indicator_data WHERE ind_id IN 
(SELECT GROUP_CONCAT(parent.id)  parent_id FROM(SELECT id FROM sdg_indicators WHERE has_child = 1)child
LEFT JOIN (SELECT id,parent_indicator_id FROM sdg_indicators)parent
ON child.id = parent.parent_indicator_id
 WHERE parent_indicator_id = si.id))
END AS last_reporting_year FROM sdg_indicators si
LEFT JOIN indicator_data ind ON ind.ind_id = si.id
GROUP BY si.id)templ)sx3 ON sx3.sdg_indicators_idx = sx1.indicator_id

ORDER BY sx1.indicator_id
