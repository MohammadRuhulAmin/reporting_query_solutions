# Select and join to retrive tracking_no also image 
SELECT hpi.pilgrim_id,hpi.ref_pilgrim_id,hp.tracking_no,image_size,CONVERT(YEAR(hpi.created_at),CHAR) created_year,CONVERT(hpi.created_at,CHAR) created_at,
SUBSTRING(hpi.details, LOCATE('/', hpi.details) + 1, LOCATE(';', hpi.details) - LOCATE('/', hpi.details) - 1) AS img_type,
hpi.created_by,hpi.updated_at,hpi.updated_by,
hpi.details FROM hmis_load.hmis_pilgrim_img hpi 
LEFT JOIN hmis_load.hmis_pilgrims hp ON hp.id = hpi.pilgrim_id 
WHERE hpi.pilgrim_id > 0
AND hp.tracking_no IS NOT NULL
ORDER BY hpi.pilgrim_id LIMIT 5;


# To get distinct image type extention 
select temp.img_type from(SELECT  SUBSTRING(details, 
LOCATE('/', details) + 1, 
LOCATE(';', details) - LOCATE('/', details) - 1) AS img_type from `hmis_pilgrim_img`)temp
where temp.img_type not in('jpeg','html');