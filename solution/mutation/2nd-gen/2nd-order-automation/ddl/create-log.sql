CREATE TABLE `second_order_automation_process` (
  `id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `status` tinyint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `second_order_error_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `application_id` int NOT NULL,
  `error_status` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;