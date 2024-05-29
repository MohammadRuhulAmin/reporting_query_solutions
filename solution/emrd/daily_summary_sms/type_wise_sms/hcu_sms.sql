#gas production: 
SELECT 
(SELECT SUM(production) gas_production FROM `gas_production` 
WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "gas"
) AS gas_prod, 
(SELECT SUM(production) gas_condensate FROM `gas_production` 
WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "condensate") condensate_prod