

DELIMITER //

CREATE PROCEDURE challan_data_migration_procedure()
BEGIN
    DECLARE s_challan_id INT(11);
    DECLARE s_division_id INT(11);
    DECLARE s_application_id INT(11);
    DECLARE s_payment_by VARCHAR(255);
    DECLARE s_is_wallet VARCHAR(3);
    DECLARE s_client_unique_id VARCHAR(255);
    DECLARE s_trns_req_id VARCHAR(255);
    DECLARE s_payment_id INT(11);
    DECLARE s_tkm_id_list VARCHAR(1000);
    DECLARE s_tkmh_count INT(11);
    DECLARE error_message TEXT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        ROLLBACK;
        INSERT INTO `pg_service_rnd`.`challan_unsuccess_log`(challan_id,division_id, application_id, payment_by, is_wallet, client_unique_id, trans_req_id,error_message,`status`)
	VALUES (s_challan_id,s_division_id,s_application_id,s_payment_by,s_is_wallet,s_client_unique_id,s_trns_req_id,error_message,-1);
	SELECT error_message, CONCAT(" challan_id : ",s_challan_id) challan_info;

    END;
    SET SESSION group_concat_max_len = 1000000;
    SET autocommit = 0;
    START TRANSACTION;

    SELECT c.id, 
           c.division_id,
           SUBSTRING_INDEX(SUBSTRING_INDEX(c.client_unique_id, '#', 2), '#', -1) AS application_id,
           c.payment_by,
           IF(INSTR(c.payment_by, 'wallet') > 0, 'Yes', 'No') AS is_wallet,
           c.client_unique_id, 
           c.trns_req_id
    INTO s_challan_id, s_division_id, s_application_id, s_payment_by, s_is_wallet, s_client_unique_id, s_trns_req_id
    FROM pg_service.challan c
    WHERE c.id > (SELECT IFNULL(MAX(id), 0) FROM pg_service_rnd.challan)
      AND c.challan_generation_status = 1 
      AND c.transaction_date < CURDATE() AND c.id NOT IN (SELECT DISTINCT challan_id FROM pg_service_rnd.`challan_unsuccess_log`)
    ORDER BY c.id 
    LIMIT 1;

    INSERT INTO pg_service_rnd.challan SELECT * FROM pg_service.challan WHERE id = s_challan_id;
    INSERT INTO pg_service_rnd.challan_history SELECT * FROM pg_service.challan_history WHERE challan_id = s_challan_id;
    INSERT INTO pg_service_rnd.challan_log SELECT * FROM pg_service.challan_log WHERE challan_id = s_challan_id;
    
    
    IF s_is_wallet ='No' THEN
        INSERT INTO pg_service_rnd.pg_payments SELECT * FROM pg_service.pg_payments WHERE client_unique_id = CONCAT('055#',s_client_unique_id) AND transaction_id = s_trns_req_id;
        SELECT p.id INTO s_payment_id FROM pg_service.pg_payments p WHERE p.transaction_id = s_trns_req_id AND p.client_unique_id = CONCAT('055#', s_client_unique_id);
        INSERT INTO pg_service_rnd.pg_payment_log SELECT * FROM pg_service.pg_payment_log WHERE payment_id = s_payment_id;
	INSERT INTO pg_service_rnd.pg_payments_history SELECT * FROM pg_service.pg_payments_history WHERE pg_payments_id = s_payment_id;
        INSERT INTO pg_service_rnd.`transaction_key_mapping` SELECT * FROM pg_service.`transaction_key_mapping` WHERE payment_id = s_payment_id;
        
        SELECT GROUP_CONCAT(id) INTO s_tkm_id_list FROM pg_service.transaction_key_mapping WHERE payment_id = s_payment_id;
	INSERT INTO pg_service_rnd.transaction_key_mapping_history SELECT * FROM pg_service.transaction_key_mapping_history
	WHERE trans_key_mapping_id IN (SELECT REPLACE(s_tkm_id_list, "'",""));
	
    ELSE
        INSERT INTO pg_service_rnd.pg_wallet_payment_log SELECT * FROM pg_service.pg_wallet_payment_log WHERE division_id = s_division_id AND application_id = s_application_id;
        
    END IF;
    
    COMMIT;
    SET autocommit = 1;
    SELECT CONCAT("data migration successful for challan_id :",s_challan_id) success_message;
END //

DELIMITER ;