 SELECT(SELECT SUM(production) gas_production FROM `gas_production` 
WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "gas") AS gas_prod, 
#(SELECT SUM(production) gas_condensate FROM `gas_production` 
#WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "condensate") as condensate_prod,
(SELECT SUM(opening_stock) total_opening_stock FROM oil_stock WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY)) AS total_opening_stock,
(SELECT quantity_mt FROM coal_daily_production WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY)) AS coal_production,
(SELECT GROUP_CONCAT(temp2.org_short_name) FROM
(SELECT org_short_name FROM organization_info 
WHERE id NOT IN(SELECT GROUP_CONCAT(temp.org_id ORDER BY temp.org_id) AS given_org_id
FROM
(SELECT DISTINCT org_id FROM gas_production 
WHERE report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
UNION
SELECT DISTINCT org_id FROM gas_distribution 
WHERE report_date = DATE_SUB(CURDATE(),INTERVAL 1 DAY)
UNION
SELECT DISTINCT org_id FROM gas_distribution gd WHERE gd.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY))temp))temp2)data_missing_org_name



