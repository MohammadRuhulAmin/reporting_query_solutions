DELIMITER // 

CREATE PROCEDURE second_order_auto_placement()
BEGIN
    DECLARE applications_application_id_list JSON;
    DECLARE p_application_id INT;
    DECLARE p_status INT;
    DECLARE res VARCHAR(244);
    DECLARE error_message TEXT;
    
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
    COMMIT;
    SET autocommit = 1;
END //

DELIMITER ;
