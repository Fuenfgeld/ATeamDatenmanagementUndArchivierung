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
print("""Research database ready for work
  
      conn_new    -    is the name of the connection object
      cur_new     -    is the name of the cursor
      
      """)
