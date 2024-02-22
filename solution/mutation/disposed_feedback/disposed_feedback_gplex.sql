SELECT id,application_id,division_id,district_id,upazila_id,order_id,
start_time df_start_time,STATUS df_status,duration df_duration,num_try df_num_try,service_rating,
0 is_disposed,1 sent_disposed_status,sent_to_gplex_time df_sent_to_gplex_time,receive_from_gplex_time df_receive_from_gplex_time,
is_archived,created_at,created_by,updated_at,updated_by
FROM mutation_ext.feedback_from_gplex_ext  
WHERE ${Condition} AND division_id=1 AND tag_id=4 AND service_rating>0
ORDER BY id LIMIT 50;