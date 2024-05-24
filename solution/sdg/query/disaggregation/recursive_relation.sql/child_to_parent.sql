WITH RECURSIVE Ancestors AS (
    -- Anchor member: Select the initial row that starts the recursion (the given disaggregation_id)
    SELECT disaggregation_id, parent_id, NAME
    FROM sdg_disaggregation_langs
    WHERE disaggregation_id = 91  -- Replace 19 with the specific disaggregation_id you're interested in

    UNION ALL

    -- Recursive member: Select rows that are parents of the previously selected rows
    SELECT s.disaggregation_id, s.parent_id, s.name
    FROM sdg_disaggregation_langs s
    INNER JOIN Ancestors a ON s.disaggregation_id = a.parent_id
)
SELECT * FROM Ancestors;