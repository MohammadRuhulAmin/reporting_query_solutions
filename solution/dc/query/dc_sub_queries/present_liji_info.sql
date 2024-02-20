SELECT tprli.app_id application_id,
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
order by tprli.application_id