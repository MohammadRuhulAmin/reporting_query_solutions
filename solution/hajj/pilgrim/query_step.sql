#Search Pilgrim By Voucher
SELECT * FROM PRP_DB.registration_voucher WHERE tracking_no = 'voucher_no_value' LIMIT 1

#IF voucher not exist start
SELECT COUNT(*) FROM PRP_DB.agency WHERE single_pilgrim_import = 1 AND id = 'user_sub_type_value';

#Getting data by voucher:
SELECT *
FROM pilgrims
LEFT JOIN PRP_DB.pilgrim_listing AS pl ON (pl.id = CASE WHEN pilgrims.re_reg_listing_id != 0 THEN pilgrims.re_reg_listing_id ELSE pilgrims.pilgrim_listing_id END)
LEFT JOIN PRP_DB.hajj_sessions AS hs ON (hs.id = pl.session_id)
WHERE pilgrims.voucher_col_name = $voucherInfo->id
AND pilgrims.is_archived = 0
AND pilgrims.is_registrable = 1
AND pilgrims.serial_no > 0
AND pilgrims.payment_status = 12
AND pilgrims.reg_payment_status = 12
AND pilgrims.will_not_perform = 0
AND hs.state = 'active'
AND transfer_id > 0
AND IF($voucherInfo->is_re_reg_voucher = 1, pilgrims.re_reg_payment_status = 12, 1);


#Save
#step-1 (collect voucher and package information)

SELECT PRP_DB.hajj_packages.pid_flag, PRP_DB.hajj_packages.package_ref_id, PRP_DB.registration_voucher.*
FROM PRP_DB.registration_voucher
LEFT JOIN PRP_DB.hajj_packages ON PRP_DB.registration_voucher.hajj_package_id = PRP_DB.hajj_packages.id
WHERE PRP_DB.registration_voucher.id IN (reg_voucher_id_1, reg_voucher_id_2, ..., reg_voucher_id_n);


