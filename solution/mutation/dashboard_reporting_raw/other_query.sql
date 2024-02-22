SELECT GROUP_CONCAT(MaxiD ORDER BY MaxiD) HistID,MAX(MaxiD) MaxiD
FROM (SELECT MAX(id ) MaxiD 
FROM (SELECT id,application_id,created   
FROM `mutation_barisal`.`case_status_updates` 
WHERE `case_status_id` IN (9,20,27) 
AND id>${max_HistID}
ORDER BY id 
LIMIT 100) tmp 
GROUP BY application_id 
ORDER BY MaxiD LIMIT 50) tmp2;



SELECT max(hist_id) max_HistID
FROM `mutation_barisal`.`dashboard_reporting_raw`;





