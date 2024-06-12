

SELECT tempx.* FROM (
SELECT temp.today_date, ROW_NUMBER() OVER () AS working_day_sl 
FROM (
WITH RECURSIVE qry AS(
 SELECT (CURDATE()- INTERVAL 2 DAY) AS today_date, 0 AS mday
 UNION ALL 
 SELECT (CURDATE()- INTERVAL 2 DAY) - INTERVAL mday DAY , mday+1
 FROM qry
 WHERE mday < 30
)SELECT today_date FROM qry 
WHERE mday > 1)temp 
WHERE 
temp.today_date NOT IN (SELECT holiday_date FROM govt_holiday))tempx
WHERE tempx.working_day_sl = 5;