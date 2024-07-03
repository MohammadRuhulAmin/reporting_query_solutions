SELECT prod_tbl.*,park_tbl.* FROM
(SELECT prod_dt.name prod_disagg_type, prod_dn.name prod_disagg_name 
FROM `sdg-prod`.`disaggregation_type` prod_dt 
LEFT JOIN `sdg-prod`.`disaggregation_name` prod_dn ON 
prod_dt.id = prod_dn.type_id
WHERE prod_dt.id = 20)prod_tbl
LEFT JOIN
(SELECT park_dt.name park_disagg_type, park_dn.name park_disagg_name
FROM `parking_database`.`disaggregation_type` park_dt
LEFT JOIN `parking_database`.`disaggregation_name` park_dn
ON park_dt.id = park_dn.type_id)park_tbl
ON prod_tbl.prod_disagg_type = park_tbl.park_disagg_type 
AND prod_tbl.prod_disagg_name = park_tbl.park_disagg_name