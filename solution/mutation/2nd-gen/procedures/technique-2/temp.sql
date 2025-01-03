DELIMITER // 

CREATE PROCEDURE second_order_auto_placement_test()
BEGIN
    DECLARE applications_application_id_list JSON;
    DECLARE p_application_id INT;
    DECLARE p_office_id INT;
    DECLARE p_status INT;
    DECLARE p_union_office_name VARCHAR(255) DEFAULT "";
    #DECLARE res text default "";
    DECLARE error_message TEXT;
    DECLARE array_length INT;
    DECLARE counter1 INT DEFAULT 0;
    DECLARE nth_working_date DATE;
    DECLARE is_only_kanungo TINYINT DEFAULT 0;
    DECLARE is_both_kanungo_surveyor TINYINT DEFAULT 0;
    DECLARE ks_id INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        ROLLBACK;
        INSERT INTO second_order_error_log(application_id,error_status) VALUES(p_application_id,error_message);
        SELECT error_message AS `error`, p_application_id AS `application_id`;
    END;
    SET sql_mode = '';
    SET autocommit = 0;
    START TRANSACTION;
    #step - 1.a,1.b
    INSERT INTO second_order_automation_process (application_id,`status`)
    SELECT application_id,1 AS `status` #*,TIMESTAMPDIFF(HOUR, NOW(),csu.next_status_date) AS hours_difference 
    #INTO p_application_id,p_status 
    FROM case_status_updates csu 
    WHERE csu.application_id IN(SELECT id
    FROM applications app WHERE app.form_type = 5 AND app.case_main_status_id IN(6,24)
    AND JSON_CONTAINS(app.users_tagged_receive, '["4"]'))
    AND csu.case_status_id IN (6,24) 
    AND TIMESTAMPDIFF(HOUR,NOW(), csu.next_status_date ) <= 0
    GROUP BY csu.application_id
    ORDER BY csu.id DESC
    ON DUPLICATE KEY UPDATE `status` = VALUES(`status`);
    
     
    #step - 3.a
    SELECT JSON_ARRAYAGG(soap.application_id) AS process_application_list INTO applications_application_id_list
    FROM second_order_automation_process soap WHERE soap.status = 1;
    SET array_length = JSON_LENGTH(applications_application_id_list);
    
    WHILE counter1 < array_length DO
      SET p_application_id = JSON_UNQUOTE(JSON_EXTRACT(applications_application_id_list, CONCAT('$[', counter1, ']')));
      #step - 2.a, 2.b      
      SET is_only_kanungo = 0;
      SET is_both_kanungo_surveyor = 0;
      SET ks_id = 0;
      SELECT IF( COUNT(id)>0,1,0) INTO is_only_kanungo  FROM ulao_investigation_report_status
      WHERE application_id = p_application_id AND (monjur_status  = 1 OR namonjur_status = 1);
      
      SELECT IF(COUNT(id)>0,1,0) INTO is_both_kanungo_surveyor FROM ulao_investigation_report_status
      WHERE application_id = p_application_id AND (monjur_status = 1 AND area_select_servyor_status = 1);
      
       IF is_only_kanungo = 0 AND is_both_kanungo_surveyor = 1 THEN SET ks_id = 47;
       ELSEIF is_only_kanungo = 1 AND is_both_kanungo_surveyor = 0 THEN SET ks_id = 50; 
       ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Invalid input combination for is_only_kanungo and is_both_kanungo_surveyor.';
       END IF; 
      
      INSERT INTO case_orders (user_id,designation_id,office_id,case_status_update_id,order_no,order_date,order_statement,is_forwarded,signature,signature_date,user_info,division_id)
      VALUES(
	(SELECT id FROM rsk.users WHERE office_id = (SELECT office_id FROM applications WHERE id = p_application_id)),
	(SELECT designation_id FROM rsk.users WHERE office_id = (SELECT office_id FROM applications WHERE id = p_application_id) AND user_group_id = 4 AND idp_uuid IS NOT NULL),
	(SELECT office_id FROM applications WHERE id = p_application_id),
	(SELECT id FROM case_status_updates WHERE application_id = p_application_id DESC LIMIT 1),
	2,
	DATE_FORMAT(CURDATE(), '%Y-%m-%d'),
	
	/*Get Nth working date*/	
  SELECT tempx.today_date INTO nth_working_date FROM (
	SELECT temp.today_date, ROW_NUMBER() OVER () AS working_day_sl 
	FROM (
	WITH RECURSIVE next_days AS (
	    SELECT CURDATE() AS today_date, 0 AS day_offset
	    UNION ALL
	    SELECT DATE_ADD(today_date, INTERVAL 1 DAY), day_offset + 1
	    FROM next_days
	    WHERE day_offset < 29
	)
	SELECT today_date 
	FROM next_days)temp 
	WHERE 
	temp.today_date NOT IN (SELECT holiday_date FROM govt_holiday WHERE is_active = 1))tempx
	WHERE tempx.working_day_sl = 5;
	
	SELECT union_office_name INTO p_union_office_name FROM applications a LEFT JOIN 
        office_wise_mouja_assign owma ON owma.mouja_id = a.mouja_id WHERE a.id = p_application_id;
	
	
	(SELECT REPLACE(REPLACE(template,'{union}',p_union_office_name),'{next_status_date}',nth_working_date) FROM `text_templates` WHERE id = (SELECT text_template_id FROM `case_statuses` WHERE id = ks_id)),
	1,
	( SELECT signature FROM rsk.users WHERE office_id = (SELECT office_id FROM applications WHERE id = p_application_id) AND user_group_id = 4 AND idp_uuid IS NOT NULL),
	NOW(),
	(SELECT 
  CONCAT(
    "{",
    '"user_name_bn":"',  IFNULL(u.name_bn, ""), '",',
    '"designation_bn":"',IFNULL(jd.name_bn, ""), '",',
    '"office_name_bn":"',IFNULL((SELECT title_bn FROM rsk.jomi_offices WHERE id = (SELECT office_id FROM mutation_dhaka.applications WHERE id = 2833)),""), '"',
    '"district_name_bn":"',IFNULL(
    (SELECT jd.name_bn FROM rsk.jomi_offices jo
     LEFT JOIN rsk.jomi_districts jd ON jd.division_id = jo.division_id AND jd.id = jo.district_id
     WHERE jo.id = (SELECT office_id FROM mutation_dhaka.applications  WHERE id = 2833)
     ),""),'",',
    '"upazila_name_bn":"',IFNULL((SELECT ju.name_bd FROM rsk.jomi_offices jo
	LEFT JOIN rsk.jomi_upazilas ju ON ju.division_id = jo.division_id 
	AND ju.division_id = jo.division_id AND ju.district_id = jo.district_id 
	AND ju.upazila_id = jo.upazila_id 
	WHERE jo.id = (SELECT office_id FROM mutation_dhaka.applications  WHERE id = 11044388)),""),'",',
	    "}"
	  ) AS user_info_bn
	FROM rsk.users u
	LEFT JOIN rsk.jomi_designations jd 
	  ON jd.id = u.designation_id
	WHERE u.user_group_id = 4 
	  AND u.office_id = 5 
	  AND u.idp_uuid IS NOT NULL 
	  AND u.status = 1)/*user info*/,
	  1
    )

    #step 3.b 
    
    /*get badi information */

    (SELECT ac.id, ac.application_citizen_type_id, ac.if_main,
    CONCAT("নাম: ", IFNULL(ac.name, "")," ঠিকানা: ", IFNULL(ac.address, "")," মোবাইল নং: ", IFNULL(ac.mobile_no, "")) AS badi
    FROM application_citizens ac
    WHERE ac.application_id = 3271611
    AND ac.application_citizen_type_id = 1 AND ac.if_main = 1)
    UNION
    (SELECT ac.id, ac.application_citizen_type_id, ac.if_main,
    CONCAT("নাম: ", IFNULL(ac.name, "")," ঠিকানা: ", IFNULL(ac.address, ""), " মোবাইল নং: ", IFNULL(ac.mobile_no, "")) AS badi
    FROM application_citizens ac
    WHERE ac.application_id = 3271611
    AND ac.application_citizen_type_id = 1 
    AND ac.if_main = 0
    AND NOT EXISTS (SELECT 1 FROM application_citizens ac_sub WHERE ac_sub.application_id = 3271611
AND ac_sub.application_citizen_type_id = 1 AND ac_sub.if_main = 1)
);

/*get bibadi information*/

SELECT ac.id,ac.application_citizen_type_id,ac.if_main,
CONCAT("নাম: ", IFNULL(ac.name, ""), " ঠিকানা: ", IFNULL(ac.address, ""), " মোবাইল নং: ", IFNULL(ac.mobile_no, "")) AS bibadi
FROM application_citizens ac WHERE ac.application_id = 3271611
  AND (
      (ac.application_citizen_type_id = 4 AND ac.if_main = 1)
      OR 
      (ac.application_citizen_type_id = 4 AND ac.if_main = 0 AND NOT EXISTS (
          SELECT 1 
          FROM application_citizens ac_sub
          WHERE ac_sub.application_id = 3271611
            AND ac_sub.application_citizen_type_id = 4
            AND ac_sub.if_main = 1
      ))
      OR
      (ac.application_citizen_type_id = 2 AND ac.if_main = 1 AND NOT EXISTS (
          SELECT 1 
          FROM application_citizens ac_sub
          WHERE ac_sub.application_id = 3271611
            AND ac_sub.application_citizen_type_id = 4
            AND ac_sub.if_main IN (1, 0)
      ))
      OR
      (ac.application_citizen_type_id = 2 AND ac.if_main = 0 AND NOT EXISTS (
          SELECT 1 
          FROM application_citizens ac_sub
          WHERE ac_sub.application_id = 3271611
            AND ac_sub.application_citizen_type_id = 4
            AND ac_sub.if_main IN (1, 0)
      ) AND NOT EXISTS (
          SELECT 1 
          FROM application_citizens ac_sub
          WHERE ac_sub.application_id = 3271611
            AND ac_sub.application_citizen_type_id = 2
            AND ac_sub.if_main = 1
      ))
  );



      SET counter1 = counter1 + 1;
    END WHILE;
      
    SELECT res;
    

    
    COMMIT;
    SET autocommit = 1;
END //

DELIMITER ;

DROP PROCEDURE second_order_auto_placement_test;

CALL second_order_auto_placement_test();

/*
To make bangla date: 
SELECT REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'), '0', '০'), '1', '১'), '2', '২'), '3', '৩'), '4', '৪'), '5', '৫'), '6', '৬'), '7', '৭'), '8', '৮'), '9', '৯') AS bangla_timestamp;

*/