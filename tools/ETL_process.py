# EXTRACTION
# Query final star scheme and save into dataframes
insert_tables = []
insert_table_names = []
# payers table
cur.execute(
"""
SELECT DISTINCT
   Id,
   NAME 
FROM
   tb_payers
""")
payers_columns = ('Id', 'NAME')
payers = pd.DataFrame(cur.fetchall(), columns=payers_columns)
del(payers_columns)
insert_tables.append(payers)
insert_table_names.append('payers')
del(payers)
# patients table
cur.execute(
"""
SELECT
  Id,
  BIRTHDATE,
  DEATHDATE,
  MARITAL,
  RACE,
  ETHNICITY,
  GENDER,
  BIRTHPLACE,
  HEALTHCARE_EXPENSES,
  HEALTHCARE_COVERAGE
FROM
  tb_patients
"""
)
patients_columns = ('Id', 'BIRTHDATE', 'DEATHDATE', 'MARITAL', 'RACE', 'ETHNICITY', 'GENDER', 'BIRTHPLACE', 'HEALTHCARE_EXPENSES', 'HEALTHCARE_COVERAGE')
patients = pd.DataFrame(cur.fetchall(), columns=patients_columns)
del(patients_columns)
# code_master table
cur.execute(
"""
SELECT DISTINCT
   encounter_CODE AS CODE,
   encounter_DESCRIPTION AS DESCRIPTION 
FROM
   v_encounters_plus 
UNION
SELECT DISTINCT
   encounter_REASONCODE AS CODE,
   encounter_REASONDESCRIPTION AS DESCRIPTION 
FROM
   v_encounters_plus 
UNION
SELECT DISTINCT
   condition_CODE AS CODE,
   condition_DESCRIPTION AS DESCRIPTION 
FROM
   v_encounters_plus 
UNION
SELECT DISTINCT
   immunization_CODE AS CODE,
   immunizations_DESCRIPTION AS DESCRIPTION 
FROM
   v_encounters_plus 
UNION
SELECT DISTINCT
   procedure_CODE AS CODE,
   procedure_DESCRIPTION AS DESCRIPTION 
FROM
   v_encounters_plus 
UNION
SELECT DISTINCT
   procedure_REASONCODE AS CODE,
   procedure_REASONDESCRIPTION AS DESCRIPTION 
FROM
   v_encounters_plus 
UNION
SELECT DISTINCT
   medication_CODE AS CODE,
   medication_DESCRIPTION AS DESCRIPTION 
FROM
   v_encounters_plus 
UNION
SELECT DISTINCT
   medication_REASONCODE AS CODE,
   medication_REASONDESCRIPTION AS DESCRIPTION
FROM
   v_encounters_plus    
"""
)
code_master_columns = ('CODE', 'DESCRIPTION')
code_master = pd.DataFrame(cur.fetchall(), columns=code_master_columns)
del(code_master_columns)
insert_tables.append(code_master)
insert_table_names.append('code_master')
del(code_master)
# encounters table
cur.execute(
"""
SELECT
   Id,
   DATASET_ORIGIN,
   encounter_START,
   encounter_STOP,
   PATIENT_Id,
   PAYER_Id,
   payer_START_YEAR,
   payer_END_YEAR,
   payer_OWNERSHIP,
   ENCOUNTERCLASS,
   encounter_CODE,
   encounter_REASONCODE,
   condition_START,
   condition_STOP,
   condition_CODE,
   immunization_DATE,
   immunization_CODE,
   procedure_DATE,
   procedure_CODE,
   procedure_REASONCODE,
   medication_START,
   medication_STOP,
   medication_CODE,
   medication_REASONCODE,
   BASE_ENCOUNTER_COST,
   BASE_IMMUNIZATION_COST,
   BASE_PROCEDURE_COST,
   BASE_MEDICATION_COST,
   medication_PAYER_COVERAGE,
   medication_DISPENSES,
   medications_TOTALCOST 
FROM
   v_encounters_plus
"""
)
encounters_columns = ('Id', 'DATASET_ORIGIN', 'encounter_START', 'encounter_STOP', 'PATIENT_Id', 'PAYER_Id', 'payer_START_YEAR', 'payer_END_YEAR', 'payer_OWNERSHIP', 'ENCOUNTERCLASS', 'encounter_CODE', 'encounter_REASONCODE', 'condition_START', 'condition_STOP', 'condition_CODE', 'immunization_DATE', 'immunization_CODE', 'procedure_DATE', 'procedure_CODE', 'procedure_REASONCODE', 'medication_START', 'medication_STOP', 'medication_CODE', 'medication_REASONCODE', 'BASE_ENCOUNTER_COST', 'BASE_IMMUNIZATION_COST', 'BASE_PROCEDURE_COST', 'BASE_MEDICATION_COST', 'medication_PAYER_COVERAGE', 'medication_DISPENSES', 'medications_TOTALCOST')
encounters = pd.DataFrame(cur.fetchall(), columns=encounters_columns)
del(encounters_columns)
print("Successfully Extracted Data")
#TRANSFORMATION
# encounters table
# Change all date columns to year
encounters_date_columns = ['encounter_START', 'encounter_STOP', 'condition_START', 'condition_STOP', 'immunization_DATE', 'procedure_DATE', 'medication_START', 'medication_STOP']
for date_column in encounters_date_columns:
  row_counter = 0
  while row_counter < encounters[date_column].size:
    # Replace each time value with corresponding year
    try:
      encounters.at[row_counter, date_column] = encounters.at[row_counter, date_column][:4]
    except:
      pass
    row_counter +=1
del(encounters_date_columns)
del(row_counter)
insert_tables.append(encounters)
insert_table_names.append('encounters')
del(encounters)
# patients table
# Calculate Ratio
patients['COV_EXP_RATIO'] = patients['HEALTHCARE_COVERAGE']/patients['HEALTHCARE_EXPENSES']
# delete columns
patients = patients.drop(['HEALTHCARE_COVERAGE', 'HEALTHCARE_EXPENSES'], axis=1)
insert_tables.append(patients)
insert_table_names.append('patients')
del(patients)
print("Successfully Transformed Data")
# LOADING
# create new database locally in public location
public_path = '/content/gdrive/Shareddrives/IMECOS_public'
conn_new = create_connection_local(public_path)
cur_new = conn_new.cursor()
print("Successfully Connected to SQLite Public Data Warehouse")

# load tables
import itertools
for (actual_table, actual_name) in zip(insert_tables, insert_table_names):
  actual_table.to_sql(actual_name, conn_new, if_exists='replace', index=False)
conn_new.commit()
print("Loaded research data")
del(insert_tables)
del(insert_table_names)

# calculate and display hash sum for each table
from pandas.util import hash_pandas_object
df_encounters = pd.read_sql_query("SELECT * FROM encounters", conn_new)
encounterDFhashes = hash_pandas_object(df_encounters)
del(df_encounters)
print('encounters : ', encounterDFhashes.sum())
del(encounterDFhashes)
df_patients = pd.read_sql_query("SELECT * FROM patients", conn_new)
patientsDFhashes = hash_pandas_object(df_patients)
del(df_patients)
print('patients : ', patientsDFhashes.sum())
del(patientsDFhashes)
df_payers = pd.read_sql_query("SELECT * FROM payers", conn_new)
payersDFhashes = hash_pandas_object(df_payers)
del(df_payers)
print('payers : ', payersDFhashes.sum())
del(payersDFhashes)
df_code_master = pd.read_sql_query("SELECT * FROM code_master", conn_new)
code_masterDFhashes = hash_pandas_object(df_code_master)
del(df_code_master)
print('code_master : ', code_masterDFhashes.sum())
del(code_masterDFhashes)
print("Successfully finished ETL process")
print("""Research database ready for work
  
      conn_new    -    is the name of the connection object
      cur_new     -    is the name of the cursor
      
      """)
