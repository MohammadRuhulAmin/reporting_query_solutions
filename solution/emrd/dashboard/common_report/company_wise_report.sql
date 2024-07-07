# report those who provides data in gas_production table
SELECT report_info.org_short_name company,report_info.last_update,report_info.report_submit_time,
report_info.update_on_time,org_info.responsible,org_info.mobile
FROM
(SELECT oi.org_short_name,gp.org_id,gp.report_date last_update, gp.created_at report_submit_time,
CASE 
WHEN (DATE(gp.created_at) != gp.report_date AND gp.created_at - INTERVAL 1 DAY >  CONCAT(gp.report_date," 17:00:00")) THEN "No"
WHEN (DATE(gp.created_at)  = gp.report_date AND gp.created_at  >  CONCAT(gp.report_date," 17:00:00")) THEN "No"
ELSE "Yes" END AS update_on_time
FROM gas_production gp
INNER JOIN
(SELECT org_id,MAX(report_date) report_date FROM `gas_production`
GROUP BY org_id) max_info
ON max_info.org_id = gp.org_id AND 
max_info.report_date = gp.report_date
LEFT JOIN organization_info oi ON oi.id = gp.org_id 
GROUP BY gp.org_id
ORDER BY gp.created_at DESC)report_info
LEFT JOIN 
(SELECT r.id,r.name ,mhr.model_id,u.mobile,u.org_id,
CONCAT(u.first_name," ",u.last_name) responsible FROM `roles` r
LEFT JOIN model_has_roles mhr ON mhr.role_id = r.id
LEFT JOIN users u ON u.id = mhr.model_id
WHERE r.name LIKE "%Admin%" 
AND u.mobile IS NOT NULL
GROUP BY u.org_id
ORDER BY r.id)org_info
ON org_info.org_id = report_info.org_id;




