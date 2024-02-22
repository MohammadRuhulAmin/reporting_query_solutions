SELECT IF(max_ID>0,CONCAT('id>',max_ID),CONCAT('created_at>=''2023-07-11 12:00:00'' AND id>',max_ID)) AS "Condition"
FROM (SELECT IFNULL(MAX(id),0) max_ID
FROM `mutation_barisal`.`disposed_feedback_gplex`) tmp;


SELECT IF(max_ID>0,CONCAT('id>',max_ID),CONCAT('created_at>=''2023-07-11 12:00:00'' AND id>',max_ID)) AS "Condition"
FROM (SELECT IFNULL(MAX(id),0) max_ID
FROM `mutation_barisal`.`disposed_feedback_gplex`) tmp;

