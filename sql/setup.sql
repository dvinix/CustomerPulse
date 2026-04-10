-- Database setup and table creation
-- This file documents the schema created by data_loader.py

-- The customers table is created automatically by pandas.to_sql()
-- with the following structure based on the Telco Customer Churn dataset:

-- CREATE TABLE customers (
--     customerID TEXT,
--     gender TEXT,
--     SeniorCitizen INTEGER,
--     Partner TEXT,
--     Dependents TEXT,
--     tenure INTEGER,
--     PhoneService TEXT,
--     MultipleLines TEXT,
--     InternetService TEXT,
--     OnlineSecurity TEXT,
--     OnlineBackup TEXT,
--     DeviceProtection TEXT,
--     TechSupport TEXT,
--     StreamingTV TEXT,
--     StreamingMovies TEXT,
--     Contract TEXT,
--     PaperlessBilling TEXT,
--     PaymentMethod TEXT,
--     MonthlyCharges REAL,
--     TotalCharges REAL,
--     Churn INTEGER  -- Converted from Yes/No to 1/0
-- );

-- Sample queries for verification
SELECT COUNT(*) as total_customers FROM customers;
SELECT Churn, COUNT(*) as count FROM customers GROUP BY Churn;
