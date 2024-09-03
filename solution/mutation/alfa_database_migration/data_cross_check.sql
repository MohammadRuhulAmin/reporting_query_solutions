SELECT 
applications.id,
 application_citizens.application_id AS application_citizens_id,
    application_citizens_history.application_id AS application_citizens_history_id,
    application_citizens_others.application_id AS application_citizens_others_id,
    application_desk_info.application_id AS application_desk_info_id,
    application_documents.application_id AS application_documents_id,
    application_documents_child.application_id AS application_documents_child_id,
    application_draft_otp.application_id AS application_draft_otp_id,
    application_land_schedule_doc_info.application_id AS application_land_schedule_doc_info_id,
    application_land_schedules.application_id AS application_land_schedules_id,
    application_metadata.application_id AS application_metadata_id,
    application_mouja_mapping.application_id AS application_mouja_mapping_id,
    application_other_documents.application_id AS application_other_documents_id,
    application_reports.application_id AS application_reports_id,
    case_notices.application_id AS case_notices_id,
    case_orders.application_id AS case_orders_id,
    case_proposal_document_status.application_id AS case_proposal_document_status_id,
    case_proposal_ext.application_id AS case_proposal_ext_id,
    case_proposal_missing_infos.application_id AS case_proposal_missing_infos_id,
    case_proposal_tofsil_status.application_id AS case_proposal_tofsil_status_id,
    case_proposals.application_id AS case_proposals_id,
    case_status_updates.application_id AS case_status_updates_id,
    chalan_payment_responses.application_id AS chalan_payment_responses_id,
    citizen_other_documents.application_id AS citizen_other_documents_id,
    dashboard_reporting_raw.application_id AS dashboard_reporting_raw_id,
    dashboard_reporting_raw_log.application_id AS dashboard_reporting_raw_log_id,
    dcr.application_id AS dcr_id,
    desk_sla_info.application_id AS desk_sla_info_id,
    khotian_batil.application_id AS khotian_batil_id,
    #khotian_comments.application_id AS khotian_comments_id,
    khotian_history.application_id AS khotian_history_id,
    khotians.application_id AS khotians_id,
    khotians_other_info.application_id AS khotians_other_info_id,
    ld_tax_khotian_update_history.application_id AS ld_tax_khotian_update_history_id,
    namonjur_order_application.application_id AS namonjur_order_application_id,
    namonjur_reopen_info.application_id AS namonjur_reopen_info_id,
    payment_chalan_hist.application_id AS payment_chalan_hist_id,
    payments.application_id AS payments_id,
    payments_hist.application_id AS payments_hist_id,
    proposal_missing_infos.application_id AS proposal_missing_infos_id,
    reason_given_by_desk_user.application_id AS reason_given_by_desk_user_id,
    #receive_khotian_info.application_id AS receive_khotian_info_id,
    payment_log.application_id AS payment_log_id,
    reconsideration_requests.application_id AS reconsideration_requests_id,
    reconsideration_requests_attachments.application_id AS reconsideration_requests_attachments_id,
    #reconsideration_requests_comments.application_id AS reconsideration_requests_comments_id,
    short_fall_order.application_id AS short_fall_order_id,
    short_fall_order_second_gen.application_id AS short_fall_order_second_gen_id,
    sonali_payment_responses.application_id AS sonali_payment_responses_id,
    sunani_required_documents.application_id AS sunani_required_documents_id,
    validated_sub_reg_dolil_data.application_id AS validated_sub_reg_dolil_data_id,
    land_info_cloud_ref.application_id AS land_info_cloud_ref_id
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
#LEFT JOIN khotian_comments ON khotian_comments.application_id = applications.id
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
#LEFT JOIN receive_khotian_info ON receive_khotian_info.application_id = applications.id
LEFT JOIN payment_log ON payment_log.application_id = applications.id
LEFT JOIN reconsideration_requests ON reconsideration_requests.application_id = applications.id
LEFT JOIN reconsideration_requests_attachments ON reconsideration_requests_attachments.application_id = applications.id
#LEFT JOIN reconsideration_requests_comments ON reconsideration_requests_comments.application_id = applications.id
LEFT JOIN short_fall_order ON short_fall_order.application_id = applications.id
LEFT JOIN short_fall_order_second_gen ON short_fall_order_second_gen.application_id = applications.id
LEFT JOIN sonali_payment_responses ON sonali_payment_responses.application_id = applications.id
LEFT JOIN sunani_required_documents ON sunani_required_documents.application_id = applications.id
LEFT JOIN validated_sub_reg_dolil_data ON validated_sub_reg_dolil_data.application_id = applications.id
LEFT JOIN land_info_cloud_ref ON land_info_cloud_ref.application_id = applications.id
WHERE applications.id = 1686030;