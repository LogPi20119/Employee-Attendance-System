-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;


-- -----------------------------------------------------
-- Table `mydb`.`Department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Department` (
  `dept_id` INT NOT NULL AUTO_INCREMENT,
  `dept_name` VARCHAR(100) NOT NULL,
  `location` VARCHAR(100) NULL,
  `manager_id` INT NULL,
  PRIMARY KEY (`dept_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`EMPLOYEE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`EMPLOYEE` (
  `employee_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `hire_date` DATE NOT NULL,
  `position` VARCHAR(100) NULL,
  `is_active` TINYINT(1) NULL DEFAULT 1,
  `dept_id` INT NULL,
  `Department_dept_id` INT NOT NULL,
  `Department_dept_id1` INT NOT NULL,
  PRIMARY KEY (`employee_id`, `Department_dept_id`),
  INDEX `fk_EMPLOYEE_Department1_idx` (`Department_dept_id1` ASC) VISIBLE,
  CONSTRAINT `fk_EMPLOYEE_Department1`
    FOREIGN KEY (`Department_dept_id1`)
    REFERENCES `mydb`.`Department` (`dept_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Attendance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Attendance` (
  `attendance_id` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `attendance_date` DATE NOT NULL,
  `check_in_time` TIME NULL,
  `status` VARCHAR(20) NULL,
  `remarks` TEXT NULL,
  `EMPLOYEE_employee_id` INT NOT NULL,
  `EMPLOYEE_Department_dept_id` INT NOT NULL,
  `EMPLOYEE_employee_id1` INT NOT NULL,
  `EMPLOYEE_Department_dept_id1` INT NOT NULL,
  PRIMARY KEY (`attendance_id`, `EMPLOYEE_employee_id`, `EMPLOYEE_Department_dept_id`),
  INDEX `fk_Attendance_EMPLOYEE1_idx` (`EMPLOYEE_employee_id1` ASC, `EMPLOYEE_Department_dept_id1` ASC) VISIBLE,
  CONSTRAINT `fk_Attendance_EMPLOYEE1`
    FOREIGN KEY (`EMPLOYEE_employee_id1` , `EMPLOYEE_Department_dept_id1`)
    REFERENCES `mydb`.`EMPLOYEE` (`employee_id` , `Department_dept_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Shift`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Shift` (
  `shift_id` INT NOT NULL AUTO_INCREMENT,
  `shift_name` VARCHAR(50) NOT NULL,
  `start_time` TIME NULL,
  `end_time` TIME NULL,
  `min_hours` INT NULL,
  PRIMARY KEY (`shift_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Time_Log`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Time_Log` (
  `log_id` INT NOT NULL AUTO_INCREMENT,
  `attendance_id` INT NOT NULL,
  `shift_id` INT NOT NULL,
  `actual_in` TIME NULL,
  `actual_out` TIME NULL,
  `hours_worked` DECIMAL(4,2) NULL,
  `Attendance_attendance_id` INT NOT NULL,
  `Attendance_EMPLOYEE_employee_id` INT NOT NULL,
  `Attendance_EMPLOYEE_Department_dept_id` INT NOT NULL,
  `Shift_shift_id` INT NOT NULL,
  PRIMARY KEY (`log_id`),
  INDEX `fk_Time_Log_Attendance1_idx` (`Attendance_attendance_id` ASC, `Attendance_EMPLOYEE_employee_id` ASC, `Attendance_EMPLOYEE_Department_dept_id` ASC) VISIBLE,
  INDEX `fk_Time_Log_Shift1_idx` (`Shift_shift_id` ASC) VISIBLE,
  CONSTRAINT `fk_Time_Log_Attendance1`
    FOREIGN KEY (`Attendance_attendance_id` , `Attendance_EMPLOYEE_employee_id` , `Attendance_EMPLOYEE_Department_dept_id`)
    REFERENCES `mydb`.`Attendance` (`attendance_id` , `EMPLOYEE_employee_id` , `EMPLOYEE_Department_dept_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Time_Log_Shift1`
    FOREIGN KEY (`Shift_shift_id`)
    REFERENCES `mydb`.`Shift` (`shift_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Leave_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Leave_type` (
  `type_id` INT NOT NULL AUTO_INCREMENT,
  `type_name` VARCHAR(50) NOT NULL,
  `days_allowed` INT NULL,
  `description` TEXT NULL,
  PRIMARY KEY (`type_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Leave_request`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Leave_request` (
  `leave_id` INT NOT NULL AUTO_INCREMENT,
  `employee_id` INT NOT NULL,
  `leave_type` INT NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `status` VARCHAR(20) NULL,
  `reason` TEXT NULL,
  `EMPLOYEE_employee_id` INT NOT NULL,
  `EMPLOYEE_Department_dept_id` INT NOT NULL,
  `Leave_type_type_id` INT NOT NULL,
  PRIMARY KEY (`leave_id`),
  INDEX `fk_Leave_request_EMPLOYEE1_idx` (`EMPLOYEE_employee_id` ASC, `EMPLOYEE_Department_dept_id` ASC) VISIBLE,
  INDEX `fk_Leave_request_Leave_type1_idx` (`Leave_type_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_Leave_request_EMPLOYEE1`
    FOREIGN KEY (`EMPLOYEE_employee_id` , `EMPLOYEE_Department_dept_id`)
    REFERENCES `mydb`.`EMPLOYEE` (`employee_id` , `Department_dept_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Leave_request_Leave_type1`
    FOREIGN KEY (`Leave_type_type_id`)
    REFERENCES `mydb`.`Leave_type` (`type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
