SELECT a.`tracking_no`,a.`vp_case_no`,ci.`extradition_case_no`,ci.`extradition_case_date`,ci.`tofsil_no`,ci.`apil_court_name`,
ci.`protoponno_appeal_case_no`,ci.`appeal_case_date`,ci.`apil_tofsil_no`,
ci.`vp_ep_case_no`,ci.`vp_ep_case_date`,ci.`rit_case_no`,ci.`current_case_status`,
ci.`deoyani_case_no`,
ci.`obomukti_niseddhakga`,ci.`land_released`,ci.`obomukti_niseddhakga_case_no`,
ci.`obomukti_niseddhakga_details`,ci.`obomukti_niseddhakga_preiod`,
aki.`appeal_khatian_type`,aki.`appeal_khatian_no`,aki.`appeal_land_amount`,
aki.`appeal_order_date`,cki.`case_khatian_type`,cki.`case_khatian_no`,
cki.`case_order_date`,
cd.`case_dag_no`,cd.`case_land_amount`,cd.`case_latest_status`
FROM `case_info` ci 
LEFT JOIN `appeal_khatian_info` aki ON aki.case_info_id = ci.id
LEFT JOIN `case_khatian_info` cki ON cki.case_info_id = ci.id
LEFT JOIN `case_data` cd ON cd.`case_khatian_info_id` = cki.id
LEFT JOIN `applications` a ON a.application_id = ci.application_id
ORDER BY ci.application_id;



