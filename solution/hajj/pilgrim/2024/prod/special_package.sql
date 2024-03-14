SELECT * 
        FROM (SELECT p.id,p.tracking_no,p.reg_voucher_id,p.hajj_package_id,IFNULL(hp.base_package_id,r.hajj_package_id) base_package,
        CASE WHEN u.id=41994 THEN 26 ELSE u.district END district,CASE WHEN u.id=41994 THEN 64 ELSE dd.id END DistSort,
        CASE WHEN u.id=41994 THEN 'DHAKA' ELSE dd.district_name END district_name,
        r.confirmed_at,p.is_govt,hp.sessions_id,p.is_imported,p.gender,p.serial_no,IFNULL(user_type_desc,'General') RegSource
        FROM pilgrims p 
        LEFT JOIN `registration_voucher`r  ON r.id=p.reg_voucher_id
        LEFT JOIN hajj_packages hp ON hp.id=r.hajj_package_id
        LEFT JOIN users u ON p.reg_created_by=u.id
        LEFT JOIN draft_district dd ON u.district=dd.distraict_id
        WHERE  r.hajj_package_id IN(11096,11099,11102) AND p.is_govt='Government' AND p.payment_status= 12 AND p.reg_payment_status=12 AND p.is_archived=0  
        AND p.reg_voucher_id NOT IN ('224444','236398','244117')
        UNION ALL
        SELECT p.id,p.tracking_no,p.reg_voucher_id,p.hajj_package_id,IFNULL(hp.base_package_id,hp.id) BaseBackage,
                CASE WHEN u.id=41994 THEN 26 ELSE u.district END district,CASE WHEN u.id=41994 THEN 64 ELSE dd.id END DistSort,
        CASE WHEN u.id=41994 THEN 'DHAKA' ELSE dd.district_name END district_name,
        am.payment_confirm_at confirmed_at,
        p.is_govt,hp.sessions_id,p.is_imported,p.gender,p.serial_no,IFNULL(user_type_desc,'General') RegSource
        FROM pilgrims p 
        LEFT JOIN additional_payment_details ad ON p.tracking_no=ad.tracking_no
        LEFT JOIN  additional_payment_master am ON ad.master_id=am.id AND p.reg_voucher_id=am.reg_voucher_id 
        LEFT JOIN hajj_packages hp ON hp.id=am.package_id
        LEFT JOIN users u ON p.reg_created_by=u.id
        LEFT JOIN draft_district dd ON u.district=dd.distraict_id
        WHERE  am.package_id IN (11096,11099,11102) AND p.is_govt='Government' AND p.payment_status= 12 AND p.reg_payment_status=12 AND p.re_reg_payment_status=12 
        AND p.is_archived=0 AND p.reg_voucher_id NOT IN ('224444','236398','244117')) tmp 
        GROUP BY tracking_no 
        ORDER BY DistSort,RegSource,confirmed_at;