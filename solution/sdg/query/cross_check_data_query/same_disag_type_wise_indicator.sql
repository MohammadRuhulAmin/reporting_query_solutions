SELECT sid.indicator_number,inds.name source_name, ind.data_period,temp1.*,ind.ind_id FROM
(SELECT dn.name disagg_name,dt.name type_name,idd.disagg_id,idd.ind_data_id FROM disaggregation_name dn 
INNER JOIN disaggregation_type dt ON dt.name = dn.name
LEFT JOIN indicator_disagg_data idd ON idd.disagg_id = dn.id)temp1
LEFT JOIN indicator_data ind ON  ind.id = temp1.ind_data_id 
LEFT JOIN sdg_indicator_details sid ON sid.indicator_id = ind.ind_id AND sid.language_id = 1
LEFT JOIN ind_sources inds ON inds.id = ind.source_id
WHERE sid.indicator_number IS NOT NULL 
ORDER BY ind.ind_id;
