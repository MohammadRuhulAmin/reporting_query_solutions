SELECT COUNT(gp.id) record FROM emrd_uat.gas_production gp 
LEFT JOIN emrd_uat.organization_info oi ON oi.id = gp.org_id
LEFT JOIN emrd_uat.users u ON u.org_id = gp.org_id
WHERE  oi.org_short_name = "BAPEX"
AND DATE(gp.created_at) =  DATE_SUB(CURDATE(),INTERVAL 1 DAY)
AND u.mobile IS NOT NULL;


# Summary result FOR Type:4 
SELECT 
  SUM(CASE WHEN temp.sector = 'Power' THEN temp.total_supply ELSE 0 END) AS `Power`,
  SUM(CASE WHEN temp.sector = 'Fertilizer' THEN temp.total_supply ELSE 0 END) AS Fertilizer,
  SUM(CASE WHEN temp.sector = 'Other' THEN temp.total_supply ELSE 0 END) AS Other
FROM (
  SELECT gds.sector, SUM(gd.supply) AS total_supply 
  FROM `gas_distribution` gd
  LEFT JOIN `gas_distribution_sector` gds ON gds.id = gd.sector_id
  WHERE gd.org_id = 14
  GROUP BY gds.sector
) temp;