SELECT
SUM(ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2)) AS "SIZE IN MB"
FROM INFORMATION_SCHEMA.TABLES
WHERE
TABLE_SCHEMA = "sdg_v1_v2_live";


# table name, in mb, in gb

SELECT 
    TABLE_NAME,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS "SIZE IN MB",
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024 / 1024, 2) AS "SIZE IN GB"
FROM 
    INFORMATION_SCHEMA.TABLES 
WHERE 
    TABLE_SCHEMA = 'prpdb_prod'
ORDER BY 
    TABLE_NAME;

# check if a column is exist of not in all tables of a database:

SELECT t.table_name
FROM information_schema.tables t
WHERE t.table_schema = 'mutation_barisal'
  AND t.table_name NOT IN (
    SELECT DISTINCT TABLE_NAME
    FROM information_schema.columns
    WHERE table_schema = 'mutation_barisal'
      AND COLUMN_NAME = 'division_id'
  )
  AND t.table_type = 'BASE TABLE';
