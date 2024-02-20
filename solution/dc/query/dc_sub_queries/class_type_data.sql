SELECT  tmplx.application_id,
GROUP_CONCAT(tmplx.name_bn) temp_land_type_class 
FROM(SELECT 
a.application_id,a.`tracking_no`,a.`gadget_cromik_no`,a.`vp_jomi_mowja`,a.`vp_case_no`,a.`applicant_upazila`,ctd.name_bn
FROM applications a 
LEFT JOIN class_type_data ctd ON ctd.application_id = a.application_id)tmplx
GROUP BY tmplx.application_id
ORDER BY tmplx.application_id
