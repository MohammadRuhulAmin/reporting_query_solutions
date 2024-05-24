WITH RECURSIVE Descendants AS (
    -- Anchor member: Select the initial row(s) that start the recursion
    SELECT disaggregation_id, parent_id, NAME
    FROM sdg_disaggregation_langs
    WHERE parent_id = 19
    UNION ALL
    -- Recursive member: Select rows that are children of the previously selected rows
    SELECT s.disaggregation_id, s.parent_id, s.name
    FROM sdg_disaggregation_langs s
    INNER JOIN Descendants d ON s.parent_id = d.disaggregation_id
)
SELECT *
FROM Descendants;

# Tutorial link 
# https://www.youtube.com/watch?v=gn7qLNR-wkg 
