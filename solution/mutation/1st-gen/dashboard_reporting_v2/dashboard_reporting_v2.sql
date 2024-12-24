SELECT du.division_id,
du.district_id,du.district_name, du.id upazila_id,  du.name_bd upazila_name,temp.union_office_id,
temp.union_office_name, temp.total_application new_application,temp3.approved,temp3.disposed,temp3.app_dis_days,temp3.ULAO_days ulao_days,temp4.pending_application,
temp4.twenty_eight_days_pending,temp5.satisfied,temp5.total_feedback
FROM(SELECT a.upazila_id,oma.union_office_id,oma.union_office_name,COUNT(DISTINCT a.id) total_application
    FROM `mutation_chottogram`.`applications` a
    LEFT JOIN `mutation_chottogram`.`office_wise_mouja_assign` oma ON a.mouja_id=oma.mouja_id
    WHERE a.jomi_division_id=2 AND a.upazila_id=${upazila_id}
    AND a.case_main_status_id!=1
    AND a.created>DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    GROUP BY oma.union_office_id) temp
LEFT JOIN (SELECT temp2.union_office_id,
    SUM(IF(temp2.case_main_status_id IN (20,22),1,0)) approved,
    COUNT(temp2.id) disposed,
    SUM(temp2.DisposedDays)-SUM(temp2.short_fall_days) app_dis_days,
    SUM(temp2.ULAO_days) ULAO_days
    FROM (SELECT a.id,IF(a.case_main_status_id=39,drr.case_main_status_id,a.case_main_status_id) case_main_status_id,drr.union_office_id,DATEDIFF(drr.disposed_date,drr.receive_date) DisposedDays, a.short_fall_days,
   	 DATEDIFF(IF(drr.proposal_submit_date IS NULL,drr.report_submit_date,drr.proposal_submit_date),csu_first_order.created) ULAO_days
   	 FROM `mutation_chottogram`.`dashboard_reporting_raw` drr
   	 LEFT JOIN `mutation_chottogram`.`applications` a ON drr.application_id=a.id
   	 LEFT JOIN `mutation_chottogram`.`case_status_updates` csu_first_order ON csu_first_order.application_id=a.id AND csu_first_order.case_status_id=3
   	 LEFT JOIN `mutation_chottogram`.`office_wise_mouja_assign` oma ON a.mouja_id=oma.mouja_id
   	 WHERE a.jomi_division_id=2 AND a.upazila_id=${upazila_id}
   	 AND a.case_main_status_id IN (9,20,22,27,39) AND drr.disposed_date>DATE_SUB(CURDATE(), INTERVAL 30 DAY)
   	 GROUP BY drr.application_id)temp2
    GROUP BY temp2.union_office_id)temp3 ON temp3.union_office_id=temp.union_office_id
LEFT JOIN (SELECT oma.union_office_id,
    COUNT(DISTINCT a.id) pending_application,
    SUM(IF(DATEDIFF(CURDATE(),a.created)>28,1,0)) twenty_eight_days_pending
    FROM `mutation_chottogram`.`applications` a
    LEFT JOIN `mutation_chottogram`.`office_wise_mouja_assign` oma ON a.mouja_id=oma.mouja_id AND oma.upazila_id=a.upazila_id
    WHERE a.jomi_division_id=2 AND a.upazila_id=${upazila_id}
    AND a.case_main_status_id NOT IN (1,9,20,22,27,31,39)
    GROUP BY oma.union_office_id)temp4 ON temp4.union_office_id=temp.union_office_id
LEFT JOIN (SELECT drr.union_office_id,
    SUM(IF(fbac.service_rating='1.00',1,0)) satisfied,
    COUNT(DISTINCT fbac.id) total_feedback
    FROM `mutation_chottogram`.`disposed_feedback_gplex` fbac
    LEFT JOIN `mutation_chottogram`.`dashboard_reporting_raw` drr ON fbac.application_id=drr.application_id
    WHERE division_id=2 AND fbac.upazila_id=${upazila_id} AND fbac.df_receive_from_gplex_time>DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    GROUP BY drr.union_office_id) temp5 ON temp5.union_office_id=temp.union_office_id
LEFT JOIN `mutation_chottogram`.`dglr_upazilas` du ON temp.upazila_id=du.id
ORDER BY du.district_id,du.id,temp.union_office_id;
