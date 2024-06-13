#step1:(Getting the 4th working date)
SELECT temp.draft_mig_date
FROM (SELECT CURDATE() - 1 - INTERVAL daynum DAY AS draft_mig_date
FROM (SELECT sl_first * 10+ sl_second daynum
FROM (SELECT 0 sl_first UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) temp_x,
(SELECT 0 sl_second UNION SELECT 1 UNION SELECT 2 UNION SELECT 3
UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
UNION SELECT 8 UNION SELECT 9) temp_y
WHERE sl_first*10+sl_second <= 15) temp_z
ORDER BY draft_mig_date DESC)temp 
WHERE temp.draft_mig_date 
NOT IN (SELECT holiday_date FROM govt_holiday)
LIMIT 1 OFFSET 4;

#step2:(Get the application id)
SELECT DISTINCT a.`id`
FROM mutation_dhaka.`applications` a
LEFT JOIN mutation_dhaka.`case_proposals` cp ON cp.`application_id` = a.`id`
WHERE a.`case_main_status_id` = 3 
AND (a.`users_tagged_receive` = '["5"]' OR a.`users_tagged_receive` = '["9"]')
AND cp.`id` IS NULL
AND a.`accepted_at` < '2024-06-06'
ORDER BY a.`id` DESC
LIMIT 1;


#step3: (update the tag)
UPDATE  mutation_dhaka.`applications`  
SET  `users_tagged_receive`='["6"]'  ,
users_tag_send =`users_tagged_receive` 
WHERE id IN();


