SELECT id upazila_id  
FROM `mutation_chottogram`.`dglr_upazilas` 
WHERE `division_id`=2 AND upazila_id>0
order by id;


SELECT `union_office_id` 
FROM `mutation_chottogram`.`office_wise_mouja_assign` 
WHERE `mouja_id`=${mouja_id};



 UPDATE `mutation_chottogram`.`dashboard_reporting_raw` 
 SET `union_office_id`=${union_office_id} 
 WHERE `mouja_id`=${mouja_id} AND `union_office_id` IS NULL;