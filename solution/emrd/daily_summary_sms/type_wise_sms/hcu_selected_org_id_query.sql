SELECT(SELECT CONCAT(SUM(production), " MMCFD") gas_production FROM `gas_production` 
WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "gas") AS gas_prod, 
#(SELECT SUM(production) gas_condensate FROM `gas_production` 
#WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "condensate") as condensate_prod,
(SELECT CONCAT(SUM(opening_stock), " MT") total_opening_stock FROM oil_stock WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY)) AS total_opening_stock,
(SELECT CONCAT(quantity_mt, " MT") FROM coal_daily_production WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY)) AS coal_production,
(SELECT CONCAT(SUM(sale), " MT") oil_sale FROM oil_sale WHERE report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)) AS oil_sale,
(SELECT CONCAT(SUM(production), " MMCFD")lng_gas_production FROM gas_production WHERE gas_cat = "LNG" AND production_type = "gas" 
AND report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)) AS lng_gas_production,
(SELECT GROUP_CONCAT(DISTINCT temp.org_short_name) FROM 
(SELECT DISTINCT oi.id, oi.org_short_name,gp.org_id FROM organization_info oi
LEFT JOIN gas_production gp ON gp.org_id = oi.id
AND gp.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (1,9,10,11)
UNION SELECT oi.id, oi.org_short_name,cdp.org_id FROM organization_info oi 
LEFT JOIN coal_daily_production cdp ON cdp.org_id = oi.id 
AND cdp.report_date =  DATE_SUB(CURDATE(), INTERVAL 1 DAY) 
WHERE oi.id = 20 
UNION SELECT DISTINCT oi.id, oi.org_short_name,ost.org_id FROM organization_info oi
LEFT JOIN oil_stock ost ON ost.org_id = oi.id
AND ost.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (23, 24, 25, 28)
UNION SELECT DISTINCT oi.id, oi.org_short_name,osa.org_id FROM organization_info oi
LEFT JOIN oil_sale osa ON osa.org_id = oi.id
AND osa.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (22, 23, 24, 25, 26, 27, 28))temp
WHERE temp.org_id IS NULL) AS dt_nt_org_list,
(SELECT CONCAT(DAY(date_field),
CASE 
WHEN DAY(date_field) IN (1, 21, 31) THEN 'st' WHEN DAY(date_field) IN (2, 22) THEN 'nd'
WHEN DAY(date_field) IN (3, 23) THEN 'rd' ELSE 'th'
END,' ', DATE_FORMAT(date_field, '%M, %Y')) AS formatted_date
FROM (SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) AS date_field) AS temp_date) yesterday_date




current organization : 
SELECT id,org_short_name FROM organization_info WHERE id 
IN(1,9,10,11,19,23,24,25,28,22,23,24,25,26,27,28,20)

