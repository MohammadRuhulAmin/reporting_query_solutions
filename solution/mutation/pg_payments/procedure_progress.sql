DELIMITER //

CREATE PROCEDURE challan_data_migration_procedure()
BEGIN
    DECLARE s_challan_id BIGINT;
    DECLARE s_division_id BIGINT;
    DECLARE s_application_id BIGINT;
    DECLARE s_payment_by VARCHAR(255);
    DECLARE s_is_wallet VARCHAR(3);
    DECLARE s_client_unique_id VARCHAR(255);
    DECLARE s_trns_req_id VARCHAR(255);
    DECLARE s_payment_id BIGINT;
    DECLARE s_tkm_id BIGINT;
    DECLARE s_tkmh_count BIGINT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT ("Error occured");
    END;
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
      AND c.transaction_date < CURDATE()
    ORDER BY c.id 
    LIMIT 1;

    INSERT INTO pg_service_rnd.challan SELECT * FROM pg_service.challan WHERE id = s_challan_id;
    INSERT INTO pg_service_rnd.challan_history SELECT * FROM pg_service.challan_history WHERE challan_id = s_challan_id;
    INSERT INTO pg_service_rnd.challan_log SELECT * FROM pg_service.challan_log WHERE challan_id = s_challan_id;
    INSERT INTO pg_service_rnd.pg_payments SELECT * FROM pg_service.pg_payments WHERE client_unique_id = CONCAT('055#',s_client_unique_id);
    
    IF s_is_wallet ='No' THEN
        SELECT p.id INTO s_payment_id FROM pg_service.pg_payments p WHERE p.client_unique_id = CONCAT('055#', s_client_unique_id);
        INSERT INTO pg_service_rnd.pg_payment_log SELECT * FROM pg_service.pg_payment_log WHERE payment_id = s_payment_id;
	INSERT INTO pg_service_rnd.pg_payments_history SELECT * FROM pg_service.pg_payments_history WHERE pg_payments_id = s_payment_id;
        INSERT INTO pg_service_rnd.`transaction_key_mapping` SELECT * FROM pg_service.`transaction_key_mapping` WHERE payment_id = s_payment_id;
        #select tkm.id into s_tkm_id from pg_service.`transaction_key_mapping` where payment_id = s_payment_id;
        #insert into pg_service_rnd.`transaction_key_mapping_history` select * from pg_service.transaction_key_mapping_history where trans_key_mapping_id = s_tkm_id;
    
    ELSE
        INSERT INTO pg_service_rnd.pg_wallet_payment_log SELECT * FROM pg_service.pg_wallet_payment_log 
        WHERE division_id = s_division_id AND application_id = s_application_id;
        
    END IF;
    
    COMMIT;
    SET autocommit = 1;
END //

DELIMITER ;