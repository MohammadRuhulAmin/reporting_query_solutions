UPDATE hmis_pilgrim_img_archive
SET details = REPLACE(details, 'old_sub_string', 'new_sub_string')
WHERE id = 2;


Example:

UPDATE hmis_pilgrim_img_archive
SET details = REPLACE(details, 'prp-img-prod', 'hmis-image-uat')
WHERE id = 2;