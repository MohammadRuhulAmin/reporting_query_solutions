#To ignore the same record while inserting using insert command
#step1: first we have to specify the column name to be unique 
#or ALTER TABLE temp ADD CONSTRAINT unique_name_email UNIQUE (NAME, email);
#step2: then execute the insert ignore command 

CREATE TABLE  temp (
    id INT AUTO_INCREMENT PRIMARY KEY,
    NAME VARCHAR(255),
    email VARCHAR(255),
    UNIQUE (NAME, email)
);

INSERT IGNORE INTO temp(NAME,email)
VALUES('ruhul','r@gmail.com'),('ruhul','r@gmail.com'),('ruhul','r@gmail.com');