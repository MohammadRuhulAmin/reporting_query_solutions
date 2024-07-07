SELECT oi.org_short_name,gp.org_id,MAX(gp.report_date) last_update
FROM gas_production gp
LEFT JOIN organization_info oi ON oi.id = gp.org_id
GROUP BY gp.org_id ORDER BY gp.org_id;



SELECT report_info.org_short_name,report_info.last_update,user_info.name Responsible,
user_info.mobile contact
FROM(SELECT oi.id,oi.org_short_name,gp.org_id,MAX(gp.report_date) last_update
FROM gas_production gp
LEFT JOIN organization_info oi ON oi.id = gp.org_id
GROUP BY gp.org_id ORDER BY gp.org_id)report_info
LEFT JOIN 
(SELECT r.id,r.name ,mhr.model_id,u.mobile,u.org_id,
CONCAT(u.first_name," ",u.last_name) Responsible FROM `roles` r
LEFT JOIN model_has_roles mhr ON mhr.role_id = r.id
LEFT JOIN users u ON u.id = mhr.model_id
WHERE r.name LIKE "%Admin%" 
AND u.mobile IS NOT NULL
GROUP BY u.org_id
ORDER BY r.id)user_info ON user_info.org_id = report_info.id;


SELECT gp.org_id,gp.report_date,created_at FROM
gas_production gp
INNER JOIN
(SELECT org_id,MAX(report_date) report_date FROM `gas_production`
GROUP BY org_id) max_info
ON max_info.org_id = gp.org_id AND 
max_info.report_date = gp.report_date
GROUP BY gp.org_id
ORDER BY created_at DESC