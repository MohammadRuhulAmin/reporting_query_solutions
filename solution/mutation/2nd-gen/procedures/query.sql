
#create sample error_order error log table 
CREATE TABLE second_order_error_log(
id INT AUTO_INCREMENT PRIMARY KEY,
application_id INT NOT NULL,
error_status VARCHAR(500)
);

#create a sample automation process table 
CREATE TABLE second_order_automation_process(
id INT AUTO_INCREMENT PRIMARY KEY,
application_id INT NOT NULL,
STATUS TINYINT(4)
);

# check if data found or not !
SELECT * FROM applications app WHERE 
app.form_type = 5 AND app.case_main_status_id IN(6,24) AND 
JSON_CONTAINS(app.users_tagged_receive,'["4"]');