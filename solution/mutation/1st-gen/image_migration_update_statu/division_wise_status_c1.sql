SELECT (SELECT "mutation_rangpur") database_name,(SELECT "khotian_comments") table_name,(SELECT COUNT(id) FROM mutation_rangpur.khotian_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_rangpur.khotian_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_rangpur") database_name,(SELECT "case_orders") table_name,(SELECT COUNT(id) FROM mutation_rangpur.case_orders_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_rangpur.case_orders_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_rangpur") database_name,(SELECT "case_proposals") table_name,(SELECT COUNT(id) FROM mutation_rangpur.case_proposals_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_rangpur.case_proposals_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_rangpur") database_name,(SELECT "case_proposal_comments") table_name,(SELECT COUNT(id) FROM mutation_rangpur.case_proposal_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_rangpur.case_proposal_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "khotian_comments") table_name,(SELECT COUNT(id) FROM mutation_sylhet.khotian_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.khotian_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_orders") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_orders_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_orders_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_proposals") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_proposals_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_proposals_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_proposal_comments") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_proposal_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_proposal_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "khotian_comments") table_name,(SELECT COUNT(id) FROM mutation_sylhet.khotian_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.khotian_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_orders") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_orders_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_orders_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_proposals") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_proposals_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_proposals_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_proposal_comments") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_proposal_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_proposal_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "khotian_comments") table_name,(SELECT COUNT(id) FROM mutation_sylhet.khotian_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.khotian_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_orders") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_orders_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_orders_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_proposals") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_proposals_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_proposals_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_sylhet") database_name,(SELECT "case_proposal_comments") table_name,(SELECT COUNT(id) FROM mutation_sylhet.case_proposal_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_sylhet.case_proposal_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_dhaka") database_name,(SELECT "khotian_comments") table_name,(SELECT COUNT(id) FROM mutation_dhaka.khotian_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_dhaka.khotian_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_dhaka") database_name,(SELECT "case_orders") table_name,(SELECT COUNT(id) FROM mutation_dhaka.case_orders_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_dhaka.case_orders_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_dhaka") database_name,(SELECT "case_proposals") table_name,(SELECT COUNT(id) FROM mutation_dhaka.case_proposals_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_dhaka.case_proposals_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_dhaka") database_name,(SELECT "case_proposal_comments") table_name,(SELECT COUNT(id) FROM mutation_dhaka.case_proposal_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_dhaka.case_proposal_comments_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_rajshahi") database_name,(SELECT "case_orders") table_name,(SELECT COUNT(id) FROM mutation_rajshahi.case_orders_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_rajshahi.case_orders_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_rajshahi") database_name,(SELECT "case_proposals") table_name,(SELECT COUNT(id) FROM mutation_rajshahi.case_proposals_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_rajshahi.case_proposals_reference_img WHERE path_transfer = 1) total_path_update
UNION
SELECT (SELECT "mutation_rajshahi") database_name,(SELECT "case_proposal_comments") table_name,(SELECT COUNT(id) FROM mutation_rajshahi.case_proposal_comments_reference_img WHERE is_corrupted !=1) total_image_path,(SELECT COUNT(id) FROM mutation_rajshahi.case_proposal_comments_reference_img WHERE path_transfer = 1) total_path_update




