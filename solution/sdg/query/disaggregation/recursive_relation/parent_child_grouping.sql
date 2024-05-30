SET GLOBAL group_concat_max_len = 9999999;

SELECT GROUP_CONCAT(DISTINCT temp.parent_id) parent,GROUP_CONCAT( DISTINCT temp.disaggregation_id) child,
GROUP_CONCAT(DISTINCT temp.name) disaggregation_name
FROM (WITH RECURSIVE Descendants AS (
    -- Anchor member: Select the initial row(s) that start the recursion
    SELECT disaggregation_id, parent_id, NAME
    FROM sdg_disaggregation_langs
    WHERE parent_id IN(SELECT DISTINCT parent_id FROM sdg_disaggregation_langs)
    UNION ALL

    -- Recursive member: Select rows that are children of the previously selected rows
    SELECT s.disaggregation_id, s.parent_id, s.name
    FROM sdg_disaggregation_langs s
    INNER JOIN Descendants d ON s.parent_id = d.disaggregation_id
)
SELECT * FROM Descendants
GROUP BY disaggregation_id,parent_id,NAME
ORDER BY parent_id,disaggregation_id)temp
GROUP BY temp.parent_id;


#groping by source id 

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

