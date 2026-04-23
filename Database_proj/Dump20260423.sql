CREATE DATABASE  IF NOT EXISTS `employee_management` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `employee_management`;
-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: localhost    Database: employee_management
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `attendance_id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int DEFAULT NULL,
  `attendance_date` date DEFAULT NULL,
  `check_in_time` time DEFAULT NULL,
  `check_out_time` time DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `remarks` text,
  PRIMARY KEY (`attendance_id`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO `attendance` VALUES (1,1,'2026-04-21','07:55:00','17:10:00','Present',NULL),(2,2,'2026-04-21','08:05:00','17:30:00','Present',NULL),(3,3,'2026-04-21','08:45:00','17:00:00','Late','Traffic jam'),(4,4,'2026-04-21','08:00:00','17:00:00','Present',NULL),(5,5,'2026-04-21',NULL,NULL,'Absent','Sick leave'),(6,1,'2026-04-22','07:58:00','17:05:00','Present',NULL),(7,2,'2026-04-22','08:02:00','17:00:00','Present',NULL),(8,3,'2026-04-22','08:00:00','17:00:00','Present',NULL),(9,4,'2026-04-22','08:00:00','17:00:00','Present',NULL),(10,5,'2026-04-22','08:15:00','17:00:00','Present',NULL),(11,1,'2026-04-23','07:50:00','18:00:00','Present',NULL),(12,2,'2026-04-23','08:00:00','17:00:00','Present',NULL),(13,3,'2026-04-23','09:10:00','17:00:00','Late','Overslept'),(14,4,'2026-04-23','08:00:00','17:00:00','Present',NULL),(15,6,'2026-04-23','08:00:00','17:00:00','Present',NULL);
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department` (
  `dept_id` int NOT NULL AUTO_INCREMENT,
  `dept_name` varchar(100) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `manager_id` int DEFAULT NULL,
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department`
--

LOCK TABLES `department` WRITE;
/*!40000 ALTER TABLE `department` DISABLE KEYS */;
INSERT INTO `department` VALUES (1,'Engineering','Floor 3 - Block A',1),(2,'Human Resources','Floor 1 - Block B',4),(3,'Finance','Floor 2 - Block B',6),(4,'Operations','Floor 4 - Block A',8);
/*!40000 ALTER TABLE `department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `hire_date` date NOT NULL,
  `position` varchar(100) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `dept_id` int DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `email` (`email`),
  KEY `dept_id` (`dept_id`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `department` (`dept_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES (1,'Nguyen','Van An','van.an@company.com','2021-03-15','Engineering Manager',1,1),(2,'Tran','Thi Bich','thi.bich@company.com','2022-01-10','Senior Developer',1,1),(3,'Le','Van Cuong','van.cuong@company.com','2022-06-20','Junior Developer',1,1),(4,'Pham','Thi Dung','thi.dung@company.com','2021-08-05','HR Manager',1,2),(5,'Hoang','Van Em','van.em@company.com','2023-02-14','HR Specialist',1,2),(6,'Vo','Thi Phuong','thi.phuong@company.com','2020-11-30','Finance Manager',1,3),(7,'Dang','Van Giang','van.giang@company.com','2023-07-01','Accountant',1,3),(8,'Bui','Thi Hoa','thi.hoa@company.com','2022-09-12','Operations Manager',1,4),(9,'Do','Van Hung','van.hung@company.com','2024-01-08','Operations Specialist',1,4),(10,'Ngo','Thi Lan','thi.lan@company.com','2021-05-22','QA Engineer',0,1);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_request`
--

DROP TABLE IF EXISTS `leave_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_request` (
  `leave_id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int DEFAULT NULL,
  `leave_type` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Pending',
  `reason` text,
  PRIMARY KEY (`leave_id`),
  KEY `employee_id` (`employee_id`),
  KEY `leave_type` (`leave_type`),
  CONSTRAINT `leave_request_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`),
  CONSTRAINT `leave_request_ibfk_2` FOREIGN KEY (`leave_type`) REFERENCES `leave_type` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_request`
--

LOCK TABLES `leave_request` WRITE;
/*!40000 ALTER TABLE `leave_request` DISABLE KEYS */;
INSERT INTO `leave_request` VALUES (1,3,2,'2026-04-21','2026-04-21','Approved','Fever, have doctor certificate'),(2,5,2,'2026-04-21','2026-04-22','Approved','Food poisoning'),(3,2,1,'2026-05-01','2026-05-03','Pending','Family trip'),(4,7,1,'2026-05-05','2026-05-09','Pending','Personal matters'),(5,1,4,'2026-06-15','2026-06-19','Rejected','Project deadline conflict'),(6,9,2,'2026-04-10','2026-04-11','Approved','Medical appointment');
/*!40000 ALTER TABLE `leave_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leave_type`
--

DROP TABLE IF EXISTS `leave_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `leave_type` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) DEFAULT NULL,
  `days_allowed` int DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leave_type`
--

LOCK TABLES `leave_type` WRITE;
/*!40000 ALTER TABLE `leave_type` DISABLE KEYS */;
INSERT INTO `leave_type` VALUES (1,'Annual Leave',12,'Paid annual leave per year'),(2,'Sick Leave',8,'Medical leave with doctor certificate'),(3,'Maternity Leave',90,'For female employees giving birth'),(4,'Unpaid Leave',30,'Leave without salary');
/*!40000 ALTER TABLE `leave_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift`
--

DROP TABLE IF EXISTS `shift`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift` (
  `shift_id` int NOT NULL AUTO_INCREMENT,
  `shift_name` varchar(50) DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `min_hours` int DEFAULT NULL,
  PRIMARY KEY (`shift_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift`
--

LOCK TABLES `shift` WRITE;
/*!40000 ALTER TABLE `shift` DISABLE KEYS */;
INSERT INTO `shift` VALUES (1,'Morning Shift','08:00:00','17:00:00',8),(2,'Evening Shift','13:00:00','22:00:00',8),(3,'Night Shift','22:00:00','06:00:00',8);
/*!40000 ALTER TABLE `shift` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `time_log`
--

DROP TABLE IF EXISTS `time_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `time_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `attendance_id` int DEFAULT NULL,
  `shift_id` int DEFAULT NULL,
  `actual_in` time DEFAULT NULL,
  `actual_out` time DEFAULT NULL,
  `hours_worked` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `attendance_id` (`attendance_id`),
  KEY `shift_id` (`shift_id`),
  CONSTRAINT `time_log_ibfk_1` FOREIGN KEY (`attendance_id`) REFERENCES `attendance` (`attendance_id`),
  CONSTRAINT `time_log_ibfk_2` FOREIGN KEY (`shift_id`) REFERENCES `shift` (`shift_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `time_log`
--

LOCK TABLES `time_log` WRITE;
/*!40000 ALTER TABLE `time_log` DISABLE KEYS */;
INSERT INTO `time_log` VALUES (1,1,1,'07:55:00','17:10:00',9.25),(2,2,1,'08:05:00','17:30:00',9.25),(3,3,1,'08:45:00','17:00:00',8.25),(4,4,1,'08:00:00','17:00:00',9.00),(5,6,1,'07:58:00','17:05:00',9.12),(6,7,1,'08:02:00','17:00:00',8.97),(7,8,1,'08:00:00','17:00:00',9.00),(8,9,1,'08:00:00','17:00:00',9.00),(9,10,1,'08:15:00','17:00:00',8.75),(10,11,1,'07:50:00','18:00:00',10.17),(11,12,1,'08:00:00','17:00:00',9.00),(12,13,1,'09:10:00','17:00:00',7.83),(13,14,1,'08:00:00','17:00:00',9.00),(14,15,1,'08:00:00','17:00:00',9.00);
/*!40000 ALTER TABLE `time_log` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-23 17:17:37
