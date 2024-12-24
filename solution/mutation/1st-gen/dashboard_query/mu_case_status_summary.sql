SELECT DATE(NOW()) date,
	SUBSTRING(DATABASE(),10,10) division,
	CASE WHEN status_action_type IN ('order','notice','khotian','namonjur') THEN status_action_type 
	WHEN status_action_type IS NULL AND case_status_id=2 THEN 'Payment' 
	ELSE 'Others' END action,
	CASE WHEN HOUR(created) BETWEEN 8 AND 21 THEN 'Pick' ELSE 'Off-Pick' END period,
	HOUR(created) hour,
	COUNT(id) cnt 
FROM mutation_barisal.case_status_updates 
WHERE created>DATE(NOW()) AND case_status_id !=1
GROUP BY action,hour 
ORDER BY hour,action;