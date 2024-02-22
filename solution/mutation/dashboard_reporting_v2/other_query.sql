SELECT id upazila_id  
FROM `mutation_chottogram`.`dglr_upazilas` 
WHERE `division_id`=2 AND upazila_id>0
order by id