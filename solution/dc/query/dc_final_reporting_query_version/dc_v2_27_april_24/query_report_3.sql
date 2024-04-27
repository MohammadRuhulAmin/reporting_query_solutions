SELECT a.`vp_case_no`,ki.`lijcreto_land_amount`,ki.`olijcreto_land_amount`,
ki.`mot_dabir_poriman`,ki.`mot_dabir_poriman_value`
FROM `khatian_info` ki
LEFT JOIN applications a ON a.application_id = ki.application_id
ORDER BY ki.application_id;