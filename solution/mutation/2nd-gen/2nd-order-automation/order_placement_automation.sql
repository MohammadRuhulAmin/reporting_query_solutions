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

#STEP 3.b: Insert into `case_status_updates` table. Column value information is given below:

INSERT INTO `mutation_barisal`.case_status_updates
(case_status_id,status_update_date,next_status_date,user_id,users_tagged_send,
users_tagged_receive,users_tagged_view,case_order_id,is_locked,status_action_id,
status_action_type, division_id
)
VALUES(
"50 for Kanungo / 47 for Kanungo & Surveyor",#case_status_id
NOW(),#status_update_date
/*logic not added*/, #next_status_date
(SELECT id FROM rsk.users WHERE office_id = {applications.office_id} AND user_group_id = 4 AND idp_uuid IS NOT NULL), #user_id
( SELECT `users_tagged_send` FROM `case_statuses` WHERE id = {50 FOR Kanungo / 47 FOR Kanungo & Surveyor}), #users_tagged_send
(SELECT `users_tagged_receive` FROM `case_statuses` WHERE id = {50 FOR Kanungo / 47 FOR Kanungo & Surveyor}),# users_tagged_receive
(SELECT `users_tagged_view` FROM `case_statuses` WHERE id = {50 FOR Kanungo / 47 FOR Kanungo & Surveyor}) ,#users_tagged_view
${case_order.id}, #case_order_id,
1, #is_locked
${case_orders.id}, #status_action_id
"order",
1, #current_division_id
);


#STEP 3.c: Insert into `case_status_updates_ext` table

INSERT INTO mutation_barisal.case_status_updates_ext(sunani_type,division_id)
VALUES(2,1)

#STEP 3.d:Insert into `case_notices` table. Column value information is given below:

INSERT INTO `mutation_barisal`.case_notices 
(user_id,designation_id,office_id,`date`,memorandum_no,
main_notice, is_locked,is_forwarded, signature,signature_date,`status`,badi,b_badi,user_info,division_id)
VALUES(
(SELECT id FROM rsk.users WHERE office_id = {applications.office_id} AND user_group_id = 4 AND idp_uuid IS NOT NULL), #user_id
(SELECT designation_id FROM rsk.users WHERE office_id = {applications.office_id} AND user_group_id = 4 AND idp_uuid IS NOT NULL), #designation_id
${applications.office_id},#office_id
NOW(), #current date
(SELECT COUNT(id)+1 FROM `case_notices` WHERE office_id = {applications.office_id}), #memorandum_no
(SELECT `template` FROM `text_templates` WHERE id = 6; /*Template variable (dynamic value) will be replaced with*/),#main_notice
1, #is_locked
1, #is_forwarded
(SELECT signature FROM rsk.users WHERE office_id = {applications.office_id} AND user_group_id = 4 AND idp_uuid IS NOT NULL), #signature
NOW(), #signature_date
1, #status
/*badi*/,
/*bibadi*/,
/*user_info*/,
1, /*division_id*/
);
