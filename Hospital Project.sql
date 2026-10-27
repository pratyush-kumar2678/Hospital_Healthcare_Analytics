USE hospital_db;
SHOW TABLES;

-- how many rows are in each table.
SELECT 'patients' AS table_name, COUNT(*) AS total_rows FROM patients
UNION ALL
SELECT 'encounters', COUNT(*) FROM encounters
UNION ALL
SELECT 'payers', COUNT(*) FROM payers 
UNION ALL
SELECT 'procedures', COUNT(*) FROM procedures
UNION ALL
SELECT 'organizations', COUNT(*) FROM organizations;

-- All columns and their Data Types
DESCRIBE patients;
DESCRIBE encounters;
DESCRIBE payers;
DESCRIBE procedures;
DESCRIBE organizations;

-- Display the exact column names of organizations table
SHOW COLUMNS FROM organizations;

-- Rename the first column to Id
ALTER TABLE organizations
CHANGE COLUMN `ï»¿Id` Id TEXT;

DESCRIBE organizations;

-- Check the columns in the encounters table
SHOW COLUMNS FROM encounters;

-- Check missing values in patient columns (counts NULL and blank values)
SELECT
    COUNT(*) AS total_rows,
    SUM(Id        IS NULL OR TRIM(Id)        = '') AS missing_patient_id,
    SUM(BIRTHDATE IS NULL OR TRIM(BIRTHDATE) = '') AS missing_birthdate,
    SUM(DEATHDATE IS NULL OR TRIM(DEATHDATE) = '') AS missing_deathdate,
    SUM(PREFIX    IS NULL OR TRIM(PREFIX)    = '') AS missing_prefix,
    SUM(FIRST     IS NULL OR TRIM(FIRST)     = '') AS missing_first_name,
    SUM(LAST      IS NULL OR TRIM(LAST)      = '') AS missing_last_name,
    SUM(SUFFIX    IS NULL OR TRIM(SUFFIX)    = '') AS missing_suffix,
    SUM(MAIDEN    IS NULL OR TRIM(MAIDEN)    = '') AS missing_maiden_name,
    SUM(MARITAL   IS NULL OR TRIM(MARITAL)   = '') AS missing_marital_status,
    SUM(RACE      IS NULL OR TRIM(RACE)      = '') AS missing_race,
    SUM(ETHNICITY IS NULL OR TRIM(ETHNICITY) = '') AS missing_ethnicity,
    SUM(GENDER    IS NULL OR TRIM(GENDER)    = '') AS missing_gender,
    SUM(BIRTHPLACE IS NULL OR TRIM(BIRTHPLACE) = '') AS missing_birthplace,
    SUM(ADDRESS   IS NULL OR TRIM(ADDRESS)   = '') AS missing_address,
    SUM(CITY      IS NULL OR TRIM(CITY)      = '') AS missing_city,
    SUM(STATE     IS NULL OR TRIM(STATE)     = '') AS missing_state,
    SUM(COUNTY    IS NULL OR TRIM(COUNTY)    = '') AS missing_county,
    SUM(ZIP       IS NULL OR TRIM(ZIP)       = '') AS missing_zip,
    SUM(LAT       IS NULL OR TRIM(LAT)       = '') AS missing_lat,
    SUM(LON       IS NULL OR TRIM(LON)       = '') AS missing_lon
FROM patients;

-- Check missing values in encounter columns (counts NULL and blank values)
SELECT
    COUNT(*) AS total_rows,
    SUM(Id                  IS NULL OR TRIM(Id)                  = '') AS missing_encounter_id,
    SUM(START               IS NULL OR TRIM(START)               = '') AS missing_start_date,
    SUM(STOP                IS NULL OR TRIM(STOP)                = '') AS missing_stop_date,
    SUM(PATIENT             IS NULL OR TRIM(PATIENT)             = '') AS missing_patient_id,
    SUM(ORGANIZATION        IS NULL OR TRIM(ORGANIZATION)        = '') AS missing_organization,
    SUM(PAYER               IS NULL OR TRIM(PAYER)               = '') AS missing_payer,
    SUM(ENCOUNTERCLASS      IS NULL OR TRIM(ENCOUNTERCLASS)      = '') AS missing_encounter_class,
    SUM(CODE                IS NULL OR TRIM(CODE)                = '') AS missing_encounter_code,
    SUM(DESCRIPTION         IS NULL OR TRIM(DESCRIPTION)         = '') AS missing_description,
    SUM(BASE_ENCOUNTER_COST IS NULL OR TRIM(BASE_ENCOUNTER_COST) = '') AS missing_base_cost,
    SUM(TOTAL_CLAIM_COST    IS NULL OR TRIM(TOTAL_CLAIM_COST)    = '') AS missing_claim_cost,
    SUM(PAYER_COVERAGE      IS NULL OR TRIM(PAYER_COVERAGE)      = '') AS missing_payer_coverage,
    SUM(REASONCODE          IS NULL OR TRIM(REASONCODE)          = '') AS missing_reason_code,
    SUM(REASONDESCRIPTION   IS NULL OR TRIM(REASONDESCRIPTION)   = '') AS missing_reason_description
FROM encounters;

-- Check missing values in procedure columns (counts NULL and blank values)
SELECT
    COUNT(*) AS total_rows,
    SUM(START             IS NULL OR TRIM(START)             = '') AS missing_start,
    SUM(STOP              IS NULL OR TRIM(STOP)              = '') AS missing_stop,
    SUM(PATIENT           IS NULL OR TRIM(PATIENT)           = '') AS missing_patient_id,
    SUM(ENCOUNTER         IS NULL OR TRIM(ENCOUNTER)         = '') AS missing_encounter_id,
    SUM(CODE              IS NULL OR TRIM(CODE)              = '') AS missing_procedure_code,
    SUM(DESCRIPTION       IS NULL OR TRIM(DESCRIPTION)       = '') AS missing_description,
    SUM(BASE_COST         IS NULL OR TRIM(BASE_COST)         = '') AS missing_base_cost,
    SUM(REASONCODE        IS NULL OR TRIM(REASONCODE)        = '') AS missing_reason_code,
    SUM(REASONDESCRIPTION IS NULL OR TRIM(REASONDESCRIPTION) = '') AS missing_reason_description
FROM procedures;

-- Check missing values in payers table (counts NULL and blank values)
SELECT
    COUNT(*) AS total_rows,
    SUM(Id                  IS NULL OR TRIM(Id)                  = '') AS missing_payer_id,
    SUM(NAME                IS NULL OR TRIM(NAME)                = '') AS missing_name,
    SUM(ADDRESS             IS NULL OR TRIM(ADDRESS)             = '') AS missing_address,
    SUM(CITY                IS NULL OR TRIM(CITY)                = '') AS missing_city,
    SUM(STATE_HEADQUARTERED IS NULL OR TRIM(STATE_HEADQUARTERED) = '') AS missing_state,
    SUM(ZIP                 IS NULL OR TRIM(ZIP)                 = '') AS missing_zip,
    SUM(PHONE               IS NULL OR TRIM(PHONE)               = '') AS missing_phone
FROM payers;

-- Find payer records with missing contact or location information
SELECT Id, NAME, ADDRESS, CITY, STATE_HEADQUARTERED, ZIP, PHONE
FROM payers
WHERE ADDRESS             IS NULL OR TRIM(ADDRESS)             = ''
   OR CITY                IS NULL OR TRIM(CITY)                = ''
   OR STATE_HEADQUARTERED IS NULL OR TRIM(STATE_HEADQUARTERED) = ''
   OR ZIP                 IS NULL OR TRIM(ZIP)                 = ''
   OR PHONE               IS NULL OR TRIM(PHONE)               = '';
   
-- Check Duplicate Patient IDs 
SELECT Id, COUNT(*) AS duplicate_count
FROM patients
GROUP BY Id
HAVING COUNT(*) > 1;    

-- Check Duplicate Encounter IDs 
SELECT Id, COUNT(*) AS duplicate_count
FROM encounters
GROUP BY Id
HAVING COUNT(*) > 1; 

-- Check invalid costs in encounters
-- Expected: negative_cost = 0, zero_cost = 89, coverage_exceeds_cost = 0
SELECT
    SUM(TOTAL_CLAIM_COST < 0)               AS negative_cost,
    SUM(TOTAL_CLAIM_COST = 0)               AS zero_cost,
    SUM(PAYER_COVERAGE > TOTAL_CLAIM_COST)  AS coverage_exceeds_cost
FROM encounters; 

-- Check whether encounters contain unmatched patient IDs
SELECT DISTINCT e.PATIENT AS patient_id
FROM encounters AS e
LEFT JOIN patients AS p ON e.PATIENT = p.Id
WHERE p.Id IS NULL;

-- how many encounters are affected
SELECT COUNT(*) AS orphan_encounters
FROM encounters AS e
LEFT JOIN patients AS p ON e.PATIENT = p.Id
WHERE p.Id IS NULL;

-- Investigation (not a check): size of the problem found above.
-- Patient 204f8028-... was missing from patients; it has 19 encounters.
SELECT COUNT(*) AS encounter_count
FROM encounters
WHERE PATIENT = '204f8028-72f8-d6f8-761f-79ebf9f02311';  

-- Check procedures linked to missing patient records
SELECT DISTINCT pr.PATIENT AS patient_id
FROM procedures AS pr
LEFT JOIN patients AS p ON pr.PATIENT = p.Id
WHERE p.Id IS NULL;

-- How many procedures are affected 
SELECT COUNT(*) AS orphan_procedures
FROM procedures AS pr
LEFT JOIN patients AS p ON pr.PATIENT = p.Id
WHERE p.Id IS NULL;

-- Find procedures linked to missing encounters 
SELECT DISTINCT pr.ENCOUNTER AS encounter_id
FROM procedures AS pr
LEFT JOIN encounters AS e ON pr.ENCOUNTER = e.Id
WHERE e.Id IS NULL;    

-- Find encounters where the stop time is before the start time
SELECT Id, START, STOP
FROM encounters
WHERE STOP < START;

-- Remove numbers from the end of patient names
SELECT
    FIRST AS original_name,
    REGEXP_REPLACE(FIRST, '[0-9]+$', '') AS cleaned_name   -- REGEXP_REPLACE() removes numbers from the end of each name.
FROM patients;

-- Combine patient details with their hospital encounters
SELECT
    p.Id AS patient_id,
    REGEXP_REPLACE(p.FIRST, '[0-9]+$', '') AS patient_name,   
    e.START AS encounter_date,      
    e.ENCOUNTERCLASS AS visit_type, 
    e.TOTAL_CLAIM_COST AS claim_cost 
FROM patients AS p                 
INNER JOIN encounters AS e         
    ON p.Id = e.PATIENT             
LIMIT 5;   

-- Join patients, encounters, payers, and procedures

SELECT
    pt.Id AS patient_id,
    pt.FIRST AS patient_first_name,
    e.Id AS encounter_id,
    e.START AS encounter_date,
    e.ENCOUNTERCLASS AS encounter_type,
    py.NAME AS payer_name,
    e.TOTAL_CLAIM_COST AS encounter_claim_cost,
    pr.DESCRIPTION AS procedure_description,
    pr.BASE_COST AS procedure_base_cost
FROM patients AS pt
INNER JOIN encounters AS e
    ON pt.Id = e.PATIENT
LEFT JOIN payers AS py
    ON e.PAYER = py.Id
INNER JOIN procedures AS pr
    ON e.Id = pr.ENCOUNTER
LIMIT 10;

-- OBJECTIVE 1: ENCOUNTERS OVERVIEW

-- a. How many total encounters occurred each year?
SELECT
    YEAR(START)  AS encounter_year,
    COUNT(*)     AS total_encounters
FROM encounters
GROUP BY YEAR(START)
ORDER BY encounter_year;
-- Check: 2011=1336 ... 2021=3530, 2022=220 (partial year, data ends 5 Feb 2022). Sum = 27,891.


-- b. For each year, what percentage of all encounters belonged to each encounter class
-- (ambulatory, outpatient, wellness, urgent care, emergency, and inpatient)?
SELECT
    YEAR(START) AS encounter_year,
    ROUND(100 * SUM(ENCOUNTERCLASS = 'ambulatory') / COUNT(*), 2) AS pct_ambulatory,
    ROUND(100 * SUM(ENCOUNTERCLASS = 'outpatient') / COUNT(*), 2) AS pct_outpatient,
    ROUND(100 * SUM(ENCOUNTERCLASS = 'wellness')   / COUNT(*), 2) AS pct_wellness,
    ROUND(100 * SUM(ENCOUNTERCLASS = 'urgentcare') / COUNT(*), 2) AS pct_urgentcare,
    ROUND(100 * SUM(ENCOUNTERCLASS = 'emergency')  / COUNT(*), 2) AS pct_emergency,
    ROUND(100 * SUM(ENCOUNTERCLASS = 'inpatient')  / COUNT(*), 2) AS pct_inpatient
FROM encounters
GROUP BY YEAR(START)
ORDER BY encounter_year;
-- Check: 2021 -> outpatient 40.17, ambulatory 36.91, urgentcare 10.71, emergency 6.26, wellness 4.39, inpatient 1.56.
-- (Each row adds up to 100.)


-- c. What percentage of encounters were over 24 hours versus under 24 hours?
SELECT
    CASE WHEN TIMESTAMPDIFF(SECOND, START, STOP) > 86400
         THEN 'Over 24 hours'
         ELSE '24 hours or less'
    END AS duration_group,
    COUNT(*) AS total_encounters,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_encounters
FROM encounters
GROUP BY duration_group;
-- Check: Over 24 hours = 75 (0.27%), 24 hours or less = 27,816 (99.73%).


-- OBJECTIVE 2: COST & COVERAGE INSIGHTS

-- a. How many encounters had zero payer coverage, and what percentage of total encounters does this represent?
SELECT
    SUM(PAYER_COVERAGE = 0)                              AS zero_coverage_encounters,
    COUNT(*)                                             AS total_encounters,
    ROUND(100 * SUM(PAYER_COVERAGE = 0) / COUNT(*), 2)   AS pct_zero_coverage
FROM encounters;
-- Check: 13,586 of 27,891 = 48.71%  (matches your dashboard).


-- b. What are the top 10 most frequent procedures performed and the average base cost for each?
SELECT
    DESCRIPTION,
    COUNT(*)                AS times_performed,
    ROUND(AVG(BASE_COST), 2) AS avg_base_cost
FROM procedures
GROUP BY DESCRIPTION
ORDER BY times_performed DESC
LIMIT 10;
-- Check: #1 "Assessment of health and social care needs" = 4,596 (avg 431), #2 Hospice care = 4,098,
-- #3 and #4 are both depression screenings at 3,614 (a tie).


-- c. What are the top 10 procedures with the highest average base cost and the number of times they were performed?
SELECT
    DESCRIPTION,
    ROUND(AVG(BASE_COST), 2) AS avg_base_cost,
    COUNT(*)                 AS times_performed
FROM procedures
GROUP BY DESCRIPTION
ORDER BY avg_base_cost DESC
LIMIT 10;
-- Check: #1 Admit to ICU = 206,260.40 (5 times), #2 Coronary artery bypass grafting = 47,085.89 (9 times).


-- d. What is the average total claim cost for encounters, broken down by payer?
SELECT
    p.NAME                              AS payer_name,
    COUNT(*)                            AS total_encounters,
    ROUND(AVG(e.TOTAL_CLAIM_COST), 2)   AS avg_total_claim_cost
FROM encounters e
JOIN payers p ON p.Id = e.PAYER
GROUP BY p.NAME
ORDER BY avg_total_claim_cost DESC;
-- Check: Medicaid 6,205.22, NO_INSURANCE 5,593.20, Anthem 4,236.81 ... Dual Eligible 1,696.19 (lowest).


-- OBJECTIVE 3: PATIENT BEHAVIOR ANALYSIS

-- a. How many unique patients were admitted each quarter over time?
SELECT
    YEAR(START)               AS encounter_year,
    QUARTER(START)            AS encounter_quarter,
    COUNT(DISTINCT PATIENT)   AS unique_patients
FROM encounters
GROUP BY YEAR(START), QUARTER(START)
ORDER BY encounter_year, encounter_quarter;
-- Check: 45 rows. 2011 Q1 = 156, 2021 Q3 = 279, 2022 Q1 = 103 (partial quarter).
-- Note: this counts a patient in any quarter where they had ANY encounter. To count only hospital
-- admissions, add: WHERE ENCOUNTERCLASS = 'inpatient'


-- b. How many patients were readmitted within 30 days of a previous encounter?
WITH ordered AS (
    SELECT
        PATIENT,
        START,
        LAG(STOP) OVER (PARTITION BY PATIENT ORDER BY START) AS prev_stop
    FROM encounters
)
SELECT
    COUNT(DISTINCT PATIENT) AS patients_readmitted_within_30_days
FROM ordered
WHERE prev_stop IS NOT NULL
  AND DATEDIFF(START, prev_stop) BETWEEN 0 AND 30;
-- Check: 772 patients (17,175 readmission events) when ANY encounter counts as a readmission.
-- That is very broad, because routine visits such as dialysis or hospice count. Use the stricter
-- inpatient-only version below if you mean true hospital readmissions.

-- b (strict). Inpatient-only readmissions within 30 days of a previous inpatient stay
WITH ordered AS (
    SELECT
        PATIENT,
        START,
        LAG(STOP) OVER (PARTITION BY PATIENT ORDER BY START) AS prev_stop
    FROM encounters
    WHERE ENCOUNTERCLASS = 'inpatient'
)
SELECT
    COUNT(DISTINCT PATIENT) AS inpatient_patients_readmitted_within_30_days
FROM ordered
WHERE prev_stop IS NOT NULL
  AND DATEDIFF(START, prev_stop) BETWEEN 0 AND 30;
-- Check: 29 patients (438 readmission events) out of 153 patients who had an inpatient stay.


-- c. Which patients had the most readmissions?
WITH ordered AS (
    SELECT
        PATIENT,
        START,
        LAG(STOP) OVER (PARTITION BY PATIENT ORDER BY START) AS prev_stop
    FROM encounters
)
SELECT
    o.PATIENT,
    pt.FIRST,
    pt.LAST,
    COUNT(*) AS readmissions
FROM ordered o
JOIN patients pt ON pt.Id = o.PATIENT
WHERE o.prev_stop IS NOT NULL
  AND DATEDIFF(o.START, o.prev_stop) BETWEEN 0 AND 30
GROUP BY o.PATIENT, pt.FIRST, pt.LAST
ORDER BY readmissions DESC
LIMIT 10;
-- Check: the top patient has 1,376 readmissions, then 876 and 871 (any-encounter definition).
-- For the inpatient-only version, add WHERE ENCOUNTERCLASS = 'inpatient' inside the CTE:
-- top patients then have 52, 49 and 38 readmissions.
                     
-- OBJECTIVE 4: ADDITIONAL INSIGHTS
-- 1. Zero payer coverage by payer: which insurers actually pay?
SELECT
    p.NAME                                              AS payer_name,
    COUNT(*)                                            AS total_encounters,
    SUM(e.PAYER_COVERAGE = 0)                           AS zero_coverage_encounters,
    ROUND(100 * SUM(e.PAYER_COVERAGE = 0) / COUNT(*), 1) AS pct_zero_coverage
FROM encounters e
JOIN payers p ON p.Id = e.PAYER
GROUP BY p.NAME
ORDER BY pct_zero_coverage DESC;
-- Expected: NO_INSURANCE 100%, Anthem 100%, Cigna 97.7%, Aetna 95.9%, Humana 95.8%, UnitedHealthcare 91.1%,
--           Blue Cross Blue Shield 36.3%, Dual Eligible 13.9%, Medicare 0.5%, Medicaid 0.3%


-- 2. How much of the total cost do payers actually cover?
SELECT
    p.NAME                                                  AS payer_name,
    ROUND(SUM(e.TOTAL_CLAIM_COST), 0)                       AS total_claim_cost,
    ROUND(SUM(e.PAYER_COVERAGE), 0)                         AS payer_paid,
    ROUND(SUM(e.TOTAL_CLAIM_COST - e.PAYER_COVERAGE), 0)    AS patient_paid,
    ROUND(100 * SUM(e.PAYER_COVERAGE) / SUM(e.TOTAL_CLAIM_COST), 1) AS pct_covered_by_payer
FROM encounters e
JOIN payers p ON p.Id = e.PAYER
GROUP BY p.NAME
ORDER BY pct_covered_by_payer DESC;
-- Expected: Medicaid ~94%, Dual Eligible ~89%, Medicare ~78%, Blue Cross Blue Shield ~69%,
--           NO_INSURANCE, Anthem, Cigna, Aetna, Humana, UnitedHealthcare ~0%.
-- Overall: payers cover 31,097,507 of 101,514,376 = 30.6%. The rest is paid by patients.


-- 3. Total cost and average cost per year (is cost growing?)
SELECT
    YEAR(START)                          AS encounter_year,
    COUNT(*)                             AS total_encounters,
    ROUND(SUM(TOTAL_CLAIM_COST), 0)      AS total_cost,
    ROUND(AVG(TOTAL_CLAIM_COST), 0)      AS avg_cost_per_encounter
FROM encounters
GROUP BY YEAR(START)
ORDER BY encounter_year;
-- Expected: 2014 has the most encounters (3,885) but a low average (3,092); 2012 has the highest average (4,301);
--           2021 average drops to 2,600; 2022 is a partial year (220 encounters).


-- 4. Top 10 patients by total claim cost
SELECT
    e.PATIENT,
    pt.FIRST,
    pt.LAST,
    COUNT(*)                         AS total_encounters,
    ROUND(SUM(e.TOTAL_CLAIM_COST), 0) AS total_cost
FROM encounters e
JOIN patients pt ON pt.Id = e.PATIENT
GROUP BY e.PATIENT, pt.FIRST, pt.LAST
ORDER BY total_cost DESC
LIMIT 10;
-- Expected: #1 patient 3f523789-... = 9,932,263 over 447 encounters, #2 ff331e5c-... = 6,356,666.
-- The top 10 patients make up about 30.6% of ALL claim cost, so a few patients drive the total.


-- 5. Average length of stay (hours) by encounter class
SELECT
    ENCOUNTERCLASS,
    COUNT(*)                                          AS total_encounters,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, START, STOP)) / 60, 2) AS avg_hours
FROM encounters
GROUP BY ENCOUNTERCLASS
ORDER BY avg_hours DESC;
-- Expected: inpatient 36.84, ambulatory 9.48, outpatient 5.88, emergency 1.54, urgentcare 0.25, wellness 0.25


-- 6. Encounters and average cost by age group (age at the time of the encounter)
SELECT
    CASE
        WHEN TIMESTAMPDIFF(YEAR, pt.BIRTHDATE, e.START) < 35 THEN '18-34'
        WHEN TIMESTAMPDIFF(YEAR, pt.BIRTHDATE, e.START) < 50 THEN '35-49'
        WHEN TIMESTAMPDIFF(YEAR, pt.BIRTHDATE, e.START) < 65 THEN '50-64'
        ELSE '65+'
    END                                  AS age_group,
    COUNT(*)                             AS total_encounters,
    COUNT(DISTINCT e.PATIENT)            AS unique_patients,
    ROUND(AVG(e.TOTAL_CLAIM_COST), 0)    AS avg_claim_cost
FROM encounters e
JOIN patients pt ON pt.Id = e.PATIENT
GROUP BY age_group
ORDER BY age_group;
-- Expected: 18-34 = 2,328 encounters (avg 7,008), 35-49 = 3,170 (4,077), 50-64 = 3,527 (2,638), 65+ = 18,866 (3,338).
-- No patient is under 18 in this data. 65+ makes up about 68% of all encounters.
-- Note: patient counts add up to more than 974, because a patient moves between age groups over time.


-- 7. Top 10 reasons for encounters (only encounters with a recorded reason)
SELECT
    REASONDESCRIPTION,
    COUNT(*)                          AS total_encounters,
    ROUND(AVG(TOTAL_CLAIM_COST), 0)   AS avg_claim_cost
FROM encounters
WHERE REASONDESCRIPTION IS NOT NULL AND TRIM(REASONDESCRIPTION) <> ''
GROUP BY REASONDESCRIPTION
ORDER BY total_encounters DESC
LIMIT 10;
-- Expected: #1 Chronic congestive heart failure = 1,738, #2 Hyperlipidemia = 1,565, #3 Normal pregnancy = 1,341
--           (avg cost 15,601, much higher than the rest), #4 Viral sinusitis = 732, #5 Malignant neoplasm of breast = 723.
-- Only about 30% of encounters have a reason recorded.


-- 8. Procedure cost by encounter class (joins procedures to encounters)
SELECT
    e.ENCOUNTERCLASS,
    COUNT(*)                         AS total_procedures,
    ROUND(SUM(pr.BASE_COST), 0)      AS total_procedure_cost,
    ROUND(AVG(pr.BASE_COST), 0)      AS avg_procedure_cost
FROM procedures pr
JOIN encounters e ON e.Id = pr.ENCOUNTER
GROUP BY e.ENCOUNTERCLASS
ORDER BY total_procedure_cost DESC;
-- Expected: ambulatory 17,822 procedures (36.5M total), urgentcare only 1,047 procedures but 22.8M total
--           (avg 21,753 per procedure, the highest), outpatient 18.2M, emergency 10.6M, wellness 9.6M, inpatient 7.8M.


