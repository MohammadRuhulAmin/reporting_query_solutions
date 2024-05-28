SELECT temp2.org_short_name,temp2.field_name,
CASE WHEN temp1.max_report_date = DATE_SUB(CURDATE(),INTERVAL 1 DAY) THEN "Updated" ELSE "Not Updated" END AS STATUS,
CAST(temp1.max_report_date AS CHAR) last_update, temp_name.full_name responsible
FROM(SELECT gp.org_id,gp.gas_field_id,MAX(gp.report_date) max_report_date FROM gas_production gp
WHERE gp.org_id = 9
GROUP BY gp.gas_field_id
ORDER BY gp.gas_field_id)temp1
LEFT JOIN
(SELECT oi.org_short_name,gf.field_name,oi.id org_id,gf.id gas_field_id FROM `gas_production` gp
LEFT JOIN organization_info oi ON oi.id = gp.org_id
LEFT JOIN gas_field gf ON gf.id = gp.gas_field_id
WHERE gp.org_id = 9)temp2 ON temp2.org_id = temp1.org_id AND temp2.gas_field_id = temp1.gas_field_id


LEFT JOIN (SELECT temp3.full_name,temp3.role_id,r.name,temp3.org_id FROM(SELECT u.org_id,CONCAT(u.first_name," ",u.last_name) full_name, 
mhr.`role_id` FROM users u
LEFT JOIN model_has_roles mhr ON mhr.model_id = u.id
WHERE u.org_id = 9)temp3
LEFT JOIN 
roles r ON r.id = temp3.role_id 
WHERE r.name = "Private Data Manager"
LIMIT 1)temp_name ON temp_name.org_id = temp2.org_id

WHERE temp2.org_short_name IS NOT NULL
GROUP BY temp1.org_id,temp1.gas_field_id,temp1.max_report_date;





