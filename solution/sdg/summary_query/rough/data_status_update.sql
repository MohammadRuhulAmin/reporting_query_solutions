SELECT sid.indicator_number,ind_src.name,temp1.ind_id,temp1.source_id,CASE WHEN temp1.curr_report_year = temp1.max_data_period THEN "updated"
WHEN temp1.total_next_report_year <> temp1.missing_data_year  THEN "not updated"
WHEN temp1.total_next_report_year = temp1.missing_data_year  THEN "has no base line"
END AS data_status,temp1.missing_data_year_list due_data
FROM (SELECT temp0.ind_id,temp0.source_id,MAX(temp0.next_report_year)curr_report_year,MAX(temp0.data_period) max_data_period,
GROUP_CONCAT(DISTINCT CASE WHEN temp0.data_period IS NULL AND temp0.next_report_year <> YEAR(NOW()) THEN temp0.next_report_year
WHEN temp0.data_period IS NULL AND temp0.next_report_year = YEAR(NOW()) 
THEN (SELECT CASE WHEN NOW() > CONCAT(YEAR(NOW())+1,"-",DATE_FORMAT(ind_def.last_entry_date,"%m-%d")) THEN YEAR(NOW()) END AS  last_entry_date 
FROM ind_definitions ind_def WHERE ind_def.ind_id = temp0.ind_id)  
END )AS missing_data_year_list,
COUNT(temp0.next_report_year) total_next_report_year,
SUM(CASE WHEN temp0.data_period IS NULL THEN 1 ELSE 0 END) AS missing_data_year
FROM(SELECT tempx.*,tempy.* FROM
(SELECT ind_id,source_id,next_report_year FROM data_update_status 
WHERE  next_report_year <=YEAR(NOW()) ORDER BY ind_id,source_id)tempx
LEFT JOIN
(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data WHERE ind_data.status=4 ORDER BY ind_idx,source_idx)tempy ON tempx.ind_id = tempy.ind_idx 
AND tempx.source_id = tempy.source_idx AND tempx.next_report_year = tempy.data_period)temp0
GROUP BY temp0.ind_id,temp0.source_id)temp1
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = temp1.ind_id AND sid.language_id = 1
LEFT JOIN ind_sources ind_src ON ind_src.id = temp1.source_id;