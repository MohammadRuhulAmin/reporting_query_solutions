DELIMITER // 

CREATE PROCEDURE second_order_auto_placement()
BEGIN

    DECLARE applications_application_id_list JSON;
    DECLARE counter1 INT DEFAULT 0;
    DECLARE array_length INT;
    DECLARE p_application_id INT;
    DECLARE res VARCHAR(244);
    DECLARE error_message TEXT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        ROLLBACK;
        INSERT INTO second_order_error_log(application_id,error_status) VALUES(p_application_id,error_message);
        SELECT error_message AS `error`, p_application_id AS `application_id`;
        
    END;
    
    
    SET autocommit = 0;
    START TRANSACTION;
    SELECT JSON_ARRAYAGG(id) INTO applications_application_id_list
    FROM applications app WHERE app.form_type = 5 AND app.case_main_status_id IN(6,24)
    AND JSON_CONTAINS(app.users_tagged_receive, '["4"]');
    SET array_length = JSON_LENGTH(applications_application_id_list);
    WHILE counter1 < array_length DO
        SET p_application_id = JSON_UNQUOTE(JSON_EXTRACT(applications_application_id_list, CONCAT('$[', counter1, ']')));
	INSERT INTO `second_order_automation_process`(application_id,STATUS) VALUES(p_application_id,1)ON 
	DUPLICATE KEY UPDATE application_id = p_application_id, STATUS= 1;
        SET counter1 = counter1 + 1;
    END WHILE;
    SELECT "data inserted successfully!";
    COMMIT;
    SET autocommit = 1;
END //

DELIMITER ;