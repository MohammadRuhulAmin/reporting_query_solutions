SELECT 
  SUM(CASE WHEN temp.sector = 'Power' THEN temp.total_supply ELSE 0 END) AS `Power`,
  SUM(CASE WHEN temp.sector = 'Fertilizer' THEN temp.total_supply ELSE 0 END) AS Fertilizer,
  SUM(CASE WHEN temp.sector = 'Other' THEN temp.total_supply ELSE 0 END) AS Other,
  DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '%d/%m/%Y') AS yesterday
FROM (
  SELECT gds.sector, SUM(gd.supply) AS total_supply 
  FROM `gas_distribution` gd
  LEFT JOIN `gas_distribution_sector` gds ON gds.id = gd.sector_id
  WHERE gd.org_id = ${org_id} AND gd.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
  GROUP BY gds.sector
) temp;