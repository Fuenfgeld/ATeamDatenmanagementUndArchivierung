print("Documentation of SQL-Queries for Data Clearing Issues")
print("""Type
> data_clearing_queries()
with the desired Issue# as argument to see the SQL-Script and query result.""")
print("Possible issue#s: 12, 13, 15, 30")

def data_clearing_queries(issue_number):
  # fill list with empty values
  sql = []
  fillcounter = 0
  while fillcounter <=30:
    sql.append(None)
    fillcounter +=1
  # define SQL queries for specific issue numbers
  ##12
  sql[12] = """
SELECT Id,
       count(Id)
FROM tb_patients
GROUP BY Id
HAVING (COUNT(Id) > 1)
  """
  ##13
  sql[13] = """
SELECT MIN(calc.percentage_explainable),
       MAX(calc.percentage_explainable),
       AVG(calc.percentage_explainable)
FROM
(
    SELECT tb_patients.Id,
           encounters_total_cost_sum.value,
           tb_patients.healthcare_expenses,
           (encounters_total_cost_sum.value / ROUND(tb_patients.healthcare_expenses, 2)) * 100 AS percentage_explainable
    FROM tb_patients,
    (
        SELECT tb_encounters.patient_id,
               tb_encounters.patient_dso,
               ROUND(SUM(tb_encounters.total_claim_cost), 2) AS value
        FROM tb_encounters
        GROUP BY tb_encounters.patient_id,
                 tb_encounters.patient_dso
    ) encounters_total_cost_sum
    WHERE tb_patients.Id = encounters_total_cost_sum.patient_id
          AND tb_patients.dataset_origin = encounters_total_cost_sum.patient_dso
) calc
  """
  ##15
  sql[15] = """
SELECT *
FROM tb_encounters
WHERE base_encounter_cost < total_claim_cost
  """
  ##30
  sql[30] = """
SELECT *
FROM tb_payers
ORDER BY Id
  """
  # print SQL-Query and corresponding response from database
  print("The SQL-Statement used to resolve the given Issue Number is:")
  print(sql[issue_number])
  print(" ")
  print("The database gives out the following response upon this query:")
  cur.execute(sql[issue_number])
  for row in cur.fetchall():
    print(row)
