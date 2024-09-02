# Step 1: Get the application id   
SELECT id FROM applications WHERE jomi_division_id <> 1 ORDER BY id LIMIT 1;

# Step 2: START TRANSACTION;

# Step 3: Set application id to delete all the data from child tables 

DELETE application_citizens, application_citizens_history, application_citizens_others,
application_desk_info, application_documents, application_documents_child,
application_draft_otp, application_land_schedule_doc_info, application_land_schedules,
application_metadata, application_mouja_mapping, application_other_documents,
application_reports, case_notices, case_orders, case_proposal_document_status,
case_proposal_ext, case_proposal_missing_infos, case_proposal_tofsil_status, 
case_proposals, case_status_updates, chalan_payment_responses, 
citizen_other_documents, dashboard_reporting_raw, dashboard_reporting_raw_log, 
dcr, desk_sla_info, khotian_batil, khotian_history, khotians, 
khotians_other_info, ld_tax_khotian_update_history, namonjur_order_application, 
namonjur_reopen_info, payment_chalan_hist, payments, payments_hist, 
proposal_missing_infos, reason_given_by_desk_user, 
payment_log, reconsideration_requests, reconsideration_requests_attachments,
short_fall_order, short_fall_order_second_gen, 
sonali_payment_responses, sunani_required_documents, validated_sub_reg_dolil_data, 
land_info_cloud_ref
FROM applications
LEFT JOIN application_citizens ON application_citizens.application_id = applications.id
LEFT JOIN application_citizens_history ON application_citizens_history.application_id = applications.id
LEFT JOIN application_citizens_others ON application_citizens_others.application_id = applications.id
LEFT JOIN application_desk_info ON application_desk_info.application_id = applications.id
LEFT JOIN application_documents ON application_documents.application_id = applications.id
LEFT JOIN application_documents_child ON application_documents_child.application_id = applications.id
LEFT JOIN application_draft_otp ON application_draft_otp.application_id = applications.id
LEFT JOIN application_land_schedule_doc_info ON application_land_schedule_doc_info.application_id = applications.id
LEFT JOIN application_land_schedules ON application_land_schedules.application_id = applications.id
LEFT JOIN application_metadata ON application_metadata.application_id = applications.id
LEFT JOIN application_mouja_mapping ON application_mouja_mapping.application_id = applications.id
LEFT JOIN application_other_documents ON application_other_documents.application_id = applications.id
LEFT JOIN application_reports ON application_reports.application_id = applications.id
LEFT JOIN case_notices ON case_notices.application_id = applications.id
LEFT JOIN case_orders ON case_orders.application_id = applications.id
LEFT JOIN case_proposal_document_status ON case_proposal_document_status.application_id = applications.id
LEFT JOIN case_proposal_ext ON case_proposal_ext.application_id = applications.id
LEFT JOIN case_proposal_missing_infos ON case_proposal_missing_infos.application_id = applications.id
LEFT JOIN case_proposal_tofsil_status ON case_proposal_tofsil_status.application_id = applications.id
LEFT JOIN case_proposals ON case_proposals.application_id = applications.id
LEFT JOIN case_status_updates ON case_status_updates.application_id = applications.id
LEFT JOIN chalan_payment_responses ON chalan_payment_responses.application_id = applications.id
LEFT JOIN citizen_other_documents ON citizen_other_documents.application_id = applications.id
LEFT JOIN dashboard_reporting_raw ON dashboard_reporting_raw.application_id = applications.id
LEFT JOIN dashboard_reporting_raw_log ON dashboard_reporting_raw_log.application_id = applications.id
LEFT JOIN dcr ON dcr.application_id = applications.id
LEFT JOIN desk_sla_info ON desk_sla_info.application_id = applications.id
LEFT JOIN khotian_batil ON khotian_batil.application_id = applications.id
LEFT JOIN khotian_history ON khotian_history.application_id = applications.id
LEFT JOIN khotians ON khotians.application_id = applications.id
LEFT JOIN khotians_other_info ON khotians_other_info.application_id = applications.id
LEFT JOIN ld_tax_khotian_update_history ON ld_tax_khotian_update_history.application_id = applications.id
LEFT JOIN namonjur_order_application ON namonjur_order_application.application_id = applications.id
LEFT JOIN namonjur_reopen_info ON namonjur_reopen_info.application_id = applications.id
LEFT JOIN payment_chalan_hist ON payment_chalan_hist.application_id = applications.id
LEFT JOIN payments ON payments.application_id = applications.id
LEFT JOIN payments_hist ON payments_hist.application_id = applications.id
LEFT JOIN proposal_missing_infos ON proposal_missing_infos.application_id = applications.id
LEFT JOIN reason_given_by_desk_user ON reason_given_by_desk_user.application_id = applications.id
LEFT JOIN payment_log ON payment_log.application_id = applications.id
LEFT JOIN reconsideration_requests ON reconsideration_requests.application_id = applications.id
LEFT JOIN reconsideration_requests_attachments ON reconsideration_requests_attachments.application_id = applications.id
LEFT JOIN short_fall_order ON short_fall_order.application_id = applications.id
LEFT JOIN short_fall_order_second_gen ON short_fall_order_second_gen.application_id = applications.id
LEFT JOIN sonali_payment_responses ON sonali_payment_responses.application_id = applications.id
LEFT JOIN sunani_required_documents ON sunani_required_documents.application_id = applications.id
LEFT JOIN validated_sub_reg_dolil_data ON validated_sub_reg_dolil_data.application_id = applications.id
LEFT JOIN land_info_cloud_ref ON land_info_cloud_ref.application_id = applications.id
WHERE applications.jomi_division_id <> 1 AND applications.id = ${id};

#Step 4: Delete the record from application table. 
#example added 


DELETE FROM applications WHERE id = ${id} AND jomi_division_id <> 1;

#Step 5: COMMIT;