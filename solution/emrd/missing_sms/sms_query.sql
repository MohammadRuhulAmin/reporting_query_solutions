SELECT COUNT(gp.id) record FROM emrd_uat.gas_production gp 
LEFT JOIN emrd_uat.organization_info oi ON oi.id = gp.org_id
LEFT JOIN emrd_uat.users u ON u.org_id = gp.org_id
WHERE  oi.org_short_name = "BAPEX"
AND DATE(gp.created_at) =  DATE_SUB(CURDATE(),INTERVAL 1 DAY)
AND u.mobile IS NOT NULL;