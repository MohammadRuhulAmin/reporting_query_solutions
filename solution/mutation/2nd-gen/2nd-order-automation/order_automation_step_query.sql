#STEP 1:
SELECT * FROM `mutation_chottogram`.applications app WHERE 
app.form_type = 5 AND case_main_status_id IN(6,24) AND JSON_CONTAINS(app.users_tagged_receive,'4');

#STEP 2: 
SELECT *,TIMESTAMPDIFF(HOUR, NOW(),csu.next_status_date) AS hours_difference 
FROM mutation_chottogram.case_status_updates csu 
WHERE csu.application_id = 7931963 #and csu.case_status_id in (6,24) 
#and TIMESTAMPDIFF(HOUR,NOW(), csu.next_status_date ) <= 0
ORDER BY csu.id DESC LIMIT 1;

#STEP 3:
