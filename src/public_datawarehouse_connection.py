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

# SQLite connection memory
def create_connection_memory():
  conn = None;
  try:
    #Establishing the connection
    conn = sq.connect(':memory:')
    return conn
    print(sqlite3.version)
  except Error as e:
    print("Error while connecting to sqlite", e)
# SQLite connection definition local (needed later for public database)
def create_connection_local(local_path):
  conn = None;
  try:
    #Establishing the connection
    conn = sq.connect(local_path+'/imecos_public.db')
    return conn
    print(sqlite3.version)
  except Error as e:
    print("Error while connecting to sqlite", e) 
conn_new = create_connection_local('/content/gdrive/MyDrive')
# Creating a cursor object using the cursor() method
cur_new = conn_new.cursor()
print("Successfully Connected to SQLite Public Data Warehouse")

# calculate and display hashsum for each table
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
print("""Research database ready for work
  
      conn_new    -    is the name of the connection object
      cur_new     -    is the name of the cursor
      
      """)
