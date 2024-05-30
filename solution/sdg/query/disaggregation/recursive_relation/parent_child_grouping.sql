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




