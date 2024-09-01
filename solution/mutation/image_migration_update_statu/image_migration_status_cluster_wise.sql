# cluster 2
SELECT "barisal case_orders" table_name,COUNT(id) record FROM mutation_barisal.case_orders_reference_img WHERE path_transfer =1
UNION 
SELECT "chottogram case_orders" table_name,COUNT(id) record FROM mutation_chottogram.case_orders_reference_img WHERE path_transfer = 1
UNION 
SELECT "khulna case_orders" table_name, COUNT(id) record FROM mutation_khulna.case_orders_reference_img WHERE path_transfer = 1
UNION
SELECT "mymensingh case_orders" table_name, COUNT(id) record FROM mutation_mymensingh.case_orders_reference_img WHERE path_transfer = 1;


# cluster 1
SELECT "dhaka case_orders" table_name,COUNT(id) record FROM mutation_dhaka.case_orders_reference_img WHERE path_transfer =1
UNION 
SELECT "rajshahi case_orders" table_name,COUNT(id) record FROM mutation_rajshahi.case_orders_reference_img WHERE path_transfer = 1
UNION 
SELECT "rangpur case_orders" table_name, COUNT(id) record FROM mutation_rangpur.case_orders_reference_img WHERE path_transfer = 1
UNION
SELECT "sylhet case_orders" table_name, COUNT(id) record FROM mutation_sylhet.case_orders_reference_img WHERE path_transfer = 1