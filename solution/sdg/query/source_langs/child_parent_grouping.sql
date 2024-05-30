#grouping  by source id 

WITH RECURSIVE ancestors AS (
  SELECT source_id, parent_id, NAME, source_id AS initial_source_id
  FROM sdg_source_langs 
  WHERE source_id IN (SELECT DISTINCT source_id FROM sdg_indicator_data WHERE  STATUS BETWEEN 3 AND 5) AND language_id = 1
  UNION ALL
  SELECT s.source_id, s.parent_id, s.name, a.initial_source_id
  FROM sdg_source_langs s
  INNER JOIN ancestors a ON s.source_id = a.parent_id AND s.language_id = 1
)
SELECT initial_source_id, 
       GROUP_CONCAT(DISTINCT parent_id ORDER BY parent_id) AS parent_id_list, 
       GROUP_CONCAT(NAME ORDER BY source_id) AS parent_to_child
       
FROM ancestors
GROUP BY initial_source_id;