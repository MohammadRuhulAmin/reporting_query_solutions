SELECT SUM(production) AS production_sum,COUNT(id) AS total ,"production" production_type
FROM `gas_production` 
WHERE org_id = 9 AND production_type = "gas" AND 
created_at  BETWEEN CONCAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY)," 08:00:00") 
AND CONCAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY)," 20:00:00")
UNION SELECT SUM(production) AS production_sum,COUNT(id) AS elem ,"condensate" production_type
FROM `gas_production` 
WHERE org_id = 9 AND production_type = "condensate" AND 
created_at BETWEEN CONCAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY)," 08:00:00") 
AND CONCAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY)," 20:00:00");
