WITH RECURSIVE ancestors AS (
  SELECT source_id, parent_id, NAME, 1 AS LEVEL
  FROM sdg_source_langs 
  WHERE source_id = 179 AND language_id = 1
  
  UNION ALL
 
  SELECT s.source_id, s.parent_id, s.name, a.level + 1 AS LEVEL
  FROM sdg_source_langs s
  INNER JOIN ancestors a ON s.source_id = a.parent_id AND s.language_id = 1
)
SELECT ROW_NUMBER() OVER (ORDER BY LEVEL) AS LEVEL, source_id, parent_id, NAME
FROM ancestors;