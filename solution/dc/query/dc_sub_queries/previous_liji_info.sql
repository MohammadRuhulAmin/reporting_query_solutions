SELECT tpli.app_id application_id,
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
order by tpli.application_id