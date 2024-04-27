SELECT  a.`tracking_no`, a.`gadget_cromik_no`,
a.`vp_jomi_mowja`, a.`vp_case_no`, a.`applicant_upazila`,
ctd_temp.`name_bn`,ctd_temp.land_value,
ai.sabek_bortoman_thana,ai.holding_no,ki.`khatian_no`,
ki.`dag_no`,ki.`land_amount`
FROM applications a 
LEFT JOIN (SELECT ctd.application_id,GROUP_CONCAT(ctd.name_bn ORDER BY ctd.id) name_bn,
GROUP_CONCAT(ctd.land_value ORDER BY ctd.id) land_value
FROM `class_type_data` ctd
GROUP BY application_id) ctd_temp
ON ctd_temp.application_id = a.application_id
LEFT JOIN applicant_info ai ON ai.application_id = a.application_id
LEFT JOIN khatian_info ki ON ki.application_id = a.application_id
ORDER BY a.application_id;
