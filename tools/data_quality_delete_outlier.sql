DELETE FROM encounters 
WHERE  patient_id IN (SELECT id 
                      FROM   patients 
                      WHERE  cov_exp_ratio > 1); 

DELETE FROM patients 
WHERE  cov_exp_ratio > 1; 
