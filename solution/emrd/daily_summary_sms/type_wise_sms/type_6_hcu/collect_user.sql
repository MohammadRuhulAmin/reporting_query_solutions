SELECT email,id,mobile,TRIM(CONCAT(" ", IFNULL(first_name,""), " ", IFNULL(last_name," "))) AS fullName FROM users WHERE org_id = 5 AND mobile IS NOT NULL
UNION 
SELECT email,id,mobile,TRIM(CONCAT(" ", IFNULL(first_name,""), " ", IFNULL(last_name," "))) AS fullName FROM users WHERE id IN(118,217,258,262)
UNION 
SELECT DISTINCT u.email,u.id,u.mobile,TRIM(CONCAT(" ", IFNULL(u.first_name,""), " ", IFNULL(u.last_name," "))) AS fullName
 FROM(SELECT DISTINCT mhr.model_id AS user_id FROM roles r
LEFT JOIN model_has_roles mhr ON mhr.role_id = r.id
WHERE NAME LIKE "%Managing Director%"
AND mhr.model_id IS NOT NULL)temp1
LEFT JOIN users u ON u.id = temp1.user_id;