SELECT
#applications a
a.application_id,
a.`tracking_no`,a.`gadget_cromik_no`,a.`vp_jomi_mowja`,a.`vp_case_no`,a.`applicant_upazila`,
#applicant_info ai
ai.`applicant_name`,ai.`father_or_husband`,ai.`mother`,ai.`address`,ai.`applicant_district`,ai.`applicant_upazila`,
ai.`sabek_bortoman_thana`,
#present_liji_info prli
prli.`present_liji_name_change`,prli.`present_liji_name`,prli.`present_liji_nid_or_birth_no`,
prli.`present_liji_father_or_husband`,prli.`present_liji_mother`,prli.`present_liji_district`,
prli.`present_liji_upazila`,prli.`present_liji_address`,prli.`present_liji_mobile`,
prli.`present_liji_class_type_data`,prli.`present_liji_class_type_land_value`,
prli.`present_lijmani_amount`,prli.`present_lijmani_rosid_no`,prli.`present_lijmani_paid_date`,
prli.`present_liji_duration`,prli.`present_signboard_status`,prli.`present_investigator`,
prli.`present_official`,
#previous_liji_info pli
pli.`liji_name`,pli.`nid_or_birth_no`,pli.`liji_father_or_husband`,pli.`liji_mother`,
pli.`liji_district`,pli.`liji_upazila`,pli.`liji_address`,
pli.`liji_class_type_data`,pli.`liji_class_type_land_value`,
pli.`lijmani_amount`,pli.`lijmani_rosid_no`,pli.`lijmani_paid_date`,pli.`liji_duration`
FROM applications a
LEFT JOIN applicant_info ai ON ai.application_id = a.application_id
LEFT JOIN case_info ci ON ci.application_id = a.application_id
LEFT JOIN tofsil_info ti ON ti.application_id = a.application_id
LEFT JOIN `present_liji_info` prli ON prli.application_id = a.application_id
LEFT JOIN `previous_liji_info` pli ON pli.application_id = a.application_id
LEFT JOIN
(SELECT temp4.* FROM(SELECT temp2.* FROM(SELECT
#case_info ci
ci.application_id,
ci.`court_name`,ci.`extradition_case_no`,ci.`extradition_case_date`,ci.`tofsil_no`,ci.`apil_court_name`,
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
LEFT JOIN `appeal_khatian_info` aki ON aki.case_info_id = ci.id)temp2
LEFT JOIN (SELECT
#tofsil_info ti
ti.application_id,ti.`sensers_talika`,ti.`sensers_talika_cromik_no`,
#tofsil_khotian_info tki
tki.`khatian_type`,tki.`khatian_no`,tki.`dag_no`,tki.`land_amount`,tki.`lijcreto_land_amount`,
tki.`mot_dabir_poriman`,tki.`mot_dabir_poriman_value`
FROM tofsil_info ti
LEFT JOIN tofsil_khatian_info tki ON tki.tofsil_info_id = ti.id)temp3
ON temp3.application_id = temp2.application_id)temp4
GROUP BY temp4.application_id)temp5
ON temp5.application_id = a.application_id
GROUP BY a.application_id
ORDER BY a.application_id;
