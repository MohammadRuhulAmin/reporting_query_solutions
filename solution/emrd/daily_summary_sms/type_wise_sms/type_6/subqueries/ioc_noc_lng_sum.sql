#final sub query solution

SELECT "NOC+IOC+LNG" AS seperate_type,
#round(IFNULL(SUM(CASE WHEN gas_cat = "NOC" THEN production ELSE 0 END),0),2) as NOC,
#round(IFNULL(SUM(CASE WHEN gas_cat = "IOC" THEN production ELSE 0 END),0),2) as IOC,
ROUND(IFNULL(SUM(CASE WHEN gas_cat = "LNG" THEN production ELSE 0 END),0),2) AS LNG,
CONCAT(
ROUND(IFNULL(SUM(CASE WHEN gas_cat = "NOC" THEN production ELSE 0 END),0),2),"+",
ROUND(IFNULL(SUM(CASE WHEN gas_cat = "IOC" THEN production ELSE 0 END),0),2),"+",
ROUND(IFNULL(SUM(CASE WHEN gas_cat = "LNG" THEN production ELSE 0 END),0),2) 
) AS total_sep_sum
FROM gas_production
WHERE report_date = DATE_SUB(CURDATE(),INTERVAL 1 DAY);


#first solution
SELECT "NOC+IOC+LNG" AS separate_type,
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "NOC"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY)) AS NOC,
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "IOC"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY)) AS IOC,
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "LNG"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY)) AS LNG;


#second solution 
SELECT "NOC+IOC+LNG" AS separate_type,  CONCAT(
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "NOC"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY)), 
"+",
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "IOC"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY)),
"+",
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "LNG"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY))
) AS type_wise_gas_prod;

