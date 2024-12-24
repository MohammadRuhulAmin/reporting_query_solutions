#step1:(Getting the 4th working date)
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

#step2:(Get the application id)
SELECT DISTINCT a.`id`
FROM mutation_dhaka.`applications` a
LEFT JOIN mutation_dhaka.`case_proposals` cp ON cp.`application_id` = a.`id`
WHERE a.`case_main_status_id` = 3 
AND (a.`users_tagged_receive` = '["5"]' OR a.`users_tagged_receive` = '["9"]')
AND cp.`id` IS NULL
AND a.`accepted_at` < '2024-06-06'
ORDER BY a.`id`;


#step3: (update the tag)
UPDATE  mutation_dhaka.`applications`  
SET  `users_tagged_receive`='["6"]'  ,
users_tag_send =`users_tagged_receive` 
WHERE id IN();


