SELECT "NOC+IOC+LNG" AS separate_type,
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "NOC"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY)) AS NOC,
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "IOC"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY)) AS IOC,
(SELECT IFNULL(SUM(production),0) FROM gas_production WHERE gas_cat = "LNG"
AND report_date = DATE_SUB(CURDATE() , INTERVAL 1 DAY)) AS LNG