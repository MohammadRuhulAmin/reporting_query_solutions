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


#modified query:
SELECT(SELECT SUM(production) gas_production FROM `gas_production` 
WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "gas") AS gas_prod, 
#(SELECT SUM(production) gas_condensate FROM `gas_production` 
#WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "condensate") as condensate_prod,
(SELECT SUM(opening_stock) total_opening_stock FROM oil_stock WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY)) AS total_opening_stock,
(SELECT quantity_mt FROM coal_daily_production WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY)) AS coal_production,
(SELECT SUM(sale) oil_sale FROM oil_sale WHERE report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)) AS oil_sale,
(SELECT SUM(production)lng_gas_production FROM gas_production WHERE gas_cat = "LNG" AND production_type = "gas" 
AND report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)) AS lng_gas_production


#sub query 
SELECT oi.id, oi.org_short_name,cdp.org_id FROM organization_info oi 
LEFT JOIN coal_daily_production cdp ON cdp.org_id = oi.id 
AND cdp.report_date =  DATE_SUB(CURDATE(), INTERVAL 1 DAY) 
WHERE oi.id = 20 

SELECT DISTINCT oi.id, oi.org_short_name,gp.org_id FROM organization_info oi
LEFT JOIN gas_production gp ON gp.org_id = oi.id
AND gp.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (1,9,10,11)
UNION
SELECT oi.id, oi.org_short_name,cdp.org_id FROM organization_info oi 
LEFT JOIN coal_daily_production cdp ON cdp.org_id = oi.id 
AND cdp.report_date =  DATE_SUB(CURDATE(), INTERVAL 1 DAY) 
WHERE oi.id = 20 




