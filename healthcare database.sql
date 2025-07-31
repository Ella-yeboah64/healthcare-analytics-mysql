CREATE DATABASE healthcare_db;
USE healthcare_db;
CREATE TABLE patient (
    patient_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(10),
    date_of_birth DATE,
    phone_number VARCHAR(20),
    address VARCHAR(100),
    registration_date DATE,
    insurance_provider VARCHAR(50),
    insurance_number VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE doctor (
    doctors_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    phone_number VARCHAR(20),
    years_of_experience INT,
    hospital VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE appointment (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctors_id INT,
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit VARCHAR(255),
    appointment_status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (doctors_id) REFERENCES doctor(doctors_id)
);

CREATE TABLE treatment (
    treatment_id INT PRIMARY KEY,
    appointment_id INT,
    treatment_type VARCHAR(100),
    description TEXT,
    cost DECIMAL(10, 2),
    treatment_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id)
);

CREATE TABLE billing (
    billing_id INT PRIMARY KEY,
    patient_id INT,
    treatment_id INT,
    billing_date DATE,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    billing_status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES treatment(treatment_id)
);

USE healthcare_db;
SET FOREIGN_KEY_CHECKS = 0;
ALTER TABLE patient DROP PRIMARY KEY;
ALTER TABLE patient MODIFY patient_id VARCHAR(10) PRIMARY KEY;
TRUNCATE TABLE patient;
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patients.csv'
INTO TABLE patient
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Connect to your database
USE healthcare_db;

-- Step 1.1: Temporarily disable foreign key checks for all operations that follow.
SET FOREIGN_KEY_CHECKS = 0;

-- Step 1.2: Drop existing foreign key constraints from child tables.
-- Removed 'IF EXISTS' as it's not supported for DROP FOREIGN KEY in your MySQL version.
-- You might see 'Error Code: 1091. Can't DROP ...' if a constraint doesn't exist, which is fine.

ALTER TABLE appointment DROP FOREIGN KEY appointment_ibfk_1; -- patient_id FK
ALTER TABLE appointment DROP FOREIGN KEY appointment_ibfk_2; -- doctor_id FK
ALTER TABLE treatment DROP FOREIGN KEY treatment_ibfk_1; -- patient_id FK
ALTER TABLE billing DROP FOREIGN KEY billing_ibfk_1; -- patient_id FK
ALTER TABLE billing DROP FOREIGN KEY billing_ibfk_2; -- appointment_id FK

-- Connect to your database (just in case)
USE healthcare_db;

-- Ensure foreign key checks are still off
SET FOREIGN_KEY_CHECKS = 0;

-- Corrected file name: patient.csv (singular)
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/patient.csv'
INTO TABLE patient
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verify the patient table
SELECT COUNT(*) AS patient_count FROM patient;

-- Connect to your database
USE healthcare_db;

-- Ensure foreign key checks are still off (should be from previous steps)
SET FOREIGN_KEY_CHECKS = 0;

-- Step 2.0: DROP the existing doctor table completely
-- This will remove the old table with the 'doctors_id' column
DROP TABLE IF EXISTS doctor;

-- Step 2.1: RECREATE the doctor table with 'doctor_id' (singular) as PRIMARY KEY
CREATE TABLE doctor (
    doctor_id VARCHAR(10) PRIMARY KEY, -- Corrected to doctor_id and VARCHAR(10)
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    phone_number VARCHAR(20),
    years_of_experience INT,
    hospital VARCHAR(100),
    email VARCHAR(100)
);

-- Step 2.2: (Optional, but harmless) Truncate the new doctor table
-- This table is brand new, so TRUNCATE isn't strictly needed, but it's part of our consistent flow.
TRUNCATE TABLE doctor;

-- Step 2.3: Load data into the doctor table using 'doctor_id'
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/doctor.csv'
INTO TABLE doctor
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Step 2.4: Verify the doctor table
SELECT COUNT(*) AS doctor_count FROM doctor;

-- Connect to your database
USE healthcare_db;

-- Ensure foreign key checks are still off (should be from previous steps)
SET FOREIGN_KEY_CHECKS = 0;

-- Step 3.0: DROP the existing appointment table completely
-- This will remove the old table with incorrect column names/types
DROP TABLE IF EXISTS appointment;

-- Step 3.1: RECREATE the appointment table with corrected column names and VARCHAR(10) for IDs
CREATE TABLE appointment (
    appointment_id VARCHAR(10) PRIMARY KEY, -- Changed to VARCHAR(10) to match A001 etc.
    patient_id VARCHAR(10),              -- Changed to VARCHAR(10) to match P001 etc.
    doctor_id VARCHAR(10),               -- Corrected from 'doctors_id' to 'doctor_id' (singular)
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit VARCHAR(255),
    status VARCHAR(50)                  -- Corrected from 'appointment_status' to 'status'
);

-- Step 3.2: (Optional, but harmless) Truncate the new appointment table
-- This table is brand new, so TRUNCATE isn't strictly needed.
TRUNCATE TABLE appointment;

-- Step 3.3: Load data into the appointment table
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/appointment.csv'
INTO TABLE appointment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Step 3.4: Verify the appointment table
SELECT COUNT(*) AS appointment_count FROM appointment;

-- Connect to your database
USE healthcare_db;

-- Ensure foreign key checks are still off (should be from previous steps)
SET FOREIGN_KEY_CHECKS = 0;

-- Step 4.0: DROP the existing treatment table completely
DROP TABLE IF EXISTS treatment;

-- Step 4.1: RECREATE the treatment table with corrected column types for IDs
CREATE TABLE treatment (
    treatment_id VARCHAR(10) PRIMARY KEY, -- Changed to VARCHAR(10) to match T001 etc.
    appointment_id VARCHAR(10),            -- Changed to VARCHAR(10) to match A001 etc.
    treatment_type VARCHAR(100),
    description TEXT,
    cost DECIMAL(10, 2),
    treatment_date DATE
    -- Foreign key will be added later, after all tables are loaded
);

-- Step 4.2: (Optional, but harmless) Truncate the new treatment table
TRUNCATE TABLE treatment;

-- Step 4.3: Load data into the treatment table
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/treatment.csv'
INTO TABLE treatment
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Step 4.4: Verify the treatment table
SELECT COUNT(*) AS treatment_count FROM treatment;

-- Connect to your database
USE healthcare_db;

-- Ensure foreign key checks are still off (should be from previous steps)
SET FOREIGN_KEY_CHECKS = 0;

-- Step 5.0: DROP the existing billing table completely
DROP TABLE IF EXISTS billing;

-- Step 5.1: RECREATE the billing table with corrected column types for IDs
CREATE TABLE billing (
    bill_id VARCHAR(10) PRIMARY KEY,       -- Changed to VARCHAR(10) to match B001 etc.
    patient_id VARCHAR(10),                -- Changed to VARCHAR(10) to match P001 etc.
    treatment_id VARCHAR(10),              -- Changed to VARCHAR(10) to match T001 etc.
    bill_date DATE,
    amount DECIMAL(10, 2),
    payment_method VARCHAR(50),
    payment_status VARCHAR(50)
    -- Foreign keys will be added later, after all tables are loaded
);

-- Step 5.2: (Optional, but harmless) Truncate the new billing table
TRUNCATE TABLE billing;

-- Step 5.3: Load data into the billing table
LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/billing.csv'
INTO TABLE billing
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Step 5.4: Verify the billing table
SELECT COUNT(*) AS billing_count FROM billing;

-- Connect to your database
USE healthcare_db;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Add Foreign Key to 'appointment' table
-- patient_id references patient.patient_id
-- doctor_id references doctor.doctor_id
ALTER TABLE appointment
ADD CONSTRAINT fk_patient_id
FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
ADD CONSTRAINT fk_doctor_id
FOREIGN KEY (doctor_id) REFERENCES doctor(doctor_id);

-- Add Foreign Key to 'treatment' table
-- appointment_id references appointment.appointment_id
ALTER TABLE treatment
ADD CONSTRAINT fk_appointment_id
FOREIGN KEY (appointment_id) REFERENCES appointment(appointment_id);

-- Add Foreign Keys to 'billing' table
-- patient_id references patient.patient_id
-- treatment_id references treatment.treatment_id
ALTER TABLE billing
ADD CONSTRAINT fk_billing_patient_id
FOREIGN KEY (patient_id) REFERENCES patient(patient_id),
ADD CONSTRAINT fk_billing_treatment_id
FOREIGN KEY (treatment_id) REFERENCES treatment(treatment_id);

-- Optional: Verify all foreign keys are in place
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_SCHEMA = 'healthcare_db' AND REFERENCED_TABLE_NAME IS NOT NULL;

SELECT
    AVG(age) AS average_patient_age
FROM
    patient;
    
    SELECT
    gender,
    COUNT(*) AS patient_count
FROM
    patient
GROUP BY
    gender;
    
    SELECT
    payment_method,
    COUNT(*) AS failed_payment_count
FROM
    billing
WHERE
    payment_status = 'Failed'
GROUP BY
    payment_method
ORDER BY
    failed_payment_count DESC;
    
    SELECT
    payment_status,
    COUNT(*) AS number_of_bills
FROM
    billing
GROUP BY
    payment_status;
    
    SELECT
    treatment_type,
    AVG(cost) AS average_cost
FROM
    treatment
GROUP BY
    treatment_type
ORDER BY
    average_cost DESC;
    
    SELECT
    reason_for_visit,
    COUNT(*) AS visit_count
FROM
    appointment
GROUP BY
    reason_for_visit
ORDER BY
    visit_count DESC
LIMIT 1;

SELECT
    d.first_name,
    d.last_name,
    COUNT(a.appointment_id) AS total_appointments
FROM
    doctor d
JOIN
    appointment a ON d.doctor_id = a.doctor_id
GROUP BY
    d.doctor_id, d.first_name, d.last_name
ORDER BY
    total_appointments DESC;
    