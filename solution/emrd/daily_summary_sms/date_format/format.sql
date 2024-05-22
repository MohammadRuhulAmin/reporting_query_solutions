# Format:  15 April 2024
SELECT DATE_FORMAT(DATE_SUB(CURDATE(),INTERVAL 1 DAY), '%d %M %Y') yesterday;

#Format : 15/05/2024
SELECT DATE_FORMAT(NOW(), '%d/%m/%Y')