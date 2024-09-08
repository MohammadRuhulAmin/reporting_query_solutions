
STEP1: 
SELECT VALUE FROM configuration WHERE caption='AUTOMATIC_LISTING';

STEP2:
SELECT pl.is_govt,pl.id pilgrim_listing_id,enable_ehaj
FROM pilgrim_listing pl 
LEFT JOIN hajj_sessions hs ON pl.session_id=hs.id 
WHERE #listing_for='registration' AND 
hs.state='active' AND enable_ehaj=1;

STEP3:
SELECT p.is_govt,p.id,serial_no,pilgrim_listing_id 
FROM pilgrims p 
LEFT JOIN pre_reg_refund_details d ON p.id=d.pilgrim_id AND p.tracking_no=d.tracking_no
WHERE p.is_archived=0 AND p.is_registrable=0 AND p.deleted='0'
AND p.is_imported=0 AND p.payment_status=12 AND p.reg_payment_status=0
AND p.pilgrim_listing_id=0 AND d.tracking_no IS NULL;

STEP4:
UPDATE pilgrims SET pilgrim_listing_id = ${govt_pilgrim_listing_id} WHERE id = ${pilgrim_id} AND  is_govt = "Government";
UPDATE pilgrims SET pilgrim_listing_id = ${govt_pilgrim_listing_id} WHERE id = ${pilgrim_id} AND  is_govt = "Private";