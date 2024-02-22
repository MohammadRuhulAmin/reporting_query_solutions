#step1 
SELECT IFNULL(MAX(hist_id),0) max_HistID
FROM `mutation_dashbord`.`duplicate_khatian_raw`
WHERE jomi_division_id = 2;

#step2
SELECT GROUP_CONCAT(MaxiD ORDER BY MaxiD) HistID,MAX(MaxiD) MaxiD
FROM (SELECT MAX(id ) MaxiD
FROM (SELECT cs.id,application_id,cs.created   
FROM `mutation_chottogram`.`case_status_updates` cs
LEFT JOIN `mutation_chottogram`.`applications` a ON cs.application_id=a.id  
WHERE cs.case_status_id IN (20,22) AND a.jomi_division_id=2
AND cs.id> ${max_HistID}
ORDER BY cs.id
LIMIT 200) tmp
GROUP BY application_id
ORDER BY MaxiD LIMIT 100) tmp2;

