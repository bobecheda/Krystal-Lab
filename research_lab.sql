/*
 * Research Lab Database Schema
 * Version: 1.0
 * Description: Database schema for managing research laboratory operations,
 *              including departments, employees, projects, and equipment.
 * Author: Bobe Cheda
 * Last Update: 5/9/2025
 */

-- Create Database
CREATE DATABASE IF NOT EXISTS research_lab;
USE research_lab;

-- Department Table
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    hod_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE NOT NULL,
    position VARCHAR(100) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Management Table
CREATE TABLE management (
    management_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    role VARCHAR(100) NOT NULL,
    responsibilities TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Laboratory Table
CREATE TABLE laboratories (
    lab_id INT PRIMARY KEY AUTO_INCREMENT,
    lab_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Equipment Table
CREATE TABLE equipment (
    equipment_id INT PRIMARY KEY AUTO_INCREMENT,
    equipment_name VARCHAR(100) NOT NULL,
    model_number VARCHAR(50),
    purchase_date DATE,
    last_maintenance_date DATE,
    lab_id INT,
    status ENUM('Available', 'In Use', 'Maintenance', 'Retired') NOT NULL,
    FOREIGN KEY (lab_id) REFERENCES laboratories(lab_id)
);

-- Researchers Table
CREATE TABLE researchers (
    researcher_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    qualification VARCHAR(100) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Projects Table
CREATE TABLE projects (
    project_id INT PRIMARY KEY AUTO_INCREMENT,
    project_name VARCHAR(200) NOT NULL UNIQUE,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('Planning', 'Active', 'Completed', 'On Hold') NOT NULL,
    budget DECIMAL(15, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Samples Table
CREATE TABLE samples (
    sample_id INT PRIMARY KEY AUTO_INCREMENT,
    sample_name VARCHAR(100) NOT NULL,
    description TEXT,
    collection_date DATE NOT NULL,
    storage_location VARCHAR(100),
    project_id INT,
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('Admin', 'Researcher', 'Staff', 'Guest') NOT NULL,
    employee_id INT,
    last_login TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- Publications Table
CREATE TABLE publications (
    publication_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    authors TEXT NOT NULL,
    publication_date DATE NOT NULL,
    journal_name VARCHAR(200),
    doi VARCHAR(100) UNIQUE,
    citation_count INT DEFAULT 0
);

-- Collaborations Table
CREATE TABLE collaborations (
    collaboration_id INT PRIMARY KEY AUTO_INCREMENT,
    institution_name VARCHAR(200) NOT NULL,
    contact_person VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status ENUM('Active', 'Completed', 'Suspended') NOT NULL
);

-- Project Researchers (Junction Table)
CREATE TABLE project_researchers (
    project_id INT,
    researcher_id INT,
    role VARCHAR(100) NOT NULL,
    join_date DATE NOT NULL,
    PRIMARY KEY (project_id, researcher_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (researcher_id) REFERENCES researchers(researcher_id)
);

-- Project Collaborations (Junction Table)
CREATE TABLE project_collaborations (
    project_id INT,
    collaboration_id INT,
    contribution_type VARCHAR(100) NOT NULL,
    PRIMARY KEY (project_id, collaboration_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id),
    FOREIGN KEY (collaboration_id) REFERENCES collaborations(collaboration_id)
);

-- Collaboration Publications (Junction Table)
CREATE TABLE collaboration_publications (
    collaboration_id INT,
    publication_id INT,
    PRIMARY KEY (collaboration_id, publication_id),
    FOREIGN KEY (collaboration_id) REFERENCES collaborations(collaboration_id),
    FOREIGN KEY (publication_id) REFERENCES publications(publication_id)
);

-- Sample Data

-- Departments
INSERT INTO departments (department_name, hod_name) VALUES
('Biotechnology', 'Dr. Bobe Cheda'),
('Chemistry', 'Dr. Michael Chen'),
('Physics', 'Dr. Robert Wilson');

-- Employees
INSERT INTO employees ( employee_id, first_name, last_name, email, phone, department_id, hire_date, position) VALUES
(1, 'Ramadhan', 'cheda', 'ramadhan.cheda@lab.com', '555-0101', 1, '2020-01-15', 'Admin'),
(2, 'Emma', 'Davis', 'emma.davis@lab.com', '555-0102', 2, '2019-03-20', 'Lab Manager'),
(3, 'David', 'Brown', 'david.brown@lab.com', '555-0103', 3, '2021-02-10', 'Research Assistant');

-- Management
INSERT INTO management (employee_id, role, responsibilities) VALUES
(1, 'Research Director', 'Overall research strategy and team management'),
(2, 'Lab Operations Manager', 'Equipment maintenance and lab safety');

-- Laboratories
INSERT INTO laboratories (lab_name, location, capacity, department_id) VALUES
('Molecular Biology Lab', 'Building A, Room 101', 20, 1),
('Analytical Chemistry Lab', 'Building B, Room 203', 15, 2),
('Quantum Physics Lab', 'Building C, Room 305', 10, 3);

-- Equipment
INSERT INTO equipment (equipment_name, model_number, purchase_date, last_maintenance_date, lab_id, status) VALUES
('PCR Machine', 'PCR-2000', '2021-01-15', '2023-06-20', 1, 'Available'),
('Mass Spectrometer', 'MS-5000', '2020-11-30', '2023-05-15', 2, 'In Use'),
('Electron Microscope', 'EM-3000', '2022-03-10', '2023-07-01', 3, 'Available');

-- Researchers
INSERT INTO researchers (employee_id, specialization, qualification) VALUES
(1, 'Molecular Biology', 'Ph.D. in Biotechnology'),
(2, 'Analytical Chemistry', 'Ph.D. in Chemistry'),
(3, 'Quantum Physics', 'M.Sc. in Physics');

-- Projects
INSERT INTO projects (project_name, description, start_date, end_date, status, budget, department_id) VALUES
('Gene Expression Study', 'Research on gene expression patterns', '2023-01-01', '2024-12-31', 'Active', 500000.00, 1),
('Novel Materials Development', 'Development of sustainable materials', '2023-03-15', '2024-06-30', 'Active', 750000.00, 2),
('Quantum Computing Research', 'Quantum algorithm optimization', '2023-02-01', '2025-01-31', 'Active', 1000000.00, 3);

-- Users
INSERT INTO users (username, password_hash, email, role, employee_id) VALUES
('Rcheda', ' $2b$10$nnNFnvYaL8l6uJc3q51XxOjodp3NUbEFsrSu/qOYvuwNwYx78alfO', 'ramadhan.cheda@lab.com', 'Admin', 1),
('edavis', 'hashed_password_2', 'emma.davis@lab.com', 'Researcher', 2),
('dbrown', 'hashed_password_3', 'david.brown@lab.com', 'Staff', 3);

-- Publications
INSERT INTO publications (title, authors, publication_date, journal_name, doi, citation_count) VALUES
('Advances in Gene Expression Analysis', 'Smith J., Davis E.', '2023-05-15', 'Journal of Molecular Biology', 'doi:10.1234/jmb.2023.001', 5),
('New Methods in Material Science', 'Davis E., Brown D.', '2023-06-20', 'Materials Research Journal', 'doi:10.1234/mrj.2023.002', 3);

-- Collaborations
INSERT INTO collaborations (institution_name, contact_person, email, start_date, end_date, status) VALUES
('University of Science', 'Prof. Zamzam Cheda', 'z.cheda@science.edu', '2023-01-01', '2024-12-31', 'Active'),
('Tech Research Institute', 'Dr. James Lee', 'j.lee@techresearch.org', '2023-03-15', '2024-06-30', 'Active');

-- Project Researchers
INSERT INTO project_researchers (project_id, researcher_id, role, join_date) VALUES
(1, 1, 'Principal Investigator', '2023-01-01'),
(2, 2, 'Lead Researcher', '2023-03-15'),
(3, 3, 'Research Assistant', '2023-02-01');

-- Project Collaborations
INSERT INTO project_collaborations (project_id, collaboration_id, contribution_type) VALUES
(1, 1, 'Research Support'),
(2, 2, 'Technical Expertise');

-- Collaboration Publications
INSERT INTO collaboration_publications (collaboration_id, publication_id) VALUES
(1, 1),
(2, 2);

UPDATE users
SET password_hash = '$2b$10$nnNFnvYaL8l6uJc3q51XxOjodp3NUbEFsrSu/qOYvuwNwYx78alfO'
WHERE username = 'Rcheda';

