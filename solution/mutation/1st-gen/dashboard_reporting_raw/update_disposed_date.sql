#process 1:
SELECT application_id FROM mutation_barisal.`dashboard_reporting_raw` WHERE disposed_date IS NULL;


#process 2:
SELECT a.`id` application_id,
app_hist.id hist_id,
a.`case_main_status_id`, 
CASE WHEN a.`case_main_status_id` IN (9,27,39) THEN cas.`created`
WHEN a.`case_main_status_id` IN (20,22) THEN csu_kha_final.`created` END disposed_date
FROM mutation_barisal.`applications` a 
LEFT JOIN mutation_barisal.`case_status_updates` app_hist ON app_hist.`application_id`=a.id AND a.`case_main_status_id`=app_hist.case_status_id
LEFT JOIN mutation_barisal.`case_status_updates` cas ON a.id=cas.application_id AND cas.case_status_id IN (9,27,39)
LEFT JOIN mutation_barisal.`case_status_updates` csu_kha_final ON csu_kha_final.`application_id`=a.`id`AND csu_kha_final.`case_status_id`=20
WHERE a.`jomi_division_id`= 1  
AND a.id = ${application_id} 
GROUP BY a.`id`;