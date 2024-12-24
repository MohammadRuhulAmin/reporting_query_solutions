SELECT a.`id` application_id,
	app_hist.id hist_id,
	a.`jomi_division_id`,
	a.`district_id`,
	dd.name_bn district_name,
	a.`upazila_id`,
	du.name_bd upazila_name,
	oma.`union_office_id`,
	oma.union_office_name,
	a.`mouja_id`,
	a.`case_main_status_id`,
	csu_rec.`created` receive_date,
	CASE WHEN a.`case_main_status_id` IN (9,27) THEN cas.`created`
	WHEN a.`case_main_status_id` IN (20,22) THEN csu_kha_final.`created` END disposed_date,
	app_hist.created hist_date,
	cp.user_id proposal_sub_ulao_id,
	cp.created `proposal_submit_date`,
	ar.user_id report_sub_ulao_id,
	ar.created `report_submit_date`,
	CASE WHEN a.`case_main_status_id` IN (20,22) THEN co.user_id
	WHEN a.`case_main_status_id` IN (9)THEN co_dis.user_id ELSE co_f.user_id END disposed_ac_land_id,
	CASE WHEN a.`case_main_status_id` IN (20,22) THEN  csu_l_order.created  
	WHEN a.`case_main_status_id` IN (9,27) THEN NULL END`final_order_date`,
	k.khotian_no khatian_no
FROM `mutation_chottogram`.`case_status_updates` app_hist
LEFT JOIN `mutation_chottogram`.`applications` a ON app_hist.`application_id`=a.id
LEFT JOIN `mutation_chottogram`.`dglr_districts` dd ON a.`district_id`=dd.id
LEFT JOIN `mutation_chottogram`.`dglr_upazilas` du ON a.`upazila_id`=du.id
LEFT JOIN `mutation_chottogram`.`khotians` k  ON a.id=k.`application_id`
LEFT JOIN `mutation_chottogram`.`office_wise_mouja_assign` oma ON a.`mouja_id`=oma.`mouja_id`
LEFT JOIN `mutation_chottogram`.`case_status_updates` csu_rec ON csu_rec.`application_id`=a.`id` AND csu_rec.`case_status_id`=2
LEFT JOIN `mutation_chottogram`.`case_status_updates` cas ON a.id=cas.application_id AND cas.case_status_id IN (9,27)
LEFT JOIN `mutation_chottogram`.`case_status_updates` csu_l_order ON csu_l_order.`application_id`=a.`id`AND csu_l_order.`case_status_id`=19
LEFT JOIN `mutation_chottogram`. `case_status_updates` csu_kha_final ON csu_kha_final.`application_id`=a.`id`AND csu_kha_final.`case_status_id`=20
LEFT JOIN `mutation_chottogram`.`case_proposals` cp ON a.id=cp.application_id
LEFT JOIN `mutation_chottogram`.`application_reports` ar ON a.id=ar.application_id
LEFT JOIN `mutation_chottogram`.`case_orders` co ON csu_l_order.case_order_id=co.id
LEFT JOIN `mutation_chottogram`.`case_orders` co_dis ON cas.status_action_id=co_dis.id
LEFT JOIN `mutation_chottogram`.`case_orders` co_f ON a.id=co_f.application_id
WHERE a.`case_main_status_id` IN (20,22) 
AND app_hist.id IN (${HistID})
GROUP BY a.`id`
ORDER BY a.`id`;
