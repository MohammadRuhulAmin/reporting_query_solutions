#step 1: 
SELECT(SELECT VALUE  FROM `mutation_ext`.`configuration`
WHERE caption =  "SEND_TO_ULAO_AFTER_DAY") AS nth_working_date,
(SELECT VALUE  FROM `mutation_ext`.`configuration`
WHERE caption =  "ORDER_ACL_DELAY") switch_to_execute_process;

#step 2:
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
NOT IN (SELECT holiday_date FROM `mutation_ext`.govt_holiday)
LIMIT 1 OFFSET ${nth_working_date};


#step 3:
#step2:(Get the application id)
SELECT DISTINCT a.`id`
FROM `applications` a
LEFT JOIN orders o ON o.`application_id` = a.`id`
WHERE a.`case_main_status_id` = 2
AND a.`users_tagged_receive` = '["4"]' 
AND o.`id` IS NULL
AND a.`accepted_at` < {$temp.draft_mig_date}
ORDER BY a.`id`;

#step 4:
# getting data from api 
INSERT INTO `mutation_dhaka`.`case_orders` (
  
  `application_id`,
  `user_id`,
  `designation_id`,
  `office_id`,
  `case_status_update_id`,
  `order_no`,
  `order_date`,
  `order_statement`,
  `is_forwarded`,
  `signature`,
  `signature_date`,
  `user_info`
);

#step 5:

INSERT INTO `case_status_updates` (
  `application_id`,2897271
  `case_status_id`, {hardcoded 3}
  `next_status_date` 2024-07-08T10:00:00.000Z, {api response theke ashbe}
  `user_id`, 21152 {from api response}
  `users_tagged_send`, {hardcoded ["4"]} 
  `users_tagged_receive` { hardcoded ["5"]} ,
  `users_tagged_view` {hardcoded ["3","4"]},
  `case_order_id`, {case_orders table e step 3 te jeta insert hoyeche tar id ta }
  `is_locked`, {hardcoded 1}
  `status_action_id`, {case_order_id tai }{case_orders table e step 3 te jeta insert hoyeche tar id ta }
  `status_action_type`  {hardcoded "order_acl_delay"}

);

#step 6:
#step5: (update the tag)
UPDATE  `applications`  
SET  
`users_tagged_receive`='["5"]'  ,
users_tagged_send =`users_tagged_receive` ,
users_tagged_view = ["4"],
case_main_status_id = 3
WHERE id = '2897271';
