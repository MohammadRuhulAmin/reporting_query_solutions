#process 1:
SELECT application_id FROM `dashboard_reporting_raw` WHERE disposed_date IS NULL;


#process 2:
SELECT a.`id` application_id,
app_hist.id hist_id,
a.`case_main_status_id`, 
CASE WHEN a.`case_main_status_id` IN (9,27,39) THEN cas.`created`
WHEN a.`case_main_status_id` IN (20,22) THEN csu_kha_final.`created` END disposed_date
FROM `applications` a 
LEFT JOIN `case_status_updates` app_hist ON app_hist.`application_id`=a.id AND a.`case_main_status_id`=app_hist.case_status_id
LEFT JOIN `case_status_updates` cas ON a.id=cas.application_id AND cas.case_status_id IN (9,27,39)
LEFT JOIN `case_status_updates` csu_kha_final ON csu_kha_final.`application_id`=a.`id`AND csu_kha_final.`case_status_id`=20
WHERE a.`jomi_division_id`= 3  
AND a.id = ${application_id} 
GROUP BY a.`id`;