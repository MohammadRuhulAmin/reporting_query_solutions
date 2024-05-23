SELECT DATE_SUB(CURDATE(), INTERVAL 1 DAY) prev_date,
sdp.ms+sdp.kerosene+sdp.diesel+sdp.octane+sdp.lpg+sdp.petrol petroleum 
FROM
sgfl_daily_production sdp
WHERE sdp.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY);