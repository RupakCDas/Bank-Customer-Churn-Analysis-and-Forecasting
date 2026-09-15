CREATE TABLE cust_data (
    customer VARCHAR(20),
    credit_score INT,
    geography  VARCHAR(20),
    gender VARCHAR(20),
    age INT,
    tenure INT,
    balance INT,
    num_products INT,
	  has_cr_card VARCHAR(50),
	  is_active_member VARCHAR(50),
	  estimated_salary INT,
	  exited INT );
    
SELECT * FROM cust_data;

-- 1. Overall churn rate-------------------------------------------------------
SELECT COUNT(*) AS total_customer,
	ROUND(AVG(exited),2) * 100 AS churn_rate_pct
FROM cust_data;
    
-- 2. Churn rate and balance-at-risk by geography------------------------------
SELECT  geography,
	COUNT(*) AS geo_total_customer,
	SUM(balance) AS geo_total_bal,
    ROUND(AVG(exited),2) * 100 AS geo_churn_rate_pct,
    ROUND(SUM(CASE WHEN exited = 1 THEN balance ELSE 0 END),2) AS balance_at_risk
FROM cust_data
GROUP BY geography
ORDER BY geo_churn_rate_pct DESC;

-- 3. Churn rate by age group--------------------------------------------------
SELECT 
    CASE WHEN age<30 THEN ' AGE<30' 
		WHEN age<40 THEN 'AGE 30-39' 
		WHEN age<50 THEN 'AGE 40-49'
		WHEN age<60 THEN 'AGE 50-59' 
		ELSE 'AGE 60+' END AS age_group,
    COUNT(*) AS customers,
    ROUND(AVG(exited)*100, 2) AS churn_rate_pct_by_age
FROM cust_data
GROUP BY age_group
ORDER BY churn_rate_pct_by_age DESC;

-- 4. Churn by activity status-------------------------------------------------
SELECT
    is_active_member,
    COUNT(*) AS customers,
    ROUND(AVG(exited)*100, 2) AS churn_rate_pct
FROM cust_data
GROUP BY is_active_member
ORDER BY churn_rate_pct DESC;

-- 5. Total balance at risk from customers who already churned---------------------------------------
SELECT 
	geography,
	ROUND(SUM(CASE WHEN exited=1 THEN balance ELSE 0 END), 0) AS total_balance_at_risk
FROM cust_data
GROUP BY geography;
