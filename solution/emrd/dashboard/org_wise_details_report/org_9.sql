SELECT CONCAT(DAY(gp.report_date),CASE WHEN DAY(gp.report_date)IN (1,21,31) THEN 'st'
WHEN DAY(gp.report_date) IN (2,22) THEN 'nd' WHEN DAY(gp.report_date) IN(3,23) THEN 'rd'
ELSE 'th' END, ' ', DATE_FORMAT(gp.report_date,'%M, %Y'))AS report_date,gp.org_id,
CASE 
WHEN (DATE(gp.created_at) != gp.report_date AND gp.created_at - INTERVAL 1 DAY >  CONCAT(gp.report_date," 17:00:00")) THEN "No"
WHEN (DATE(gp.created_at)  = gp.report_date AND gp.created_at  >  CONCAT(gp.report_date," 17:00:00")) THEN "No"
ELSE "Yes" END AS updated_on_time, DATE_FORMAT(CONVERT_TZ(gp.created_at, '+00:00', '-12:00'), '%Y-%m-%d %h:%i:%s') report_submit_time,
gp.created_by , CONCAT(IFNULL(u.first_name,""),IFNULL(u.last_name,"")) updated_by,
u.mobile
FROM gas_production gp 
LEFT JOIN users u ON u.id = gp.created_by 
WHERE gp.org_id = 9
GROUP BY gp.report_date
ORDER BY gp.report_date DESC;