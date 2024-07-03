select dt.name prod_disagg_type,temp.disagg_name prod_disagg_name 
from (select dn.type_id ,idd.disagg_name from indicator_disagg_data idd 
left join disaggregation_name dn on dn.id = idd.disagg_id)temp
left join disaggregation_type dt on dt.id = temp.type_id