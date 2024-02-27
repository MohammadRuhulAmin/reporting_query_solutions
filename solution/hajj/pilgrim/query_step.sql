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

#step-2 (Collect pid_flag, its need to add in unitMaster)
#condition if package_ref_id > 0

SELECT pid_flag FROM PRP_DB.hajj_packages
WHERE id = package_ref_id;

#step-3 (Collect all pilgrims regarding voucher)
SELECT pilgrims.*, hs.id AS session_id, hs.caption AS session_value, hs.hijri
FROM pilgrims
LEFT JOIN PRP_DB.pilgrim_listing AS pl ON pl.id = pilgrims.pilgrim_listing_id
LEFT JOIN PRP_DB.hajj_sessions AS hs ON hs.id = pl.session_id
WHERE colName IN (voucher_id_1, voucher_id_2, ..., voucher_id_n)
AND pilgrims.is_archived = 0
AND pilgrims.is_registrable = 1
AND pilgrims.serial_no > 0
AND pilgrims.will_not_perform = 0
AND pilgrims.payment_status = 12
AND pilgrims.reg_payment_status = 12
AND (colName <> 're_reg_voucher_id' OR pilgrims.re_reg_payment_status = 12);

#step-5  
SELECT pilgrims.*, hs.id AS session_id, hs.caption AS session_value, hs.hijri
FROM pilgrims
LEFT JOIN hmis_pilgrims ON hmis_pilgrims.ref_pilgrim_id = pilgrims.id
LEFT JOIN PRP_DB.pilgrim_listing AS pl ON (pl.id = CASE WHEN pilgrims.re_reg_listing_id != 0 THEN pilgrims.re_reg_listing_id ELSE pilgrims.pilgrim_listing_id END)
LEFT JOIN PRP_DB.hajj_sessions AS hs ON (hs.id = pl.session_id)
WHERE pilgrims.colName IN (voucher_id_1, voucher_id_2, ..., voucher_id_n)
AND hmis_pilgrims.session_id = 'active_session_id_value'
AND pilgrims.is_archived = 0
AND pilgrims.is_registrable = 1
AND pilgrims.serial_no > 0
AND pilgrims.will_not_perform = 0
AND pilgrims.payment_status = 12
AND pilgrims.reg_payment_status = 12
AND hs.state = 'active'
AND (colName <> 're_reg_voucher_id' OR pilgrims.re_reg_payment_status = 12)
AND pilgrims.is_imported = 0
AND hmis_pilgrims.pid IS NULL
ORDER BY pilgrims.serial_no ASC;

#step-7
SELECT *
FROM HmisPilgrimUnitMaster
WHERE voucher_id IN (voucher_id_1, voucher_id_2, ..., voucher_id_n)
LIMIT 1;


#step-8
SELECT *
FROM HmisPilgrimUnitMaster
WHERE agency_id = 0
AND package_id = (
    CASE 
        WHEN is_p2g = 1 THEN package_ref_id
        ELSE (SELECT hajj_package_id FROM vouchers_info LIMIT 1)
    END
)
AND is_govt = 'Government'
AND serial_no = SUBSTRING(CONCAT('0000', pre_unit_no), -4);



#step-10

UPDATE crm
LEFT JOIN crm_to_do ON crm.id = crm_to_do.ref_crm_id
SET crm.session_id = active_session_id_value,
    crm_to_do.session_id = active_session_id_value
WHERE crm.tracking_no IN ('tracking_no_1', 'tracking_no_2', ..., 'tracking_no_n');

#step-12
insert data 

#step-13
fetch some data








