SELECT temp.id,temp.ref_id, CONCAT(IFNULL(temp.id,""),"_",IFNULL(temp.ref_id,""),"_",temp.unique_id) file_name,
temp.details , CONCAT("minio:/minio.ba-systems.com:prp-image-uat:/",temp.date_form,"/",IFNULL(id,""),"_",IFNULL(ref_id,""),"_",temp.unique_id,".jpeg") database_file_path,
CONCAT(temp.date_form,"/",IFNULL(id,""),"_",IFNULL(ref_id,""),"_",temp.unique_id,".jpeg") object_path,
temp.date_form folder_path FROM
(SELECT id,ref_id,UUID() unique_id,
details,DATE_FORMAT(DATE(created_at), "%Y/%m") date_form 
FROM prp_load.img_user_profile WHERE id > 0 AND  details LIKE "data:image/jpeg;base64,%"
ORDER BY id  LIMIT 5)temp;