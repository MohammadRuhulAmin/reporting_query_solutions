START TRANSACTION;
SET autocommit = 0; # to set commit to 0 for inactivating auto commit mode 
INSERT INTO a(sname)VALUES("ruhul amin");
INSERT INTO b(sname)VALUES("mumtahina");
INSERT INTO c(sname)VALUES("aainun");
DELETE FROM a WHERE sname = "ruhul amin";
SET autocommit = 1; # to set commit to 1 for activating the auto commit mode 
COMMIT;
SELECT @@autocommit;
