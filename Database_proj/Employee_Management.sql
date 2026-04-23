CREATE DATABASE employee_management;
USE employee_management;

-- 1. DEPARTMENT
CREATE TABLE DEPARTMENT (
  dept_id INT PRIMARY KEY AUTO_INCREMENT,
  dept_name VARCHAR(100) NOT NULL,
  location VARCHAR(100),
  manager_id INT
);

-- 2. EMPLOYEE
CREATE TABLE EMPLOYEE (
  employee_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  hire_date DATE NOT NULL,
  position VARCHAR(100),
  is_active BOOLEAN DEFAULT TRUE,
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES DEPARTMENT(dept_id)
);

-- 3. SHIFT
CREATE TABLE SHIFT (
  shift_id INT PRIMARY KEY AUTO_INCREMENT,
  shift_name VARCHAR(50),
  start_time TIME,
  end_time TIME,
  min_hours INT
);

-- 4. LEAVE_TYPE
CREATE TABLE LEAVE_TYPE (
  type_id INT PRIMARY KEY AUTO_INCREMENT,
  type_name VARCHAR(50),
  days_allowed INT,
  description TEXT
);

-- 5. ATTENDANCE
CREATE TABLE ATTENDANCE (
  attendance_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_id INT,
  attendance_date DATE,
  check_in_time TIME,
  check_out_time TIME,
  status VARCHAR(20),
  remarks TEXT,
  FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id)
);

-- 6. TIME_LOG
CREATE TABLE TIME_LOG (
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  attendance_id INT,
  shift_id INT,
  actual_in TIME,
  actual_out TIME,
  hours_worked DECIMAL(4,2),
  FOREIGN KEY (attendance_id) REFERENCES ATTENDANCE(attendance_id),
  FOREIGN KEY (shift_id) REFERENCES SHIFT(shift_id)
);

-- 7. LEAVE_REQUEST
CREATE TABLE LEAVE_REQUEST (
  leave_id INT PRIMARY KEY AUTO_INCREMENT,
  employee_id INT,
  leave_type INT,
  start_date DATE,
  end_date DATE,
  status VARCHAR(20) DEFAULT 'Pending',
  reason TEXT,
  FOREIGN KEY (employee_id) REFERENCES EMPLOYEE(employee_id),
  FOREIGN KEY (leave_type) REFERENCES LEAVE_TYPE(type_id)
);