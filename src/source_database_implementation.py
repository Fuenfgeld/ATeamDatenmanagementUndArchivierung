## file to import in IMECOS_master and run in GOOGLE COLAB environment
# import libraries
import sqlite3 as sq
from sqlite3 import Error
import pandas as pd
import numpy as np
import requests

#mount drive to access data
from google.colab import drive 
drive.mount("/content/gdrive", force_remount=True)

# SQLite connection
def create_connection_memory():
  conn = None;
  try:
    #Establishing the connection
    conn = sq.connect(':memory:')
    return conn
    print(sqlite3.version)
  except Error as e:
    print("Error while connecting to sqlite", e)
conn = create_connection_memory()
# Creating a cursor object using the cursor() method
cur = conn.cursor()
print("Successfully Connected to SQLite")

# Create all tables
sql_create_source_data = requests.get('https://raw.githubusercontent.com/Fuenfgeld/ATeamDatenmanagementUndArchivierung/main/tools/create_statements_source_db.sql').text
cur.executescript(sql_create_source_data)
conn.commit()
print("Successfully created tables in the database")

# define datasets and file paths
file_path = '/content/gdrive/Shareddrives/IMECOS/csv_data.zip (Unzipped Files)/csv_data/'
disease = ['allergy', 'asthma', 'breast_cancer', 'colorectal_cancer', 'covid19', 'dermatitis', 'lung_cancer', 'metabolic_syndrome_disease']
dataset_file = ['patients', 'organizations', 'providers', 'payers', 'payer_transitions', 'encounters', 'careplans', 'conditions', 'devices', 'disease', 'imaging_studies', 'immunizations', 'observations', 'procedures', 'supplies', 'medications']

# read all .csv files of each dataset and write them into the database
for actual_disease in disease:
  actual_file_path = file_path+actual_disease+'/'
  for actual_dataset_file in dataset_file:
    actual_insert_df = pd.read_csv(actual_file_path+actual_dataset_file+'.csv')
    actual_insert_df = actual_insert_df.rename(columns={'PATIENT': 'patient_id', 'PAYER': 'payer_id', 'ENCOUNTER': 'encounter_id', 'ORGANIZATION': 'organization_id', 'PROVIDER': 'provider_id'})
    try:
      actual_insert_df.insert(loc=actual_insert_df.columns.get_loc('patient_id')+1 , column='patient_dso', value=actual_disease)
    except:
      pass
    try:
      actual_insert_df.insert(loc=actual_insert_df.columns.get_loc('payer_id')+1 , column='payer_dso', value=actual_disease)
    except:
      pass
    try:
      actual_insert_df.insert(loc=actual_insert_df.columns.get_loc('encounter_id')+1, column='encounter_dso', value=actual_disease)
    except:
      pass
    try:
      actual_insert_df.insert(loc=actual_insert_df.columns.get_loc('organization_id')+1, column='organization_dso', value=actual_disease)
    except:
      pass
    try:
      actual_insert_df.insert(loc=actual_insert_df.columns.get_loc('provider_id')+1, column='provider_dso', value=actual_disease)
    except:
      pass
    actual_insert_df.insert(loc=len(actual_insert_df.columns), column='dataset_origin', value=actual_disease)
    actual_insert_df.to_sql('tb_'+actual_dataset_file, conn, if_exists='append', index=False)
conn.commit()
print("Successfully inserted source data")
print("""Source database ready for work
  
      conn    -    is the name of the connection object
      cur     -    is the name of the cursor
      
      """)
