SELECT temp.ind_idx,temp.source_idx,CASE WHEN temp.next_report_year IS NULL THEN GROUP_CONCAT(DISTINCT temp.data_period) END AS due_data_year
 FROM(SELECT tempx.*,tempy.* 
FROM(SELECT ind_data.ind_id ind_idx,ind_data.source_id source_idx,ind_data.data_period 
FROM indicator_data ind_data
)tempx
LEFT JOIN
(SELECT ind_id,source_id,next_report_year FROM data_update_status 
WHERE  next_report_year <=YEAR(NOW()))tempy
ON tempx.data_period = tempy.next_report_year AND tempx.ind_idx = tempy.ind_id AND tempx.source_idx = tempy.source_id)temp
GROUP BY temp.ind_idx,source_idx;