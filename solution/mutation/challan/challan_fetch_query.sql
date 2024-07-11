#step:1
select ifnull(max(id),0) as max_id from `arc_pg_service`.`challan`;

#step:2

low_max_id = ${max_id:plus(1)}
high_max_id = ${max_id:plus(1000)}

SELECT
`id`, 
`client_id`, `client_unique_id`, `pay_unique_id`, `trns_req_id`, 
`upazilla_code`, `upazilla_name`, 
`division_id`, `office_id`, 
`name`, `address`, `nid`, CAST(`dob` AS CHAR) dob, `mobile`, 
`total_amount`, `chalan_amount`, `payment_by`, 
CAST(`transaction_date` AS CHAR)transaction_date, 
`orgCode`, `paymentType`, 
`challan_generation_status`, 
`is_delivered_to_client`, 
`challan_request_json`, 
`challan_response_json`, 
`challan_code`, `challan_url`, 
CAST(`created_at` AS CHAR) created_at, `created_by`, 
CAST(`updated_at` AS CHAR)`updated_at`, `updated_by`, 
`req_to_ucb_dt`, `resp_from_ucb_dt`, 
`resp_to_client_dt`, 
`no_of_try`, IF(`challan_request_date` IS NULL, NULL,CAST(`challan_request_date` AS CHAR)) challan_request_date
FROM `pg_service`.`challan`
WHERE id BETWEEN "${low_max_id}" AND "${high_max_id}"
AND challan_generation_status=2 
AND created_at < "2024-01-01"
ORDER BY id LIMIT 1;

#step:3
foreign_id = $.id 

SELECT 
`id`, `challan_id`, `action_type`, CAST(`action_time` AS CHAR)action_time, `client_id`, `client_unique_id`,
 `trns_req_id`, `upazilla_code`, `upazilla_name`, `division_id`, `office_id`, `name`, `address`, 
 `nid`, CAST(`dob` AS CHAR) dob, `mobile`, `total_amount`, `chalan_amount`, `payment_by`, 
 CAST(`transaction_date` AS CHAR)transaction_date, 
 `orgCode`, `paymentType`, `challan_generation_status`, `is_delivered_to_client`, `challan_request_json`, 
 `challan_response_json`, `challan_code`, `challan_url`,
 CAST(`created_at` AS CHAR) created_at, `created_by`, CAST(`updated_at` AS CHAR)updated_at, `updated_by`  
 FROM `pg_service`.`challan_history`
WHERE challan_id = ${foreign_id}; 





SELECT 	`id`, `challan_id`, `client_unique_id`, 
`request_json_data`, `response_json_data`, 
`api`, CAST(`created_at` AS CHAR)created_at, 
`created_by`, CAST(`updated_at` AS CHAR) updated_at, 
`updated_by`
FROM 
`pg_service`.`challan_log` WHERE challan_id = ${foreign_id};