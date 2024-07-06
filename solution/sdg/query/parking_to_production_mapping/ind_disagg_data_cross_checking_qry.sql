SELECT temp_x.*,">><<",temp_y.* FROM(SELECT temp_parking.*, pk_dt.name parking_type_name FROM
(SELECT pk_idd.`ind_data_id` park_ind_data_id, pk_idd.`disagg_id`,pk_idd.`disagg_name` disagg_name,pk_idd.data_value, pk_dn.id, pk_dn.name,pk_dn.type_id type_id
FROM`parking_database`.`indicator_disagg_data` pk_idd
LEFT JOIN `parking_database`.`disaggregation_name` pk_dn ON pk_dn.id = pk_idd.disagg_id
WHERE pk_idd.ind_data_id = 2078 ORDER BY pk_idd.disagg_id)temp_parking
LEFT JOIN `parking_database`.`disaggregation_type` pk_dt ON pk_dt.id = temp_parking.type_id)temp_x
LEFT JOIN
(SELECT temp_prod.*,prd_dt.name prod_type_name FROM
(SELECT prd_idd.`ind_data_id` prod_ind_data_id,prd_idd.disagg_id,prd_idd.disagg_name disagg_name,prd_idd.data_value, prd_dn.id,prd_dn.name,prd_dn.type_id type_id
FROM `sdg-prod`.indicator_disagg_data prd_idd
LEFT JOIN `sdg-prod`.disaggregation_name prd_dn ON prd_dn.id = prd_idd.disagg_id
WHERE prd_idd.ind_data_id = 2078 ORDER BY prd_idd.disagg_id)temp_prod
LEFT JOIN `sdg-prod`.disaggregation_type prd_dt ON prd_dt.id = temp_prod.type_id)temp_y
ON temp_x.parking_type_name = temp_y.prod_type_name AND 
temp_x.disagg_name = temp_y.disagg_name;