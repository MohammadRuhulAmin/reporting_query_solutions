select 
tfsl.application_id,
GROUP_CONCAT(`sensers_talika`)sensers_talika,
GROUP_CONCAT(`sensers_talika_cromik_no`)sensers_talika_cromik_no,
GROUP_CONCAT(`khatian_type`)khatian_type,
GROUP_CONCAT(`khatian_no`)khatian_no,
GROUP_CONCAT(`dag_no`) dag_no,
GROUP_CONCAT(`land_amount`)land_amount,
GROUP_CONCAT(`lijcreto_land_amount`)lijcreto_land_amount,
GROUP_CONCAT(`mot_dabir_poriman`)mot_dabir_poriman,
GROUP_CONCAT(`mot_dabir_poriman_value` )mot_dabir_poriman_value
from(SELECT ti.application_id,ti.`sensers_talika`,ti.`sensers_talika_cromik_no`,
tki.`khatian_type`,tki.`khatian_no`,tki.`dag_no`,tki.`land_amount`,tki.`lijcreto_land_amount`,
tki.`mot_dabir_poriman`,tki.`mot_dabir_poriman_value`
FROM tofsil_info ti
LEFT JOIN tofsil_khatian_info tki ON tki.tofsil_info_id = ti.id)tfsl
group by tfsl.application_id
order by tfsl.application_id