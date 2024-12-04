
SELECT temp1.indicator_number,temp1.ind_id,temp1.source_name,temp1.id source_id,sg.title,
temp1.data_period,temp1.data_value,temp1.status,temp1.updated_at
FROM 
(SELECT sid.indicator_number,ind.ind_id,si.goal_id,ind.data_value,inds.name source_name,inds.id, 
ind.data_period,ind.status,ind.updated_at FROM indicator_data ind
LEFT JOIN `sdg-prod`.sdg_indicator_details sid ON sid.indicator_id = ind.ind_id AND sid.language_id = 1
LEFT JOIN `sdg-prod`.ind_sources inds ON inds.id = ind.source_id
LEFT JOIN sdg_indicators si ON si.id = ind.ind_id
WHERE sid.indicator_number IS NOT NULL 
-- AND sid.indicator_number = "1.1.1"
ORDER BY ind.ind_id, ind.data_period, ind.status)temp1
LEFT JOIN sdg_goals sg ON sg.id = temp1.goal_id

