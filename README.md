# healthcare-analytics-mysql
A MySQL database for healthcare data analytics, including patient, doctor, appointment, treatment, and billing information.
Healthcare Database Analytics Project
Introduction
This project involves setting up a relational database for a healthcare system using MySQL. The primary goal was to design, implement, and populate a database with realistic (mock) patient, doctor, appointment, treatment, and billing data. This foundational database can then be used for various analytical purposes, such as understanding patient demographics, doctor workload, treatment costs, and billing statuses.

Project Goal
The main objective of this project was to successfully establish a robust and well-structured MySQL database capable of storing and managing core healthcare operational data. This included:

Designing appropriate table schemas.

Handling data type conversions for unique identifiers.

Managing complex foreign key relationships.

Efficiently loading data from CSV files into the respective tables.

Data Source
The data for this project was provided in five separate CSV (Comma Separated Values) files:

patient.csv: Contains patient demographic information.

doctor.csv: Contains doctor details, including specialization and contact information.

appointment.csv: Records details of patient appointments with doctors.

treatment.csv: Stores information about treatments provided, including type and cost.

billing.csv: Contains billing details, linking patients to treatments and appointments.

Database Schema
The healthcare_db database consists of five interconnected tables:

patient:

patient_id (PRIMARY KEY, VARCHAR(10))

first_name (VARCHAR(50))

last_name (VARCHAR(50))

gender (VARCHAR(10))

date_of_birth (DATE)

contact_number (VARCHAR(20))

address (VARCHAR(100))

registration_date (DATE)

insurance_provider (VARCHAR(50))

insurance_number (VARCHAR(50))

email (VARCHAR(100))

doctor:

doctor_id (PRIMARY KEY, VARCHAR(10))

first_name (VARCHAR(50))

last_name (VARCHAR(50))

specialization (VARCHAR(100))

phone_number (VARCHAR(20))

years_experience (INT)

hospital (VARCHAR(100))

email (VARCHAR(100))

appointment:

appointment_id (PRIMARY KEY, VARCHAR(10))

patient_id (VARCHAR(10), FOREIGN KEY references patient.patient_id)

doctor_id (VARCHAR(10), FOREIGN KEY references doctor.doctor_id)

appointment_date (DATE)

appointment_time (TIME)

reason_for_visit (VARCHAR(255))

status (VARCHAR(50))

treatment:

treatment_id (PRIMARY KEY, VARCHAR(10))

appointment_id (VARCHAR(10), FOREIGN KEY references appointment.appointment_id)

treatment_type (VARCHAR(100))

description (TEXT)

cost (DECIMAL(10, 2))

treatment_date (DATE)

billing:

bill_id (PRIMARY KEY, VARCHAR(10))

patient_id (VARCHAR(10), FOREIGN KEY references patient.patient_id)

treatment_id (VARCHAR(10), FOREIGN KEY references treatment.treatment_id)

bill_date (DATE)

amount (DECIMAL(10, 2))

payment_method (VARCHAR(50))

payment_status (VARCHAR(50))

Tools Used
MySQL Community Server 8.0: The relational database management system.

MySQL Workbench: A graphical tool for database design, development, and administration.

Windows PowerShell: Used for unblocking downloaded CSV files.

CSV Files: For importing raw data.

Key Learnings & Challenges Overcome
This project presented several common, yet challenging, obstacles for a beginner in database management, all of which were successfully resolved:

Error Code: 2068 - LOAD DATA LOCAL INFILE file request rejected due to restrictions on access.: This was initially due to the "Mark-of-the-Web" security feature on downloaded files. It was resolved by using Unblock-File in PowerShell.

secure_file_priv Restriction: Even with LOCAL INFILE enabled, MySQL's secure_file_priv setting restricted file loading to a specific directory (C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\). The solution involved physically moving all CSV files to this designated directory and updating the LOAD DATA paths.

Error Code: 1366 - Incorrect integer value: 'P001' for column 'patient_id': The initial table schemas defined ID columns (like patient_id, doctor_id) as INT, while the CSV data contained alphanumeric IDs (e.g., P001, D001). This was resolved by altering the column data types to VARCHAR(10).

Error Code: 1068 - Multiple primary key defined: Repeated attempts to ALTER TABLE ... ADD PRIMARY KEY without first dropping an existing (even if incorrectly typed) primary key led to this error. The fix involved explicitly using ALTER TABLE ... DROP PRIMARY KEY before redefining it.

Error Code: 1701 - Cannot truncate a table referenced in a foreign key constraint: This common issue arose when attempting to TRUNCATE parent tables (like patient) while child tables (like appointment) still had foreign key constraints referencing them. The solution was to temporarily disable foreign key checks (SET FOREIGN_KEY_CHECKS = 0;) before truncating and re-enabling them (SET FOREIGN_KEY_CHECKS = 1;) after data loading.

Error Code: 1553 - Cannot drop index 'PRIMARY': needed in a foreign key constraint: This was a more stubborn foreign key issue, preventing primary key modification on parent tables. It required dropping all foreign key constraints from child tables before attempting to modify primary keys on parent tables.

Column Name Mismatches: Discrepancies between CSV headers (e.g., doctor_id, status) and initial table definitions (e.g., doctors_id, appointment_status) led to "Unknown column" errors. This was resolved by dropping and recreating tables with column names that precisely matched the CSV headers.

How to Use/Reproduce This Project
To set up and explore this database:

Prerequisites:

MySQL Community Server 8.0+ installed.

MySQL Workbench installed.

Your CSV data files (patient.csv, doctor.csv, appointment.csv, treatment.csv, billing.csv).

Place CSV Files: Move all .csv files to your MySQL Uploads directory (e.g., C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\).

Unblock Files (Windows): Open PowerShell as Administrator and run:

Get-ChildItem -Path "C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\" -Recurse | Unblock-File

Enable LOCAL INFILE:

MySQL Workbench: In your connection settings, go to Advanced tab, and add OPT_LOCAL_INFILE=1 in the Others: field.

Command Line: Connect using mysql -u your_username -p --local-infile.

Run SQL Script: Execute the comprehensive SQL script (which incorporates all the fixes discussed) in your MySQL client. This script will:

Disable foreign key checks.

Drop and recreate tables with correct VARCHAR(10) IDs.

Load data from CSVs using LOAD DATA LOCAL INFILE.

Re-enable foreign key checks.

Add all foreign key constraints.

Verify row counts.

(Provide the final, complete SQL script here, similar to the last one we finalized, but ensuring all table creation and FK additions are in one place for easy reproduction)

Example Queries & Insights
Once the database is loaded, you can run various SQL queries to gain insights. Here are a few examples:

Top 5 Doctors by Number of Appointments:

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
    total_appointments DESC
LIMIT 5;

Most Common Reason for Patient Visits:

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

Average Cost of Treatments by Type:

SELECT
    treatment_type,
    AVG(cost) AS average_cost
FROM
    treatment
GROUP BY
    treatment_type
ORDER BY
    average_cost DESC;

Payment Status Breakdown:

SELECT
    payment_status,
    COUNT(*) AS number_of_bills
FROM
    billing
GROUP BY
    payment_status;

Patient Gender Distribution:

SELECT
    gender,
    COUNT(*) AS patient_count
FROM
    patient
GROUP BY
    gender;

Future Enhancements
Develop a backend API (e.g., Node.js, Python Flask) to expose data from this database.

Build a front-end web application (e.g., React, HTML/CSS/JS) to interact with the API and visualize the data.

Implement more complex analytical queries (e.g., patient lifetime value, doctor utilization rates).

Integrate with business intelligence (BI) tools for advanced dashboarding.
