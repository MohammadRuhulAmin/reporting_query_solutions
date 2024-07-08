SELECT r.name `role`,user_with_role_info.* FROM
(SELECT mhr.role_id,user_basic_info.* FROM
(SELECT  tempx.email,tempx.user_name, tempx.id user_id, tempx.mobile FROM 
(SELECT email,CONCAT(IFNULL(first_name,""),IFNULL(last_name,"")) user_name,id,mobile FROM users WHERE org_id = 9 AND mobile IS NOT NULL

UNION 

#getting all the System author
SELECT email,CONCAT(IFNULL(first_name,""),IFNULL(last_name,"")) user_name,id,mobile FROM users WHERE id IN(118,217,258,262)

UNION 

#getting the managing directors
SELECT DISTINCT u.email,CONCAT(IFNULL(u.first_name,""),IFNULL(u.last_name,"")) user_name,u.id,u.mobile
FROM(SELECT DISTINCT mhr.model_id AS user_id FROM roles r
LEFT JOIN model_has_roles mhr ON mhr.role_id = r.id
WHERE NAME LIKE "%Managing Director%"
AND mhr.model_id IS NOT NULL)temp1
LEFT JOIN users u ON u.id = temp1.user_id

UNION

# getting all the admins
SELECT u.email,CONCAT(IFNULL(u.first_name,""),IFNULL(u.last_name,"")) user_name,u.id,u.mobile 
FROM(SELECT * FROM roles r
LEFT JOIN model_has_roles mhr ON mhr.role_id = r.id
WHERE r.name LIKE "%Admin") temp2
LEFT JOIN users u ON u.id = temp2.model_id WHERE u.mobile IS NOT NULL

)tempx
GROUP BY tempx.mobile, tempx.id
ORDER BY tempx.id)user_basic_info

LEFT JOIN `model_has_roles` mhr ON mhr.model_id = user_basic_info.user_id)user_with_role_info
LEFT JOIN roles r ON r.id = user_with_role_info.role_id
GROUP BY user_with_role_info.mobile;
