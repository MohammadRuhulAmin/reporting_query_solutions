

#step-1:
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
AND IF($voucherInfo->is_re_reg_voucher = 1, pilgrims.re_reg_payment_status = 12, 1)
