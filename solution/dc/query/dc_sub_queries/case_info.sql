SELECT ci.application_id,ci.`court_name`,ci.`extradition_case_no`,ci.`extradition_case_date`,ci.`tofsil_no`,ci.`apil_court_name`,
ci.`protoponno_appeal_case_no`,ci.`appeal_case_date`,ci.`apil_tofsil_no`,ci.`vp_ep_case_no`,
ci.`vp_ep_case_date`,ci.`rit_case_no`,ci.`current_case_status`,ci.`deoyani_case_no`,
ci.`obomukti_niseddhakga`,ci.`obomukti_niseddhakga_data`,ci.`land_released`,ci.`land_released_data`,
ci.`sketchmap`,ci.`onnanno`,ci.`obomukti_sarok_document_data`,
#case_khatian_info cki
cki.`case_khatian_type`,cki.`case_khatian_no`,cki.`case_dag_no`,
cki.`case_latest_status`,cki.`case_order_date`,
#`appeal_khatian_info` aki
aki.`appeal_khatian_type`,aki.`appeal_khatian_no`,aki.`appeal_dag_no`,aki.`appeal_land_amount`,aki.`appeal_latest_status`,
aki.`appeal_order_date`
FROM case_info ci
LEFT JOIN case_khatian_info cki ON cki.case_info_id = ci.id
LEFT JOIN `appeal_khatian_info` aki ON aki.case_info_id = ci.id