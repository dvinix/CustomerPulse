-- Exploratory Data Analysis Queries
-- Telco Customer Churn Dataset Analysis

-- BUSINESS INSIGHT: Overall churn rate as a percentage
SELECT 
    ROUND(AVG(Churn) * 100, 2) as churn_rate_percent,
    SUM(Churn) as churned_customers,
    COUNT(*) as total_customers
FROM customers;

-- BUSINESS INSIGHT: Churn rate by Contract type (Month-to-month vs One year vs Two year)
SELECT 
    Contract,
    COUNT(*) as customer_count,
    SUM(Churn) as churned_count,
    ROUND(AVG(Churn) * 100, 2) as churn_rate_percent
FROM customers
GROUP BY Contract
ORDER BY churn_rate_percent DESC;

-- BUSINESS INSIGHT: Average MonthlyCharges for churned vs retained customers
SELECT 
    CASE WHEN Churn = 1 THEN 'Churned' ELSE 'Retained' END as customer_status,
    COUNT(*) as customer_count,
    ROUND(AVG(MonthlyCharges), 2) as avg_monthly_charges,
    ROUND(MIN(MonthlyCharges), 2) as min_monthly_charges,
    ROUND(MAX(MonthlyCharges), 2) as max_monthly_charges
FROM customers
GROUP BY Churn
ORDER BY Churn DESC;

-- BUSINESS INSIGHT: Churn rate by tenure bucket (0-12, 13-24, 25-48, 49+ months)
SELECT 
    CASE 
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49+ months'
    END as tenure_bucket,
    COUNT(*) as customer_count,
    SUM(Churn) as churned_count,
    ROUND(AVG(Churn) * 100, 2) as churn_rate_percent
FROM customers
GROUP BY tenure_bucket
ORDER BY 
    CASE 
        WHEN tenure <= 12 THEN 1
        WHEN tenure <= 24 THEN 2
        WHEN tenure <= 48 THEN 3
        ELSE 4
    END;

-- BUSINESS INSIGHT: Top 5 service combinations among churned customers
SELECT 
    InternetService,
    Contract,
    COUNT(*) as churned_customer_count,
    ROUND(AVG(MonthlyCharges), 2) as avg_monthly_charges
FROM customers
WHERE Churn = 1
GROUP BY InternetService, Contract
ORDER BY churned_customer_count DESC
LIMIT 5;

-- BUSINESS INSIGHT: Churn rate by PaymentMethod
SELECT 
    PaymentMethod,
    COUNT(*) as customer_count,
    SUM(Churn) as churned_count,
    ROUND(AVG(Churn) * 100, 2) as churn_rate_percent
FROM customers
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC;

-- BUSINESS INSIGHT: Revenue at risk - total annualized MonthlyCharges for all churned customers
SELECT 
    SUM(Churn) as churned_customers,
    ROUND(SUM(CASE WHEN Churn = 1 THEN MonthlyCharges ELSE 0 END), 2) as monthly_revenue_at_risk,
    ROUND(SUM(CASE WHEN Churn = 1 THEN MonthlyCharges * 12 ELSE 0 END), 2) as annualized_revenue_at_risk
FROM customers;

-- BUSINESS INSIGHT: Customer segments - HIGH_RISK, MEDIUM_RISK, LOW_RISK with churn rates
SELECT 
    CASE 
        WHEN tenure < 12 AND MonthlyCharges > 65 THEN 'HIGH_RISK'
        WHEN tenure < 24 THEN 'MEDIUM_RISK'
        ELSE 'LOW_RISK'
    END as risk_segment,
    COUNT(*) as customer_count,
    SUM(Churn) as churned_count,
    ROUND(AVG(Churn) * 100, 2) as churn_rate_percent,
    ROUND(AVG(MonthlyCharges), 2) as avg_monthly_charges
FROM customers
GROUP BY risk_segment
ORDER BY churn_rate_percent DESC;

-- BUSINESS INSIGHT: Churn rate for customers with NO OnlineSecurity AND NO TechSupport
SELECT 
    CASE 
        WHEN OnlineSecurity = 'No' AND TechSupport = 'No' THEN 'No Security & No Support'
        ELSE 'Has Security or Support'
    END as support_status,
    COUNT(*) as customer_count,
    SUM(Churn) as churned_count,
    ROUND(AVG(Churn) * 100, 2) as churn_rate_percent
FROM customers
GROUP BY support_status
ORDER BY churn_rate_percent DESC;

-- BUSINESS INSIGHT: Average number of services for churned vs retained customers
SELECT 
    CASE WHEN Churn = 1 THEN 'Churned' ELSE 'Retained' END as customer_status,
    COUNT(*) as customer_count,
    ROUND(AVG(
        CASE WHEN PhoneService = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN MultipleLines = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN OnlineSecurity = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN OnlineBackup = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN TechSupport = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN StreamingTV = 'Yes' THEN 1 ELSE 0 END +
        CASE WHEN StreamingMovies = 'Yes' THEN 1 ELSE 0 END
    ), 2) as avg_services_subscribed
FROM customers
GROUP BY Churn
ORDER BY Churn DESC;
