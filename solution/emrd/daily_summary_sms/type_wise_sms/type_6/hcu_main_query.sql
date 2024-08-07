SELECT(SELECT CONCAT(ROUND(SUM(production)), " MMCFD") gas_production FROM `gas_production` 
WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "gas") AS gas_prod, 
(SELECT ROUND(SUM(production)) gas_condensate FROM `gas_production` 
WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY) AND production_type = "condensate") AS condensate_production,
(SELECT CONCAT(ROUND(SUM(present_stock)), " MT") total_opening_stock FROM oil_stock WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY)) AS oil_stock,
(SELECT CONCAT(quantity_mt, " MT") FROM coal_daily_production WHERE report_date = DATE_SUB(CURDATE(),  INTERVAL 1 DAY)) AS coal_production,
(SELECT CONCAT(ROUND(SUM(sale)), " MT") oil_sale FROM oil_sale WHERE report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)) AS oil_sale,
(SELECT CONCAT(SUM(production), " MMCFD")lng_gas_production FROM gas_production WHERE gas_cat = "LNG" AND production_type = "gas" 
AND report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)) AS lng_gas_production,
(SELECT 
CONCAT(
FLOOR(IFNULL(SUM(CASE WHEN gas_cat = "NOC" AND production_type = "gas" THEN production ELSE 0 END),0))," + ",
FLOOR(IFNULL(SUM(CASE WHEN gas_cat = "IOC" AND production_type = "gas" THEN production ELSE 0 END),0))," + ",
FLOOR(IFNULL(SUM(CASE WHEN gas_cat = "LNG" AND production_type = "gas" THEN production ELSE 0 END),0)) 
) AS total_sep_sum
FROM gas_production
WHERE report_date = DATE_SUB(CURDATE(),INTERVAL 1 DAY))AS "NOC_IOC_LNG",
(SELECT CASE WHEN LENGTH(GROUP_CONCAT(DISTINCT temp.org_short_name))= 0 THEN "N/A"
ELSE GROUP_CONCAT(DISTINCT temp.org_short_name) END AS temp_list FROM 
(SELECT DISTINCT oi.id, oi.org_short_name,gp.org_id FROM organization_info oi
LEFT JOIN gas_production gp ON gp.org_id = oi.id
AND gp.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (9,10,11)
UNION 

SELECT 19 AS id,"RPGCL" AS org_short_name,
CASE WHEN COUNT(*) = 2 AND SUM(temp.org_id IS NULL) = 2 THEN NULL ELSE 19 
END AS org_id FROM 
(SELECT DISTINCT oi.id, oi.org_short_name, gp.org_id 
FROM organization_info oi
LEFT JOIN gas_production gp ON gp.org_id = oi.id 
AND gas_cat = "LNG" 
AND gp.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (31, 32)) AS temp
WHERE temp.org_id IS NULL 

UNION

SELECT 1 AS id,"Petrobangla" AS org_short_name,
CASE WHEN COUNT(*) = 2 AND SUM(temp.org_id IS NULL) = 2 THEN NULL ELSE 1 
END AS org_id FROM 
(SELECT DISTINCT oi.id, oi.org_short_name, gp.org_id 
FROM organization_info oi
LEFT JOIN gas_production gp ON gp.org_id = oi.id 
AND gas_cat = "IOC" 
AND gp.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (29, 30)) AS temp
WHERE temp.org_id IS NULL 


UNION
SELECT oi.id, oi.org_short_name,cdp.org_id FROM organization_info oi 
LEFT JOIN coal_daily_production cdp ON cdp.org_id = oi.id 
AND cdp.report_date =  DATE_SUB(CURDATE(), INTERVAL 1 DAY) 
WHERE oi.id = 20 
UNION 

SELECT stock_sale.id,stock_sale.stock_s_nm org_short_name,
CASE WHEN stock_sale.stock_org_id IS NULL AND stock_sale.sale_org_id IS NULL THEN NULL
ELSE stock_sale.stock_org_id END AS org_id FROM
(SELECT oil_stock_family.*,oil_sale_family.* FROM
(SELECT DISTINCT oi.id , oi.org_short_name stock_s_nm,ost.org_id  stock_org_id FROM organization_info oi
LEFT JOIN oil_stock ost ON ost.org_id = oi.id
AND ost.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (22,23, 24, 25,26,27, 28))oil_stock_family
LEFT JOIN 
(SELECT DISTINCT  oi.org_short_name sale_s_nm ,osa.org_id sale_org_id FROM organization_info oi
LEFT JOIN oil_sale osa ON osa.org_id = oi.id
AND osa.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (22, 23, 24, 25, 26, 27, 28))oil_sale_family
ON oil_stock_family.stock_s_nm = oil_sale_family.sale_s_nm)stock_sale

UNION
SELECT DISTINCT oi.id,oi.org_short_name , gt.org_id FROM  organization_info oi
LEFT JOIN gas_transmission gt ON gt.org_id = oi.id
AND gt.report_date = DATE_SUB(CURDATE(),INTERVAL 1 DAY)
WHERE oi.id = 12 
UNION 
SELECT DISTINCT oi.id,oi.org_short_name,gd.org_id FROM organization_info oi
LEFT JOIN gas_distribution gd ON gd.org_id = oi.id
AND gd.report_date =  DATE_SUB(CURDATE(),INTERVAL 1 DAY)
WHERE oi.id IN(14,16,17)
UNION 
SELECT temp_inflow_outflow.id,temp_inflow_outflow.org_short_name,temp_inflow_outflow.org_id
 FROM (SELECT DISTINCT oi.id,oi.org_short_name,gt.org_id FROM organization_info oi
LEFT JOIN gas_transmission gt ON gt.org_id = oi.id
AND gt.report_date =  DATE_SUB(CURDATE(),INTERVAL 1 DAY)
WHERE oi.id IN(13,15,18))temp_inflow_outflow
LEFT JOIN 
(SELECT DISTINCT oi.id,oi.org_short_name,gp.org_id FROM organization_info oi
LEFT JOIN gas_production gp ON gp.org_id = oi.id
AND gp.report_date =  DATE_SUB(CURDATE(),INTERVAL 1 DAY)
WHERE oi.id IN(13,15,18) )temp_power_other
ON  temp_inflow_outflow.id = temp_power_other.id
AND (temp_inflow_outflow.org_id IS NULL AND temp_power_other.org_id IS NULL)
)temp
WHERE temp.org_id IS NULL) AS dt_nt_org_list,
(SELECT CONCAT(DAY(date_field),
CASE 
WHEN DAY(date_field) IN (1, 21, 31) THEN 'st' WHEN DAY(date_field) IN (2, 22) THEN 'nd'
WHEN DAY(date_field) IN (3, 23) THEN 'rd' ELSE 'th'
END,' ', DATE_FORMAT(date_field, '%M, %Y')) AS formatted_date
FROM (SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) AS date_field) AS temp_date) yesterday_date,
(SELECT CONCAT(ROUND(SUM(production)),' MT ', ' (', (DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 MONTH),'%M')) ,')') 
FROM lease_monthly_production ) AS hard_rock_production;