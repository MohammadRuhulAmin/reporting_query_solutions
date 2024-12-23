#STEP 1:Identify the applications that need to process for the second order

#STEP 1.a: Select the `applications` that has:
SELECT * FROM `mutation_chottogram`.applications app WHERE 
app.form_type = 5 AND case_main_status_id IN(6,24) AND JSON_CONTAINS(app.users_tagged_receive,'4');

#STEP 1.b:Search for the applications that has the latest row in `case_status_updates` table with
SELECT *,TIMESTAMPDIFF(HOUR, NOW(),csu.next_status_date) AS hours_difference 
FROM mutation_chottogram.case_status_updates csu 
WHERE csu.application_id = 7931963 #and csu.case_status_id in (6,24) 
#and TIMESTAMPDIFF(HOUR,NOW(), csu.next_status_date ) <= 0
ORDER BY csu.id DESC LIMIT 1;


#STEP 2: Identify if the order should be sent to Kanungo or both Kanungo and Surveyor
#STEP 2.a: In `ulao_investigation_report_status` table if monjur_status = 1 or namonjur_status = 1 then application will be sent only to Kanungo

SELECT * FROM ulao_investigation_report_status uirs WHERE 
uirs.application_id = 7931963
AND (uirs.monjur_status = 1 OR uirs.namonjur_status = 1)

#STEP 2.b: In `ulao_investigation_report_status` table if monjur_status = 1 and area_select_servyor_status = 1 then application will be sent to both Kanungo and surveyor.

SELECT * FROM ulao_investigation_report_status uirs WHERE 
uirs.area_select_servyor_status = 1 AND uirs.monjur_status = 1;


#STEP 3:To place an order, data need to be saved/updated in

#STEP 3.a: Insert into `case_orders` table. Column value information is given below:

INSERT INTO `mutation_barisal`.case_orders
(user_id,designation_id,office_id,case_status_update_id,order_no,order_date,order_statement,is_forwarded,signature,signature_date,user_info,division_id)
VALUES(
(SELECT id FROM rsk.users WHERE office_id = ${applications.office_id}),#user_id
(SELECT designation_id FROM rsk.users WHERE office_id = {applications.office_id} AND user_group_id = 4 AND idp_uuid IS NOT NULL),#designation_id
${applications.office_id}, #office_id
${case_status_updates.id}, #case_status_update_id
2, #order_no
NOW(), #order_date
(SELECT `template` FROM `text_templates` WHERE id = (SELECT text_template_id FROM `case_statuses` WHERE id = {50 FOR Kanungo / 47 FOR Kanungo & Surveyor})), #order_statement
1, #is_forwarded
( SELECT signature FROM rsk.users WHERE office_id = {applications.office_id} AND user_group_id = 4 AND idp_uuid IS NOT NULL), #signature
NOW(), #signature_date
(/*probably apicall*/), #user_info
1 /*current_division_id*/
);
