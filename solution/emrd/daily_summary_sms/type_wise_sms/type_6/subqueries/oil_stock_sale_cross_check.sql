SELECT stock_sale.id,stock_sale.stock_s_nm org_short_name,
CASE WHEN stock_sale.stock_org_id IS NULL AND stock_sale.sale_org_id IS NULL THEN NULL
ELSE stock_sale.stock_org_id END AS org_id FROM
(SELECT oil_stock_family.*,oil_sale_family.* FROM
(SELECT DISTINCT oi.id , oi.org_short_name stock_s_nm,ost.org_id  stock_org_id FROM organization_info oi
LEFT JOIN oil_stock ost ON ost.org_id = oi.id
AND ost.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (22,23, 24, 25,26,27, 28))oil_stock_family
LEFT JOIN 
(SELECT DISTINCT  oi.org_short_name sale_s_nm ,osa.org_id sale_org_id FROM organization_info oi
LEFT JOIN oil_sale osa ON osa.org_id = oi.id
AND osa.report_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE oi.id IN (22, 23, 24, 25, 26, 27, 28))oil_sale_family
ON oil_stock_family.stock_s_nm = oil_sale_family.sale_s_nm)stock_sale;