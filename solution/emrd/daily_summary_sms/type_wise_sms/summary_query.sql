# checking and counting data by report_date
SELECT SUM(production) AS production_sum ,"production" production_type
FROM `gas_production` 
WHERE org_id = 9 AND production_type = "gas" AND 
report_date  = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
UNION SELECT SUM(production) AS production_sum ,"condensate" production_type
FROM `gas_production` 
WHERE org_id = 9 AND production_type = "condensate" AND 
report_date  = DATE_SUB(CURDATE(), INTERVAL 1 DAY)

# checking the disting gas fields
SELECT  DISTINCT gas_field_id
FROM `gas_production` 
WHERE org_id = 9 AND production_type = "gas" AND 
report_date  = DATE_SUB(CURDATE(), INTERVAL 1 DAY);     


# checking and counting data by 
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
