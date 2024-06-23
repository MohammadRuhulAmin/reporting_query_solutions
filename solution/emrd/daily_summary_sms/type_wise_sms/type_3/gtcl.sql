SELECT 
    (SELECT inflow FROM `gas_transmission` 
     WHERE org_id = 12 AND report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)) AS inflow,
    (SELECT outflow FROM `gas_transmission` 
     WHERE org_id = 12 AND report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)) AS outflow,
    (SELECT DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 1 DAY), '%d/%m/%Y')) AS yesterday_date;