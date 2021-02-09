DROP VIEW IF EXISTS v_encounters_plus;
CREATE VIEW v_encounters_plus AS 
SELECT
   encounter_procedures.Id,
   encounter_procedures.DATASET_ORIGIN,
   encounter_procedures.encounter_START,
   encounter_procedures.encounter_STOP,
   encounter_procedures.PATIENT_Id,
   encounter_procedures.PAYER_Id,
   encounter_procedures.payer_START_YEAR,
   encounter_procedures.payer_END_YEAR,
   encounter_procedures.payer_OWNERSHIP,
   encounter_procedures.ENCOUNTERCLASS,
   encounter_procedures.encounter_CODE,
   encounter_procedures.encounter_DESCRIPTION,
   encounter_procedures.encounter_REASONCODE,
   encounter_procedures.encounter_REASONDESCRIPTION,
   encounter_procedures.condition_START,
   encounter_procedures.condition_STOP,
   encounter_procedures.condition_CODE,
   encounter_procedures.condition_DESCRIPTION,
   encounter_procedures.immunization_DATE,
   encounter_procedures.immunization_CODE,
   encounter_procedures.immunizations_DESCRIPTION,
   encounter_procedures.procedure_DATE,
   encounter_procedures.procedure_CODE,
   encounter_procedures.procedure_DESCRIPTION,
   encounter_procedures.procedure_REASONCODE,
   encounter_procedures.procedure_REASONDESCRIPTION,
   tb_medications.START AS medication_START,
   tb_medications.STOP AS medication_STOP,
   tb_medications.CODE AS medication_CODE,
   tb_medications.DESCRIPTION AS medication_DESCRIPTION,
   tb_medications.REASONCODE AS medication_REASONCODE,
   tb_medications.REASONDESCRIPTION AS medication_REASONDESCRIPTION,
   encounter_procedures.BASE_ENCOUNTER_COST,
   encounter_procedures.BASE_IMMUNIZATION_COST,
   encounter_procedures.BASE_PROCEDURE_COST,
   tb_medications.BASE_COST AS BASE_MEDICATION_COST,
   tb_medications.PAYER_COVERAGE AS medication_PAYER_COVERAGE,
   tb_medications.DISPENSES AS medication_DISPENSES,
   tb_medications.TOTALCOST AS medication_TOTALCOST 
FROM
   (
      SELECT
         encounter_immunizations.Id,
         encounter_immunizations.DATASET_ORIGIN,
         encounter_immunizations.encounter_START,
         encounter_immunizations.encounter_STOP,
         encounter_immunizations.PATIENT_Id,
         encounter_immunizations.PAYER_Id,
         encounter_immunizations.payer_START_YEAR,
         encounter_immunizations.payer_END_YEAR,
         encounter_immunizations.payer_OWNERSHIP,
         encounter_immunizations.ENCOUNTERCLASS,
         encounter_immunizations.encounter_CODE,
         encounter_immunizations.encounter_DESCRIPTION,
         encounter_immunizations.encounter_REASONCODE,
         encounter_immunizations.encounter_REASONDESCRIPTION,
         encounter_immunizations.condition_START,
         encounter_immunizations.condition_STOP,
         encounter_immunizations.condition_CODE,
         encounter_immunizations.condition_DESCRIPTION,
         encounter_immunizations.immunization_DATE,
         encounter_immunizations.immunization_CODE,
         encounter_immunizations.immunizations_DESCRIPTION,
         tb_procedures.DATE AS procedure_DATE,
         tb_procedures.CODE AS procedure_CODE,
         tb_procedures.DESCRIPTION AS procedure_DESCRIPTION,
         tb_procedures.REASONCODE AS procedure_REASONCODE,
         tb_procedures.REASONDESCRIPTION AS procedure_REASONDESCRIPTION,
         encounter_immunizations.BASE_ENCOUNTER_COST,
         encounter_immunizations.BASE_IMMUNIZATION_COST,
         tb_procedures.BASE_COST AS BASE_PROCEDURE_COST 
      FROM
         (
            SELECT
               encounters_conditions.Id,
               encounters_conditions.DATASET_ORIGIN,
               encounters_conditions.encounter_START,
               encounters_conditions.encounter_STOP,
               encounters_conditions.PATIENT_Id,
               encounters_conditions.PAYER_Id,
               encounters_conditions.payer_START_YEAR,
               encounters_conditions.payer_END_YEAR,
               encounters_conditions.payer_OWNERSHIP,
               encounters_conditions.ENCOUNTERCLASS,
               encounters_conditions.encounter_CODE,
               encounters_conditions.encounter_DESCRIPTION,
               encounters_conditions.encounter_REASONCODE,
               encounters_conditions.encounter_REASONDESCRIPTION,
               encounters_conditions.condition_START,
               encounters_conditions.condition_STOP,
               encounters_conditions.condition_CODE,
               encounters_conditions.condition_DESCRIPTION,
               tb_immunizations.DATE AS immunization_DATE,
               tb_immunizations.CODE AS immunization_CODE,
               tb_immunizations.DESCRIPTION AS immunizations_DESCRIPTION,
               encounters_conditions.BASE_ENCOUNTER_COST,
               tb_immunizations.BASE_COST AS BASE_IMMUNIZATION_COST 
            FROM
               (
                  SELECT
                     encounters_payer_transitions.Id,
                     encounters_payer_transitions.DATASET_ORIGIN,
                     encounters_payer_transitions.encounter_START,
                     encounters_payer_transitions.encounter_STOP,
                     encounters_payer_transitions.PATIENT_Id,
                     encounters_payer_transitions.PAYER_Id,
                     encounters_payer_transitions.payer_START_YEAR,
                     encounters_payer_transitions.payer_END_YEAR,
                     encounters_payer_transitions.payer_OWNERSHIP,
                     encounters_payer_transitions.ENCOUNTERCLASS,
                     encounters_payer_transitions.encounter_CODE,
                     encounters_payer_transitions.encounter_DESCRIPTION,
                     encounters_payer_transitions.encounter_REASONCODE,
                     encounters_payer_transitions.encounter_REASONDESCRIPTION,
                     tb_conditions.START AS condition_START,
                     tb_conditions.STOP AS condition_STOP,
                     tb_conditions.CODE AS condition_CODE,
                     tb_conditions.DESCRIPTION AS condition_DESCRIPTION,
                     encounters_payer_transitions.BASE_ENCOUNTER_COST 
                  FROM
                     (
                        SELECT
                           tb_encounters.Id,
                           tb_encounters.DATASET_ORIGIN,
                           tb_encounters.START AS encounter_START,
                           tb_encounters.STOP AS encounter_STOP,
                           tb_encounters.PATIENT_Id,
                           tb_encounters.PAYER_Id,
                           tb_payer_transitions.START_YEAR AS payer_START_YEAR,
                           tb_payer_transitions.END_YEAR AS payer_END_YEAR,
                           tb_payer_transitions.OWNERSHIP AS payer_OWNERSHIP,
                           tb_encounters.ENCOUNTERCLASS,
                           tb_encounters.CODE AS encounter_CODE,
                           tb_encounters.DESCRIPTION AS encounter_DESCRIPTION,
                           tb_encounters.REASONCODE AS encounter_REASONCODE,
                           tb_encounters.REASONDESCRIPTION AS encounter_REASONDESCRIPTION,
                           tb_encounters.BASE_ENCOUNTER_COST 
                        FROM
                           tb_encounters 
                           LEFT JOIN
                              tb_payer_transitions 
                              ON tb_payer_transitions.PAYER_ID = tb_encounters.PAYER_Id 
                              AND tb_payer_transitions.PATIENT_Id = tb_encounters.PATIENT_Id 
                     )
                     encounters_payer_transitions 
                     LEFT JOIN
                        tb_conditions 
                        ON tb_conditions.ENCOUNTER_Id = encounters_payer_transitions.Id 
                        AND tb_conditions.ENCOUNTER_DSO = encounters_payer_transitions.DATASET_ORIGIN 
                        AND tb_conditions.PATIENT_Id = encounters_payer_transitions.PATIENT_Id 
               )
               encounters_conditions 
               LEFT JOIN
                  tb_immunizations 
                  ON tb_immunizations.ENCOUNTER_Id = encounters_conditions.Id 
                  AND tb_immunizations.ENCOUNTER_DSO = encounters_conditions.DATASET_ORIGIN 
                  AND tb_immunizations.PATIENT_Id = encounters_conditions.PATIENT_Id 
         )
         encounter_immunizations 
         LEFT JOIN
            tb_procedures 
            ON tb_procedures.ENCOUNTER_Id = encounter_immunizations.Id 
            AND tb_procedures.ENCOUNTER_DSO = encounter_immunizations.DATASET_ORIGIN 
            AND tb_procedures.PATIENT_Id = encounter_immunizations.PATIENT_Id 
   )
   encounter_procedures 
   LEFT JOIN
      tb_medications 
      ON tb_medications.ENCOUNTER_Id = encounter_procedures.Id 
      AND tb_medications.ENCOUNTER_DSO = encounter_procedures.DATASET_ORIGIN 
      AND tb_medications.PATIENT_ID = encounter_procedures.PATIENT_Id 
      AND tb_medications.PAYER_ID = encounter_procedures.PAYER_Id ;
