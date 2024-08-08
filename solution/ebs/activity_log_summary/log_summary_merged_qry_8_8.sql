SELECT u_id,user_name,employee_id,project_id,ProjectCode project_code,project_type,CONVERT(work_year,CHAR) work_year,work_month,CONVERT(MIN(work_dt),CHAR)'min_date',CONVERT(MAX(work_dt),CHAR)'max_date',COUNT(DISTINCT work_dt) days,
SUM(log_hour)log_hour,team_lead_id,team_lead,coordinator_id,coordinator,GROUP_CONCAT(Summary) summary 
FROM(SELECT u_id,user_name,employee_id,project_id,ProjectCode, project_type,work_year,work_month,work_dt,SUM(log_hour)log_hour,team_lead_id,team_lead,coordinator_id,coordinator,GROUP_CONCAT(Summary) summary
	FROM(SELECT resuorce.id u_id, IFNULL(CONCAT(resuorce.user_first_name,' ',resuorce.user_middle_name,' ',resuorce.user_last_name),'') user_name,
		resuorce.employee_id,p.id project_id, CASE WHEN pt.is_commercial=0 THEN 'Non-Commercial' WHEN pt.is_commercial=1 THEN 'Commercial' ELSE 'Production' END project_type,
		YEAR(work_dt) work_year,MONTH(work_dt) work_month,work_dt,team.id team_id,team_lead.id team_lead_id,
		IFNULL(CONCAT(team_lead.user_first_name,' ',team_lead.user_middle_name,' ',team_lead.user_last_name),'') Team_lead,
		u.id coordinator_id, IFNULL(CONCAT(u.user_first_name,' ',u.user_middle_name,' ',u.user_last_name),'') Coordinator,
		p.ref_no ProjectCode,resuorce.user_email Resource, FORMAT(TIME_TO_SEC(CONCAT(alog.work_duation,':00'))/60/60,2) log_hour,
		REPLACE(REPLACE(REPLACE(REPLACE(alog.description,'>',''),'-',''),'=',''),'\r\n',' ') Summary 
		FROM project_info p 
		LEFT JOIN project_milestone milestone ON p.id=milestone.project_id 
		LEFT JOIN crm_accounts ac ON p.account_id=ac.id 
		LEFT JOIN project_key_persons key_person ON p.id=key_person.project_id 
		AND key_person.key_person_type='Vendor' AND key_person.vendor_role='Project Coordination' 
		LEFT JOIN users u ON key_person.contact_id=u.id 
		LEFT JOIN project_activity_log alog  ON p.id=alog.project_id AND milestone.id=alog.milestone_id 
		LEFT JOIN project_task task ON alog.task_id=task.id
		LEFT JOIN users resuorce ON alog.created_by=resuorce.id 
		LEFT JOIN team_members tm ON resuorce .id=tm.user_id AND tm.status=1 
		LEFT JOIN team_info team ON tm.team_id=team.id
		LEFT JOIN users team_lead ON team.lead_id=team_lead.id
		LEFT JOIN project_types pt ON p.type=pt.name
		WHERE resuorce.user_status='active'
		AND alog.work_dt BETWEEN LAST_DAY(CURDATE() - INTERVAL 2 MONTH) + INTERVAL 1 DAY AND LAST_DAY(CURDATE() - INTERVAL 1 MONTH)
		GROUP BY alog.id
		UNION ALL
		SELECT resuorce.id u_id, IFNULL(CONCAT(resuorce.user_first_name,' ',resuorce.user_middle_name,' ',resuorce.user_last_name),'') user_name,
		resuorce.employee_id,p.id project_id, CASE WHEN pt.is_commercial=0 THEN 'Non-Commercial' WHEN pt.is_commercial=1 THEN 'Commercial' ELSE 'Production' END project_type,
		YEAR(work_dt) work_year,MONTH(work_dt) work_month,work_dt,team.id team_id, team_lead.id team_lead_id,
		IFNULL(CONCAT(team_lead.user_first_name,' ',team_lead.user_middle_name,' ',team_lead.user_last_name),'') Team_lead,
		u.id coordinator_id, IFNULL(CONCAT(u.user_first_name,' ',u.user_middle_name,' ',u.user_last_name),'') Coordinator,
		p.ref_no ProjectCode,resuorce.user_email Resource, alog.`hour_spent` log_hour,
		REPLACE(REPLACE(REPLACE(REPLACE(IF(alog.`issue_log_details` IS NULL OR alog.`issue_log_details`='',alog.`issue_details`,alog.`issue_log_details`),'>',''),'-',''),'=',''),'\r\n',' ') Summary
		FROM project_info p 
		LEFT JOIN project_milestone milestone ON p.id=milestone.project_id 
		LEFT JOIN crm_accounts ac ON p.account_id=ac.id 
		LEFT JOIN project_key_persons key_person ON p.id=key_person.project_id 
		AND key_person.key_person_type='Vendor' AND key_person.vendor_role='Project Coordination' 
		LEFT JOIN users u ON key_person.contact_id=u.id 
		LEFT JOIN `project_activity_log_clab` alog  ON milestone.`codelab_project_id`=alog.`codelab_project_id`  
		LEFT JOIN users resuorce ON alog.`user_email`=resuorce.`user_email` 
		LEFT JOIN team_members tm ON resuorce.id=tm.user_id AND tm.status=1 
		LEFT JOIN team_info team ON tm.team_id=team.id
		LEFT JOIN users team_lead ON team.lead_id=team_lead.id
		LEFT JOIN project_types pt ON p.type=pt.name
		WHERE resuorce.user_status='active' 
		AND alog.work_dt BETWEEN LAST_DAY(CURDATE() - INTERVAL 2 MONTH) + INTERVAL 1 DAY AND LAST_DAY(CURDATE() - INTERVAL 1 MONTH)
		AND alog.is_deleted=0
		GROUP BY alog.id)tmp
	GROUP BY employee_id,project_id,work_year,work_month,work_dt)tmp2
GROUP BY employee_id,project_id;


