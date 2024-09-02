CREATE TABLE Table1 (id int, ConditionID int);
CREATE TABLE Table2 (id int, ConditionID int);
CREATE TABLE Table3 (id int, ConditionID int);

INSERT INTO Table1 VALUES (1, 100);
INSERT INTO Table1 VALUES (2, 100);
INSERT INTO Table1 VALUES (3, 200);

INSERT INTO Table2 VALUES (1, 100);
INSERT INTO Table2 VALUES (2, 200);
INSERT INTO Table2 VALUES (3, 300);

INSERT INTO Table3 VALUES (1, 100);
INSERT INTO Table3 VALUES (2, 100);
INSERT INTO Table3 VALUES (3, 100);


# query to delete : 
DELETE Table1, Table2, Table3
FROM   Table1
JOIN   Table2 ON (Table2.ConditionID = Table1.ConditionID)
JOIN   Table3 ON (Table3.ConditionID = Table2.ConditionID)
WHERE  Table1.ConditionID = 100;