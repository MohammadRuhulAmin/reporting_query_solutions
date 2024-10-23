DELIMITER //

CREATE PROCEDURE processChallanData()
BEGIN
    DECLARE s_challan_id INT;
    DECLARE s_division_id INT;
    DECLARE s_application_id INT;
    DECLARE s_payment_by VARCHAR(255);
    DECLARE s_is_wallet VARCHAR(3);
    DECLARE s_client_unique_id VARCHAR(255);
    DECLARE s_trns_req_id INT;
    DECLARE s_payment_id INT;
    DECLARE s_tkm_id INT;

    -- Start the transaction
    START TRANSACTION;

    -- Fetch the challan details
    SELECT c.id, c.division_id,
    SUBSTRING_INDEX(SUBSTRING_INDEX(c.client_unique_id, '#', 2), '#', -1) AS application_id,
    c.payment_by,IF(INSTR(c.payment_by, 'wallet') > 0, 'Yes', 'No') AS is_wallet,
    c.client_unique_id, c.trns_req_id
    INTO challan_id, division_id, application_id, payment_by, is_wallet, client_unique_id, trns_req_id
    FROM pg_service.challan c
    WHERE c.id > (SELECT IFNULL(MAX(id), 0) FROM pg_service_rnd.challan)
    AND c.challan_generation_status = 1 
    AND c.transaction_date < CURDATE()
    ORDER BY c.id LIMIT 1;

    -- Insert data into pg_service_rnd tables
    INSERT INTO pg_service_rnd.challan SELECT * FROM pg_service.challan c WHERE c.id = s_challan_id;
    INSERT INTO pg_service_rnd.challan_history SELECT * FROM pg_service.challan_history ch WHERE ch.challan_id = s_challan_id;
    INSERT INTO pg_service_rnd.challan_log SELECT * FROM pg_service.challan_log cl WHERE cl.challan_id = s_challan_id;

    -- Handle wallet or non-wallet payments
    IF is_wallet = 'Yes' THEN
        -- Insert into wallet payment log
        INSERT INTO pg_service_rnd.pg_wallet_payment_log
        SELECT * FROM pg_wallet_payment_log wpl WHERE wpl.division_id = s_division_id AND wpl.application_id = s_application_id;

    ELSE
        -- Non-wallet payment handling
        INSERT INTO pg_service_rnd.pg_payments
        SELECT * FROM pg_service.pg_payments p WHERE p.client_unique_id = CONCAT('055#', s_client_unique_id);

        -- Get the payment ID
        SELECT p.id INTO payment_id FROM pg_service.pg_payments p WHERE p.client_unique_id = CONCAT('055#', s_client_unique_id);

        -- Insert related logs and history
        INSERT INTO pg_service_rnd.pg_payment_log SELECT * FROM pg_service.pg_payment_log pl WHERE pl.payment_id = s_payment_id;
        INSERT INTO pg_service_rnd.pg_payments_history SELECT * FROM pg_service.pg_payments_history ph WHERE ph.pg_payments_id = s_payment_id;
        INSERT INTO pg_service_rnd.transaction_key_mapping SELECT * FROM transaction_key_mapping tkm WHERE tkm.payment_id = s_payment_id;

        -- Get the transaction key mapping ID
        SELECT tkm.id INTO s_tkm_id FROM transaction_key_mapping tkm WHERE tkm.payment_id = s_payment_id;
        INSERT INTO pg_service_rnd.transaction_key_mapping_history 
        SELECT * FROM transaction_key_mapping_history tkmh WHERE tkmh.trans_key_mapping_id = s_tkm_id;
    END IF;
    COMMIT;
END //

DELIMITER ;
