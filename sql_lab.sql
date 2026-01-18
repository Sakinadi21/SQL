-- =========================
-- DATABASE
-- =========================
CREATE DATABASE university_db;
USE university_db;

-- =========================
-- TABLES
-- =========================
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    contact VARCHAR(15) UNIQUE,
    status VARCHAR(20) DEFAULT 'Active',
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(50)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    marks DOUBLE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- =========================
-- INSERT DATA
-- =========================
INSERT INTO departments (department_name) VALUES
('CSE'), ('EEE'), ('BBA');

INSERT INTO students (name, contact, department_id) VALUES
('Rahim', '01711111111', 1),
('Karim', '01822222222', 1),
('Ayesha', '01933333333', 2);

INSERT INTO courses (course_name) VALUES
('DBMS'), ('OOP'), ('Networking');

INSERT INTO enrollments VALUES
(NULL,1,1,85),
(NULL,1,2,78),
(NULL,2,1,65),
(NULL,3,3,55);

-- =========================
-- ALTER
-- =========================
ALTER TABLE students ADD email VARCHAR(50);

-- =========================
-- AGGREGATE & GROUP
-- =========================
SELECT department_id, COUNT(*) AS total_students
FROM students
GROUP BY department_id;

-- =========================
-- JOINS
-- =========================
SELECT s.name, d.department_name
FROM students s
INNER JOIN departments d
ON s.department_id = d.department_id;

-- =========================
-- SUBQUERY
-- =========================
SELECT name
FROM students
WHERE student_id IN (
    SELECT student_id
    FROM enrollments
    WHERE marks >= 60
);

-- =========================
-- STRING FUNCTIONS
-- =========================
SELECT CONCAT(name, ' ABC') FROM students;
SELECT SUBSTRING('HELLO WORLD',1,5);
SELECT UPPER('sql lab');
SELECT CHAR_LENGTH('DATABASE');

-- =========================
-- DATE FUNCTIONS
-- =========================
SELECT CURDATE();
SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR);

-- =========================
-- VIEW
-- =========================
CREATE VIEW student_avg_marks AS
SELECT s.name, AVG(e.marks) AS avg_marks
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.name;

-- =========================
-- INDEX
-- =========================
CREATE INDEX idx_contact ON students(contact);

-- =========================
-- TRIGGER
-- =========================
CREATE DATABASE company_db;
USE company_db;

CREATE TABLE employee (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE salary_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_on DATETIME
);

DELIMITER $$

CREATE TRIGGER after_salary_update
AFTER UPDATE ON employee
FOR EACH ROW
BEGIN
    INSERT INTO salary_audit
    VALUES (NULL, OLD.emp_id, OLD.salary, NEW.salary, NOW());
END $$

DELIMITER ;
