SELECT CONCAT('[',  
    (SELECT * FROM (SELECT GROUP_CONCAT(temp.user_id) id_list FROM                                          
        (SELECT DISTINCT user_id 
        FROM event_feed_tag_people 
        WHERE post_id = 'a40ba727-407c-4b96-ace6-2a5f68ed26fb')temp)temp2 
    ) ,  

']')AS id_list;