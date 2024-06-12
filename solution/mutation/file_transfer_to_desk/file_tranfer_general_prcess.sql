SELECT tempx.* FROM (
SELECT temp.today_date, ROW_NUMBER() OVER (ORDER BY temp.today_date DESC) AS working_day_sl 
FROM (
SELECT CURDATE()-1 - INTERVAL daynum DAY AS today_date
FROM
(
    SELECT t*10+u daynum
    FROM
        (SELECT 0 t UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) A,
        (SELECT 0 u UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
        UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
        UNION SELECT 8 UNION SELECT 9) B
    WHERE t*10+u <= 15
) AA 
ORDER BY today_date DESC)temp 
WHERE 
temp.today_date NOT IN (SELECT holiday_date FROM govt_holiday))tempx
WHERE tempx.working_day_sl = 5;