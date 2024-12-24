SELECT * 
FROM (SELECT
    id,
	CONVERT(signature USING utf8) AS image_path,
    TO_BASE64(signature) AS signature,
    signature_date,
    YEAR(signature_date) AS YEAR,
    MONTH(signature_date) AS MONTH
FROM `mutation_khulna`.`khotian_comments`
WHERE id > "${max_ref_id}" 
AND signature IS NOT NULL 
AND signature!='' 
ORDER BY id LIMIT 10) tmp 
WHERE signature!=''
ORDER BY id LIMIT 5; 