SELECT sq1.agency,sq2.total_st1_dt data_entried_by_provider,sq3.total_st2_dt pending_for_approval_at_source,
sq4.total_st3_dt pending_for_authenticato_at_bbs,sq5.total_st4_dt published

FROM(SELECT tbl_agency.*,ids.ind_id,ids.source_id FROM
(SELECT ind_sources.id ind_src_id, office_agency_id,survey_id,office_agencies.name agency FROM ind_sources 
LEFT JOIN office_agencies ON office_agencies.id = ind_sources.office_agency_id 
WHERE ind_sources.office_agency_id > 0 
UNION
SELECT ind_sources.id, ministry_division_id,survey_id,ministry_divisions.name FROM ind_sources 
LEFT JOIN ministry_divisions ON ministry_divisions.id = ind_sources.ministry_division_id 
WHERE office_agency_id = 0 AND ministry_division_id > 0 
UNION
SELECT ind_sources.id, ministry_id,survey_id,ministries.name FROM ind_sources 
LEFT JOIN ministries ON ministries.id = ind_sources.ministry_id 
WHERE office_agency_id = 0 AND ministry_division_id = 0 AND ministry_id >0
UNION
SELECT ind_sources.id ind_src_id, ind_sources.survey_id,ind_sources.survey_id,`ind_data_source_survey`.name agency FROM ind_sources 
LEFT JOIN `ind_data_source_survey` ON `ind_data_source_survey`.id = ind_sources.survey_id 
WHERE ind_sources.ministry_id = 0 AND ind_sources.ministry_division_id = 0 AND ind_sources.office_agency_id = 0)tbl_agency
LEFT JOIN ind_data_source_survey idss ON idss.id = tbl_agency.survey_id
INNER JOIN ind_def_sources ids ON ids.source_id = tbl_agency.ind_src_id)sq1

LEFT JOIN 

(SELECT ind_data1.source_id,COUNT(id) total_st1_dt FROM indicator_data ind_data1
WHERE ind_data1.status = 1 GROUP BY ind_data1.source_id)sq2 ON sq2.source_id = sq1.source_id

LEFT JOIN 

(SELECT ind_data2.source_id,COUNT(id) total_st2_dt FROM indicator_data ind_data2
WHERE ind_data2.status = 2 GROUP BY ind_data2.source_id)sq3 ON sq3.source_id = sq1.source_id

LEFT JOIN 

(SELECT ind_data3.source_id,COUNT(id) total_st3_dt FROM indicator_data ind_data3
WHERE ind_data3.status = 3 GROUP BY ind_data3.source_id)sq4 ON sq4.source_id = sq1.source_id

LEFT JOIN

(SELECT ind_data4.source_id,COUNT(id) total_st4_dt FROM indicator_data ind_data4
WHERE ind_data4.status = 4 GROUP BY ind_data4.source_id)sq5 ON sq5.source_id = sq1.source_id;