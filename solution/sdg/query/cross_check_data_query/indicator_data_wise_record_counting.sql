SELECT sil.serial_no,sid.indicator_id,GROUP_CONCAT(DISTINCT sid.id) AS indicator_data_id,
COUNT(sid.indicator_id) AS parent_data,COUNT(sidc.id) AS child_data
FROM sdg_indicator_data sid
LEFT JOIN sdg_indicator_data_children sidc ON sid.id = sidc.indicator_data_id
LEFT JOIN sdg_indicator_langs sil ON sil.indicator_id = sid.indicator_id AND sil.language_id = 1
GROUP BY sid.indicator_id,sil.serial_no;