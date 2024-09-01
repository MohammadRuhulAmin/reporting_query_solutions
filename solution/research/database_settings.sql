SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

SET sql_mode = '';
SET GLOBAL group_concat_max_len = 9999999;

# to check auto commit status:
SELECT @@autocommit;
# SET AUTO COMMIT STATUS TO ZERO:
SET autocommit = 0;
