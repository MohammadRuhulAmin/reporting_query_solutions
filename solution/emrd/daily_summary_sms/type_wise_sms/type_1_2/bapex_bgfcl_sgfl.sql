SELECT
(SELECT SUM(production) production 
FROM `gas_production` 
WHERE org_id = ${org_id} AND production_type = "gas" AND 
report_date  = DATE_SUB(CURDATE(), INTERVAL 1 DAY))total_production,
(SELECT SUM(production) condensate 
FROM `gas_production` 
WHERE org_id = ${org_id} AND production_type = "condensate" AND 
report_date  = DATE_SUB(CURDATE(), INTERVAL 1 DAY))total_condensate,
(SELECT  COUNT(DISTINCT gas_field_id) total_gas_fields
FROM `gas_production` 
WHERE org_id = ${org_id} AND production_type = "gas" AND 
report_date  = DATE_SUB(CURDATE(), INTERVAL 1 DAY))total_gas_field,
(SELECT sdp.ms+sdp.kerosene+sdp.diesel+sdp.octane+sdp.lpg+sdp.petrol petroleum 
FROM
sgfl_daily_production sdp
WHERE sdp.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY))total_petrolium_sgfl,
(SELECT DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 1 DAY), '%d/%m/%Y')yesterday_date)yesterday_date;