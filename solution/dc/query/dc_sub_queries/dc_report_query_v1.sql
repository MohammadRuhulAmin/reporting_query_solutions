SELECT a.application_id,a.`tracking_no`,a.`gadget_cromik_no`,a.`vp_jomi_mowja`,a.`vp_case_no`,a.`applicant_upazila`,
ai.`applicant_name`,ai.`father_or_husband`,ai.`mother`,ai.`address`,ai.`applicant_district`,ai.`applicant_upazila`,
ai.`sabek_bortoman_thana`, 
tmp_ctd.temp_land_type_class land_type_class,
temp_cf.
temp_cf.application_id,temp_cf.`court_name`,temp_cf.`extradition_case_no`,temp_cf.`extradition_case_date`,
temp_cf.`tofsil_no`,temp_cf.`apil_court_name`,
temp_cf.`protoponno_appeal_case_no`,temp_cf.`appeal_case_date`,temp_cf.`apil_tofsil_no`,
temp_cf.`vp_ep_case_no`,
temp_cf.`vp_ep_case_date`,temp_cf.`rit_case_no`,temp_cf.`current_case_status`,temp_cf.`deoyani_case_no`,
temp_cf.`obomukti_niseddhakga`,temp_cf.`obomukti_niseddhakga_data`,temp_cf.`land_released`,
temp_cf.`land_released_data`,
temp_cf.`sketchmap`,temp_cf.`onnanno`,temp_cf.`obomukti_sarok_document_data`,
#case_khatian_info cki
temp_cf.`case_khatian_type`,temp_cf.`case_khatian_no`,temp_cf.`case_dag_no`,
temp_cf.`case_latest_status`,temp_cf.`case_order_date`,
#`appeal_khatian_info` aki
temp_cf.`appeal_khatian_type`,temp_cf.`appeal_khatian_no`,temp_cf.`appeal_dag_no`,temp_cf.`appeal_land_amount`,
temp_cf.`appeal_latest_status`,
temp_cf.`appeal_order_date`,
temp_prlf.`present_liji_name_change`,temp_prlf.`present_liji_name`,temp_prlf.`present_liji_nid_or_birth_no`,
temp_prlf.`present_liji_father_or_husband`,temp_prlf.`present_liji_mother`,temp_prlf.`present_liji_district`,
temp_prlf.`present_liji_upazila`,temp_prlf.`present_liji_address`,temp_prlf.`present_liji_mobile`,
temp_prlf.`present_liji_class_type_data`,temp_prlf.`present_liji_class_type_land_value`,
temp_prlf.`present_lijmani_amount`,temp_prlf.`present_lijmani_rosid_no`,temp_prlf.`present_lijmani_paid_date`,
temp_prlf.`present_liji_duration`,temp_prlf.`present_signboard_status`,temp_prlf.`present_investigator`,
temp_prlf.`present_official`,
temp_pli.`liji_name`,temp_pli.`nid_or_birth_no`,temp_pli.`liji_father_or_husband`,temp_pli.`liji_mother`,
temp_pli.`liji_district`,temp_pli.`liji_upazila`,temp_pli.`liji_address`,
temp_pli.`liji_class_type_data`,temp_pli.`liji_class_type_land_value`,
temp_pli.`lijmani_amount`,temp_pli.`lijmani_rosid_no`,temp_pli.`lijmani_paid_date`,temp_pli.`liji_duration`,
temp_tfsl.application_id,temp_tfsl.`sensers_talika`,temp_tfsl.`sensers_talika_cromik_no`,
temp_tfsl.`khatian_type`,temp_tfsl.`khatian_no`,temp_tfsl.`dag_no`,temp_tfsl.`land_amount`,temp_tfsl.`lijcreto_land_amount`,
temp_tfsl.`mot_dabir_poriman`,temp_tfsl.`mot_dabir_poriman_value`
FROM applications a
LEFT JOIN applicant_info ai ON ai.application_id = a.application_id
LEFT JOIN (SELECT  tmplx.application_id,
GROUP_CONCAT(tmplx.name_bn) temp_land_type_class 
FROM(SELECT a.application_id,a.`tracking_no`,a.`gadget_cromik_no`,a.`vp_jomi_mowja`,a.`vp_case_no`,a.`applicant_upazila`,ctd.name_bn
FROM applications a 
LEFT JOIN class_type_data ctd ON ctd.application_id = a.application_id)tmplx
GROUP BY tmplx.application_id
ORDER BY tmplx.application_id) tmp_ctd ON tmp_ctd.application_id = a.application_id
LEFT JOIN (SELECT 
ci.application_id,ci.`court_name`,ci.`extradition_case_no`,ci.`extradition_case_date`,ci.`tofsil_no`,ci.`apil_court_name`,
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
LEFT JOIN `appeal_khatian_info` aki ON aki.case_info_id = ci.id)temp_cf ON temp_cf.application_id = a.application_id
LEFT JOIN (SELECT tprli.app_id application_id,
GROUP_CONCAT(tprli.`present_liji_name_change`) present_liji_name_change,
GROUP_CONCAT(tprli.`present_liji_name`) present_liji_name,
GROUP_CONCAT(tprli.`present_liji_nid_or_birth_no`) present_liji_nid_or_birth_no,
GROUP_CONCAT(tprli.`present_liji_father_or_husband`) present_liji_father_or_husband ,
GROUP_CONCAT(tprli.`present_liji_mother`) present_liji_mother,
GROUP_CONCAT(tprli.`present_liji_district`) present_liji_district,
GROUP_CONCAT(tprli.`present_liji_upazila`) present_liji_upazila,
GROUP_CONCAT(tprli.`present_liji_address`) present_liji_address,
GROUP_CONCAT(tprli.`present_liji_mobile`) present_liji_mobile,
GROUP_CONCAT(tprli.`present_liji_class_type_data`) present_liji_class_type_data,
GROUP_CONCAT(tprli.`present_liji_class_type_land_value`) present_liji_class_type_land_value,
GROUP_CONCAT(tprli.`present_lijmani_amount`)present_lijmani_amount,
GROUP_CONCAT(tprli.`present_lijmani_rosid_no`) present_lijmani_rosid_no,
GROUP_CONCAT(tprli.`present_lijmani_paid_date`)present_lijmani_paid_date,
GROUP_CONCAT(tprli.`present_liji_duration`)present_liji_duration,
GROUP_CONCAT(tprli.`present_signboard_status`)present_signboard_status,
GROUP_CONCAT(tprli.`present_investigator`)present_investigator,
GROUP_CONCAT(tprli.`present_official`)present_official
FROM(SELECT a.application_id app_id,prli.* FROM `applications` a
LEFT JOIN `present_liji_info` prli ON prli.application_id = a.application_id)tprli
GROUP BY tprli.application_id
ORDER BY tprli.application_id)temp_prlf ON temp_prlf.application_id = a.application_id
LEFT JOIN (SELECT tpli.app_id application_id,
GROUP_CONCAT(`liji_name`)liji_name,
GROUP_CONCAT(`nid_or_birth_no`)nid_or_birth_no,
GROUP_CONCAT(`liji_father_or_husband`)liji_father_or_husband,
GROUP_CONCAT(`liji_mother`)liji_mother,
GROUP_CONCAT(`liji_district`)liji_district,
GROUP_CONCAT(`liji_upazila`)liji_upazila,
GROUP_CONCAT(`liji_address`)liji_address,
GROUP_CONCAT(`liji_class_type_data`)liji_class_type_data,
GROUP_CONCAT(`liji_class_type_land_value`)liji_class_type_land_value,
GROUP_CONCAT(`lijmani_amount`)lijmani_amount,
GROUP_CONCAT(`lijmani_rosid_no`)lijmani_rosid_no,
GROUP_CONCAT(`lijmani_paid_date`)lijmani_paid_date,
GROUP_CONCAT(`liji_duration`)liji_duration
FROM(SELECT a.application_id app_id,pli.* FROM `applications` a
LEFT JOIN `previous_liji_info` pli ON pli.application_id = a.application_id)tpli
GROUP BY tpli.application_id
ORDER BY tpli.application_id)temp_pli ON temp_pli.application_id = a.application_id
LEFT JOIN (SELECT tfsl.application_id,
GROUP_CONCAT(`sensers_talika`)sensers_talika,
GROUP_CONCAT(`sensers_talika_cromik_no`)sensers_talika_cromik_no,
GROUP_CONCAT(`khatian_type`)khatian_type,
GROUP_CONCAT(`khatian_no`)khatian_no,
GROUP_CONCAT(`dag_no`) dag_no,
GROUP_CONCAT(`land_amount`)land_amount,
GROUP_CONCAT(`lijcreto_land_amount`)lijcreto_land_amount,
GROUP_CONCAT(`mot_dabir_poriman`)mot_dabir_poriman,
GROUP_CONCAT(`mot_dabir_poriman_value` )mot_dabir_poriman_value
FROM(SELECT ti.application_id,ti.`sensers_talika`,ti.`sensers_talika_cromik_no`,
tki.`khatian_type`,tki.`khatian_no`,tki.`dag_no`,tki.`land_amount`,tki.`lijcreto_land_amount`,
tki.`mot_dabir_poriman`,tki.`mot_dabir_poriman_value`
FROM tofsil_info ti
LEFT JOIN tofsil_khatian_info tki ON tki.tofsil_info_id = ti.id)tfsl
GROUP BY tfsl.application_id
ORDER BY tfsl.application_id)temp_tfsl ON temp_tfsl.application_id = a.application_id
ORDER BY a.application_id;
