insert into ind_def_disagg(ind_id,ind_def_id,disagg_type_id,disagg_id,disagg_name)
select ind_data.ind_id,ixd.id ind_def_id,dn.type_id disagg_type_id,#idd.ind_data_id,
idd.disagg_id,idd.disagg_name 
from indicator_disagg_data idd 
LEFT JOIN indicator_data ind_data ON ind_data.id = idd.ind_data_id
left join disaggregation_name dn on dn.id = idd.disagg_id
left join ind_definitions ixd on ixd.ind_id = ind_data.ind_id
where ind_data_id in(SELECT temp.ind_data_id FROM(SELECT ind_id,

GROUP_CONCAT(DISTINCT id) ind_data_id FROM indicator_data
GROUP BY ind_id)temp)
order by ind_data.ind_id;