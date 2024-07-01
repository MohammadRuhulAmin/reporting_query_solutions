#using Limit Offset Query supported by mysql v <= 5

## To Get the previous nth working date 

SELECT CAST(temp.previous_date AS CHAR) last_nth_working_date
FROM (SELECT CURDATE() - INTERVAL seq_table.seq DAY AS previous_date
FROM (
  SELECT 0 AS seq UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
  UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
  UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
  UNION ALL SELECT 15 UNION ALL SELECT 16
) AS seq_table
ORDER BY previous_date DESC)temp 
WHERE temp.previous_date 
NOT IN (SELECT holiday_date FROM `mutation_ext`.govt_holiday)
LIMIT 1 OFFSET 4;



#using ROW_NUMBER() OVER() Function 
#Query supported by mysql v>=8
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