
SELECT DISTINCT tempx.mobile, tempx.id, tempx.email FROM 
(SELECT email,id,mobile FROM users WHERE org_id = 5 AND mobile IS NOT NULL

UNION 

#getting all the System author
SELECT email,id,mobile FROM users WHERE id IN(118,217,258,262)

UNION 

#getting the managing directors
SELECT DISTINCT u.email,u.id,u.mobile
 FROM(SELECT DISTINCT mhr.model_id AS user_id FROM roles r
LEFT JOIN model_has_roles mhr ON mhr.role_id = r.id
WHERE NAME LIKE "%Managing Director%"
AND mhr.model_id IS NOT NULL)temp1
LEFT JOIN users u ON u.id = temp1.user_id

UNION

# getting all the admins
SELECT u.email,u.id,u.mobile FROM(SELECT * FROM roles r
LEFT JOIN model_has_roles mhr ON mhr.role_id = r.id
WHERE r.name LIKE "%Admin") temp2
LEFT JOIN users u ON u.id = temp2.model_id WHERE u.mobile IS NOT NULL

)tempx
GROUP BY tempx.mobile, tempx.id
ORDER BY tempx.id;