SELECT a.`vp_case_no`,ai.`applicant_name`,
ai.`father_or_husband`,ai.`mother`,ai.`address`,
u.name_bn
FROM applicant_info ai
LEFT JOIN upazilas u ON u.id = ai.`applicant_upazila`
LEFT JOIN applications a ON a.application_id = 
ai.application_id
ORDER BY ai.application_id;