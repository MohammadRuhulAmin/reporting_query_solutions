SELECT 
a.application_id,
a.`tracking_no`,a.`gadget_cromik_no`,a.`vp_jomi_mowja`,a.`vp_case_no`,a.`applicant_upazila`,
ai.`applicant_name`,ai.`father_or_husband`,ai.`mother`,ai.`address`,ai.`applicant_district`,ai.`applicant_upazila`,
ai.`sabek_bortoman_thana`
FROM applications a
LEFT JOIN applicant_info ai ON ai.application_id = a.application_id