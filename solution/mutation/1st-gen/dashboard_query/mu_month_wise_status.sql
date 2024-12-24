SELECT 1 `division_id`,tmp1.district_id,`district_name`,tmp1.upazila_id,`upazila_name`,CONVERT(tmp1.`year`,char) year ,tmp1.`month` MONTH,tmp1.application,tmp3.`payment`,tmp2.disposed,tmp2.approve approved,tmp3.`DCR` `dcr_payment`
FROM(SELECT district_id,`district_name`,upazila_id,`upazila_name`,`year`,`month`,COUNT(id) `application`
	FROM(SELECT a.`district_id`,dd.`name_bn` 'district_name',a.`upazila_id`,du.`name_bd` 'upazila_name',YEAR(csu.`created`)`year`,MONTH(csu.`created`)`month`,a.`id`,a.`case_main_status_id`,csu.`created`
		FROM `mutation_barisal`.`applications` a
		LEFT JOIN `mutation_barisal`.`dglr_districts` dd ON a.`district_id`=dd.`id`
		LEFT JOIN `mutation_barisal`.`dglr_upazilas` du ON a.`upazila_id`=du.`id`
		LEFT JOIN `mutation_barisal`.`case_status_updates` csu ON a.`id`=csu.`application_id` AND csu.`case_status_id`=2
		WHERE a.`jomi_division_id`=1 AND a.`case_main_status_id`!=1 
		AND csu.`created` BETWEEN DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY),'%Y-%m-01') AND DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY),'%Y-%m-%d 23:59:59')
		AND a.`district_id`!=55
		GROUP BY a.`id`)tmp
	GROUP BY district_id,upazila_id,`year`,`month`)tmp1
LEFT JOIN(SELECT a.`district_id`,a.`upazila_id`,YEAR(drr.`disposed_date`) `year`,MONTH(drr.`disposed_date`) `month`,COUNT(a.`id`) disposed,
	SUM(IF(a.`case_main_status_id` IN(20,22),1,0)) `approve`
	FROM `mutation_barisal`.`dashboard_reporting_raw` drr
	LEFT JOIN `mutation_barisal`.applications a ON drr.`application_id`=a.`id`
	WHERE a.`jomi_division_id`=1 AND a.`district_id`!=55
	AND a.case_main_status_id IN (9,20,22,27,39) AND drr.`disposed_date` BETWEEN DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY),'%Y-%m-01') AND DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY),'%Y-%m-%d 23:59:59')
	GROUP BY a.`district_id`,a.`upazila_id`,YEAR(drr.`disposed_date`),MONTH(drr.`disposed_date`))tmp2 ON tmp1.district_id=tmp2.district_id AND tmp1.upazila_id=tmp2.upazila_id AND tmp1.`year`=tmp2.`year` AND tmp1.`month`=tmp2.`month`
LEFT JOIN(SELECT p.`district_id`,p.`upazila_id`,YEAR(p.`created_at`)`year`,MONTH(p.`created_at`)`month`,
		SUM(p.`amount`)`payment`,SUM(IF(p.`payment_type`='DCR',1100,0)) `DCR`
	FROM `mutation_barisal`.`payments` p
	WHERE p.`status`=1 AND p.`created_at` BETWEEN DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY),'%Y-%m-01') AND DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 DAY),'%Y-%m-%d 23:59:59')
	AND p.`district_id`!=55
	GROUP BY p.`district_id`,p.`upazila_id`,YEAR(p.`created_at`),MONTH(p.`created_at`))tmp3 ON tmp1.district_id=tmp3.district_id AND tmp1.upazila_id=tmp3.upazila_id AND tmp1.`year`=tmp3.`year` AND tmp1.`month`=tmp3.`month`;

