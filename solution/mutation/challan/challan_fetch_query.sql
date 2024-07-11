#step:1
select ifnull(max(id),0) as max_id from `arc_pg_service`.`challan`;

#step:2

low_max_id = ${max_id:plus(1)}
high_max_id = ${max_id:plus(1000)}

SELECT * FROM `pg_service`.`challan`
WHERE id BETWEEN "${low_max_id}" AND "${high_max_id}"
AND challan_generation_status=2 
AND created_at < "2024-01-01"
ORDER BY id LIMIT 1;

#step:3
foreign_id = $.id 

SELECT * FROM `pg_service`.`challan_history`
WHERE challan_id = "${foreign_id}"; 

SELECT * FROM `pg_service`.`challan_log`
WHERE challan_id = "${foreign_id}";