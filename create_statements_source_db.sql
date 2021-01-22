DROP TABLE IF EXISTS tb_medications; 

DROP TABLE IF EXISTS tb_supplies; 

DROP TABLE IF EXISTS tb_procedures; 

DROP TABLE IF EXISTS tb_observations; 

DROP TABLE IF EXISTS tb_immunizations; 

DROP TABLE IF EXISTS tb_imaging_studies; 

DROP TABLE IF EXISTS tb_disease; 

DROP TABLE IF EXISTS tb_devices; 

DROP TABLE IF EXISTS tb_conditions; 

DROP TABLE IF EXISTS tb_careplans; 

DROP TABLE IF EXISTS tb_encounters; 

DROP TABLE IF EXISTS tb_payer_transitions; 

DROP TABLE IF EXISTS tb_payers; 

DROP TABLE IF EXISTS tb_providers; 

DROP TABLE IF EXISTS tb_organizations; 

DROP TABLE IF EXISTS tb_patients; 

CREATE TABLE tb_patients 
  ( 
     id                  NVARCHAR(256), 
     birthdate           DATE DEFAULT NULL, 
     deathdate           DATE DEFAULT NULL, 
     ssn                 NVARCHAR(256) DEFAULT NULL, 
     drivers             NVARCHAR(256) DEFAULT NULL, 
     passport            NVARCHAR(10) DEFAULT NULL, 
     prefix              NVARCHAR(4) DEFAULT NULL, 
     first               NVARCHAR(256) DEFAULT NULL, 
     last                NVARCHAR(256) DEFAULT NULL, 
     suffix              NVARCHAR(10) DEFAULT NULL, 
     maiden              NVARCHAR(256) DEFAULT NULL, 
     marital             CHAR(1) DEFAULT NULL, 
     race                NVARCHAR(256) DEFAULT NULL, 
     ethnicity           NVARCHAR(256) DEFAULT NULL, 
     gender              CHAR(1) DEFAULT NULL, 
     birthplace          NVARCHAR(256) DEFAULT NULL, 
     address             NVARCHAR(256) DEFAULT NULL, 
     city                NVARCHAR(256) DEFAULT NULL, 
     state               NVARCHAR(256) DEFAULT NULL, 
     county              NVARCHAR(256) DEFAULT NULL, 
     zip                 NVARCHAR(256) DEFAULT NULL, 
     lat                 NUMERIC(8, 6) DEFAULT NULL, 
     lon                 NUMERIC(8, 6) DEFAULT NULL, 
     healthcare_expenses NUMERIC(10, 2) DEFAULT NULL, 
     healthcare_coverage NUMERIC(10, 2) DEFAULT NULL, 
     dataset_origin      NVARCHAR(256), 
     PRIMARY KEY (id, dataset_origin) 
  ); 

CREATE TABLE tb_organizations 
  ( 
     id             NVARCHAR(256), 
     name           NVARCHAR (256) DEFAULT NULL, 
     address        NVARCHAR (256) DEFAULT NULL, 
     city           NVARCHAR (256) DEFAULT NULL, 
     state          NVARCHAR (256) DEFAULT NULL, 
     zip            NVARCHAR (256) DEFAULT NULL, 
     lat            NUMERIC(8, 6) DEFAULT NULL, 
     lon            NUMERIC(8, 6) DEFAULT NULL, 
     phone          NVARCHAR(256) DEFAULT NULL, 
     revenue        NUMERIC(10, 2) DEFAULT NULL, 
     utilization    INT DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (id, dataset_origin) 
  );   

CREATE TABLE tb_providers 
  ( 
     id                NVARCHAR(256), 
     organization_id   NVARCHAR(256),
     organization_dso  NVARCHAR(256),
     name              NVARCHAR(256) DEFAULT NULL, 
     gender            CHAR(1) DEFAULT NULL, 
     speciality        NVARCHAR(256) DEFAULT NULL, 
     address           NVARCHAR(256) DEFAULT NULL, 
     city              NVARCHAR(256) DEFAULT NULL, 
     state             NVARCHAR(256) DEFAULT NULL, 
     zip               NVARCHAR(256) DEFAULT NULL, 
     lat               NUMERIC(8, 6) DEFAULT NULL, 
     lon               NUMERIC(8, 6) DEFAULT NULL, 
     utilization       INT DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (id, dataset_origin) 
  ); 
  
CREATE TABLE tb_payers 
  ( 
     id                      NVARCHAR(256), 
     name                    NVARCHAR(256) DEFAULT NULL, 
     address                 NVARCHAR(256) DEFAULT NULL, 
     city                    NVARCHAR(256) DEFAULT NULL, 
     state_headquartered     NVARCHAR(2) DEFAULT NULL, 
     zip                     NVARCHAR(256) DEFAULT NULL, 
     phone                   NVARCHAR(256) DEFAULT NULL, 
     amount_covered          NUMERIC(10, 2) DEFAULT NULL, 
     amount_uncovered        NUMERIC(10, 2) DEFAULT NULL, 
     revenue                 INT DEFAULT NULL, 
     covered_encounters      INT DEFAULT NULL, 
     uncovered_encounters    INT DEFAULT NULL, 
     covered_medications     INT DEFAULT NULL, 
     uncovered_medications   INT DEFAULT NULL, 
     covered_procedures      INT DEFAULT NULL, 
     uncovered_procedures    INT DEFAULT NULL, 
     covered_immunizations   INT DEFAULT NULL, 
     uncovered_immunizations INT DEFAULT NULL, 
     unique_customers        INT DEFAULT NULL, 
     qols_avg                NUMERIC(12, 10) DEFAULT NULL, 
     member_months           INT DEFAULT NULL, 
     dataset_origin          NVARCHAR(256), 
     PRIMARY KEY (id, dataset_origin) 
  ); 
  
CREATE TABLE tb_payer_transitions 
  ( 
     patient_id     NVARCHAR(256), 
     patient_dso    NVARCHAR(256), 
     start_year     INT, 
     end_year       INT, 
     payer_id       NVARCHAR(256), 
     payer_dso      NVARCHAR(256), 
     ownership      NVARCHAR(256) DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (patient_id, patient_dso, start_year, end_year, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (payer_id, payer_dso) REFERENCES tb_payers(id, dataset_origin) 
  );

CREATE TABLE tb_encounters 
  ( 
     id                   NVARCHAR(256), 
     start                TIMESTAMP DEFAULT NULL, 
     stop                 TIMESTAMP DEFAULT NULL, 
     patient_id           NVARCHAR(256), 
     patient_dso          NVARCHAR(256), 
     organization_id      NVARCHAR(256), 
     organization_dso     NVARCHAR(256), 
     provider_id          NVARCHAR(256), 
     provider_dso         NVARCHAR(256), 
     payer_id             NVARCHAR(256), 
     payer_dso            NVARCHAR(256), 
     encounterclass       NVARCHAR(256) DEFAULT NULL, 
     code                 NVARCHAR(256) DEFAULT NULL, 
     description          NVARCHAR(256) DEFAULT NULL, 
     base_encounter_cost  NUMERIC(10, 2) DEFAULT NULL, 
     total_claim_cost     NUMERIC(10, 2) DEFAULT NULL, 
     payer_coverage       NUMERIC(10, 2) DEFAULT NULL, 
     reasoncode           NVARCHAR(256) DEFAULT NULL, 
     reasondescription    NVARCHAR(256) DEFAULT NULL, 
     dataset_origin       NVARCHAR(256), 
     PRIMARY KEY (id, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (organization_id, organization_dso) REFERENCES tb_organizations(id, dataset_origin), 
     FOREIGN KEY (provider_id, provider_dso) REFERENCES tb_providers(id, dataset_origin) 
     FOREIGN KEY (payer_id, payer_dso) REFERENCES tb_payers(id, dataset_origin) 
  );

CREATE TABLE tb_careplans 
  ( 
     id                NVARCHAR(256), 
     start             DATE DEFAULT NULL, 
     stop              DATE DEFAULT NULL, 
     patient_id        NVARCHAR(256), 
     patient_dso       NVARCHAR(256), 
     encounter_id      NVARCHAR(256), 
     encounter_dso     NVARCHAR(256), 
     code              NVARCHAR(256) DEFAULT NULL, 
     description       NVARCHAR(256) DEFAULT NULL, 
     reasoncode        NVARCHAR(256) DEFAULT NULL, 
     reasondescription NVARCHAR(256) DEFAULT NULL, 
     dataset_origin    NVARCHAR(256), 
     PRIMARY KEY (id, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );   

CREATE TABLE tb_conditions 
  ( 
     start          DATE, 
     stop           DATE, 
     patient_id     NVARCHAR(256), 
     patient_dso    NVARCHAR(256), 
     encounter_id   NVARCHAR(256), 
     encounter_dso  NVARCHAR(256), 
     code           NVARCHAR(256), 
     description    NVARCHAR(256) DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (start, stop, patient_id, patient_dso, encounter_id, encounter_dso, code, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );

CREATE TABLE tb_devices 
  ( 
     start          TIMESTAMP, 
     stop           TIMESTAMP, 
     patient_id     NVARCHAR(256), 
     patient_dso    NVARCHAR(256), 
     encounter_id   NVARCHAR(256), 
     encounter_dso  NVARCHAR(256), 
     code           NVARCHAR(256), 
     description    NVARCHAR(256) DEFAULT NULL, 
     udi            NVARCHAR(256) DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (start, stop, patient_id, patient_dso, encounter_id, encounter_dso, code, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );

CREATE TABLE tb_disease 
  ( 
     start          DATE, 
     stop           DATE, 
     patient_id     NVARCHAR(256), 
     patient_dso    NVARCHAR(256), 
     encounter_id   NVARCHAR(256), 
     encounter_dso  NVARCHAR(256), 
     code           NVARCHAR(256), 
     description    NVARCHAR(256) DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (start, stop, patient_id, patient_dso, encounter_id, encounter_dso, code, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );

CREATE TABLE tb_imaging_studies 
  ( 
     id                   NVARCHAR(256), 
     date                 DATE DEFAULT NULL, 
     patient_id           NVARCHAR(256), 
     patient_dso          NVARCHAR(256), 
     encounter_id         NVARCHAR(256), 
     encounter_dso        NVARCHAR(256), 
     bodysite_code        NVARCHAR(256) DEFAULT NULL, 
     bodysite_description NVARCHAR(256) DEFAULT NULL, 
     modality_code        CHAR(2) DEFAULT NULL, 
     modality_description NVARCHAR(256) DEFAULT NULL, 
     sop_code             NVARCHAR(256) DEFAULT NULL, 
     sop_description      NVARCHAR(256) DEFAULT NULL, 
     dataset_origin       NVARCHAR(256), 
     PRIMARY KEY (id, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );

CREATE TABLE tb_immunizations 
  ( 
     date           TIMESTAMP, 
     patient_id     NVARCHAR(256), 
     patient_dso    NVARCHAR(256), 
     encounter_id   NVARCHAR(256), 
     encounter_dso  NVARCHAR(256), 
     code           NVARCHAR(256), 
     description    NVARCHAR(256) DEFAULT NULL, 
     base_cost      NUMERIC(10, 2) DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (date, patient_id, patient_dso, encounter_id, encounter_dso, code, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );

CREATE TABLE tb_observations 
  ( 
     date           TIMESTAMP, 
     patient_id     NVARCHAR(256), 
     patient_dso    NVARCHAR(256), 
     encounter_id   NVARCHAR(256), 
     encounter_dso  NVARCHAR(256), 
     code           NVARCHAR(256), 
     description    NVARCHAR(256) DEFAULT NULL, 
     value          NVARCHAR(256), 
     units          NVARCHAR(256) DEFAULT NULL, 
     type           NVARCHAR(256) DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (date, patient_id, patient_dso, encounter_id, encounter_dso, code, value, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );

CREATE TABLE tb_procedures 
  ( 
     date              TIMESTAMP, 
     patient_id        NVARCHAR(256), 
     patient_dso       NVARCHAR(256), 
     encounter_id      NVARCHAR(256), 
     encounter_dso     NVARCHAR(256), 
     code              NVARCHAR(256), 
     description       NVARCHAR(256) DEFAULT NULL, 
     base_cost         NUMERIC(10, 2) DEFAULT NULL, 
     reasoncode        NVARCHAR(256) DEFAULT NULL, 
     reasondescription NVARCHAR(256) DEFAULT NULL, 
     dataset_origin    NVARCHAR(256), 
     PRIMARY KEY (date, patient_id, patient_dso, encounter_id, encounter_dso, code, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );

CREATE TABLE tb_supplies 
  ( 
     date           DATE, 
     patient_id     NVARCHAR(256), 
     patient_dso    NVARCHAR(256), 
     encounter_id   NVARCHAR(256), 
     encounter_dso  NVARCHAR(256), 
     code           NVARCHAR(256), 
     description    NVARCHAR(256) DEFAULT NULL, 
     quantity       INT DEFAULT NULL, 
     dataset_origin NVARCHAR(256), 
     PRIMARY KEY (date, patient_id, patient_dso, encounter_id, encounter_dso, code, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );

CREATE TABLE tb_medications 
  ( 
     start             TIMESTAMP, 
     stop              TIMESTAMP, 
     patient_id        NVARCHAR(256), 
     patient_dso       NVARCHAR(256), 
     payer_id          NVARCHAR(256), 
     payer_dso         NVARCHAR(256), 
     encounter_id      NVARCHAR(256), 
     encounter_dso     NVARCHAR(256), 
     code              NVARCHAR(256), 
     description       VARCHAR(256) DEFAULT NULL, 
     base_cost         NUMERIC(10, 2) DEFAULT NULL, 
     payer_coverage    NUMERIC(10, 2) DEFAULT NULL, 
     dispenses         INT DEFAULT NULL, 
     totalcost         NUMERIC(10, 2) DEFAULT NULL, 
     reasoncode        NVARCHAR(256) DEFAULT NULL, 
     reasondescription NVARCHAR(256) DEFAULT NULL, 
     dataset_origin    NVARCHAR(256), 
     PRIMARY KEY (start, stop, patient_id, patient_dso, encounter_id, encounter_dso, code, dataset_origin), 
     FOREIGN KEY (patient_id, patient_dso) REFERENCES tb_patients(id, dataset_origin), 
     FOREIGN KEY (payer_id, payer_dso) REFERENCES tb_payers(id, dataset_origin), 
     FOREIGN KEY (encounter_id, encounter_dso) REFERENCES tb_encounters (id, dataset_origin) 
  );
