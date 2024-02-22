SELECT SUM(`Submitted`) `Submitted`,
SUM(`Disposed`) `Disposed` 
FROM (SELECT 'Dhaka' Division, 
	SUM(IF(a.`case_main_status_id`!=1,1,0)) `Submitted`,
	SUM(IF(a.`case_main_status_id`IN(9,20,22,27,39),1,0)) `Disposed`
	FROM `mutation_dhaka`.`applications` a 
	WHERE jomi_division_id=3
	UNION ALL 
	SELECT 'Rajshahi' Division, 
	SUM(IF(a.`case_main_status_id`!=1,1,0)) `Submitted`,
	SUM(IF(a.`case_main_status_id`IN(9,20,22,27,39),1,0)) `Disposed` 
	FROM `mutation_rajshahi`.`applications` a 
	WHERE jomi_division_id=5 
	UNION ALL 
	SELECT 'Rangpur' Division, 
	SUM(IF(a.`case_main_status_id`!=1,1,0)) `Submitted`,
	SUM(IF(a.`case_main_status_id`IN(9,20,22,27,39),1,0)) `Disposed` 
	FROM `mutation_rangpur`.`applications` a 
	WHERE jomi_division_id=6
	UNION ALL 
	SELECT 'Sylhet' Division, 
	SUM(IF(a.`case_main_status_id`!=1,1,0)) `Submitted`,
	SUM(IF(a.`case_main_status_id`IN(9,20,22,27,39),1,0)) `Disposed`
	FROM `mutation_sylhet`.`applications` a 
	WHERE jomi_division_id=7) tmp ;