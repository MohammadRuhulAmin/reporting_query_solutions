SELECT cm.id, cm.caption AS SUBJECT, 
cm.agenda, cm.start_dt, 
cm.parent_type, 
cm.duration,CONCAT(u.user_first_name, ' ', u.user_middle_name, ' ', u.user_last_name) AS assigned_person_name, 
cm.location, cm.status, cm.description, cma.contact_type, cc.id, 
GROUP_CONCAT(cma.contact_id) AS attendees_ids,GROUP_CONCAT(cc.full_name) AS attendees, 
GROUP_CONCAT(cma.contact_type) AS attendees_contact_types,
cm.parent_id, 
cm.others_description, 
cm.outcome, cm.is_reminder, cm.reminder_time, 
cm.assigned_to,
ca.name AS accounts_name, 
cc1.full_name AS contact_name, cl.caption AS lead_name, cl.close_win_lost_dt,
cm.created_at, CONCAT(u2.user_first_name, ' ', u2.user_middle_name, ' ', u2.user_last_name) AS created_by_name,
cm.created_by, cm.updated_by, 
cm.updated_at
FROM crm_meeting cm
LEFT JOIN crm_meeting_attendees cma ON cma.meeting_id = cm.id
LEFT JOIN crm_contact cc ON cc.id = cma.contact_id 
LEFT JOIN users u ON u.id = cm.assigned_to
LEFT JOIN users u2 ON cm.created_by = u2.id 
LEFT JOIN crm_accounts ca ON ca.id = cm.parent_id AND cm.parent_type = 'Accounts'
LEFT JOIN crm_leads cl ON cl.id = cm.parent_id AND cm.parent_type = 'Leads/Opportunities'
LEFT JOIN crm_contact cc1 ON cc1.id = cm.parent_id AND cm.parent_type = 'Contact'
WHERE (cm.created_by = {$user_id} OR cm.assigned_to = {$user_id}) 
AND (
    CASE 
     WHEN '{$date}%'  != '{$end_date}%'   THEN cm.updated_at BETWEEN '{$date}%' AND '{$end_date}%'
   
     ELSE cm.updated_at >= '{$date}%'
    END
    )
GROUP BY  cm.id ORDER BY cm.updated_at DESC