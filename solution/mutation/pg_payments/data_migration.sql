START TRANSACTION;

SELECT c.id,c.division_id,SUBSTRING_INDEX(SUBSTRING_INDEX(c.client_unique_id, '#', 2),'#',-1) AS application_id,c.payment_by
,IF(INSTR(c.payment_by, 'wallet') > 0,'Yes','No') is_wallet
,c.client_unique_id,c.trns_req_id
INTO @challan_id, @division_id, @application_id, @payment_by, @is_wallet, @client_unique_id, @trns_req_id
FROM pg_service.challan c
WHERE c.id> (SELECT IFNULL(MAX(id),0)challan_max_id FROM `pg_service_rnd`.`challan`)  
AND c.challan_generation_status=1 AND c.transaction_date< CURDATE() ORDER BY c.id LIMIT 1;

INSERT INTO pg_service_rnd.challan SELECT * FROM pg_service.challan c WHERE c.id  = @challan_id;
INSERT INTO pg_service_rnd.challan_history SELECT * FROM pg_service.challan_history ch WHERE ch.challan_id=@challan_id;
INSERT INTO pg_service_rnd.challan_log SELECT * FROM pg_service.challan_log cl WHERE cl.challan_id=@challan_id;

IF @is_wallet = 'Yes' THEN
	INSERT INTO pg_service_rnd.pg_wallet_payment_log SELECT * FROM pg_wallet_payment_log wpl WHERE wpl.division_id=@division_id AND wpl.application_id=@application_id;

ELSE
	INSERT INTO pg_service_rnd.pg_payments SELECT * FROM pg_service.pg_payments p WHERE p.client_unique_id=CONCAT('055#',@client_unique_id);
	
	# get the payment id
	SELECT p.id INTO@payment_id FROM pg_service.pg_payments p WHERE p.client_unique_id=CONCAT('055#',@client_unique_id);
	
	INSERT INTO pg_service_rnd.pg_payment_log SELECT * FROM pg_service.pg_payment_log pl WHERE pl.payment_id=@payment_id;

	INSERT INTO pg_service_rnd.pg_payments_history SELECT * FROM pg_service.pg_payments_history ph WHERE ph.pg_payments_id=@payment_id;

	INSERT INTO pg_service_rnd.transaction_key_mapping SELECT * FROM transaction_key_mapping tkm WHERE tkm.payment_id=@payment_id;
	
	#get the transaction key mapping id
	SELECT tkm.id INTO @tkm_id FROM transaction_key_mapping tkm WHERE tkm.payment_id=@payment_id;
	SELECT * FROM transaction_key_mapping_history tkmh WHERE tkmh.trans_key_mapping_id=@tkm_id;
	

END IF;

COMMIT;

ROLLBACK;
