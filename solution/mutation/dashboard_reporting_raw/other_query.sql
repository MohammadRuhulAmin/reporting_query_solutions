SELECT GROUP_CONCAT(MaxiD ORDER BY MaxiD) HistID,MAX(MaxiD) MaxiD
FROM (SELECT MAX(id ) MaxiD 
FROM (SELECT id,application_id,created   
FROM `mutation_barisal`.`case_status_updates` 
WHERE `case_status_id` IN (9,20,27,39) 
AND id>${max_HistID}
ORDER BY id 
LIMIT 100) tmp 
GROUP BY application_id 
ORDER BY MaxiD LIMIT 50) tmp2;



SELECT max(hist_id) max_HistID
FROM `mutation_barisal`.`dashboard_reporting_raw`;


SELECT IF(max_HistID>0,CONCAT('id>',max_HistID),CONCAT('created>=''2022-07-01'' AND id>',max_HistID)) AS "Condition"
FROM (SELECT '2022-07-01' dt, IFNULL(MAX(hist_id),0) max_HistID
FROM `mutation_barisal`.`dashboard_reporting_raw`) tmp





