SELECT *
FROM churncostomerseda.bankchurners;
DESCRIBE churncostomerseda.bankchurners;
/*data cleaning*/
-- checking for misssing values
SELECT *
FROM churncostomerseda.bankchurners
WHERE CLIENTNUM is NULL OR Attrition_Flag IS NULL OR Customer_Age IS NULL OR Gender IS NULL OR Dependent_count is NULL OR Education_Level IS NULL OR Marital_Status IS Null;
-- there are no missing values

/*unique Customers
There's a total of 10127 customers*/
SELECT 
DISTINCT CLIENTNUM
FROM churncostomerseda.bankchurners;

SELECT 
concat(round(COUNT(CASE WHEN Attrition_Flag = '1' THEN Clientnum END) / COUNT(Clientnum),2) * 100,'%') AS churn_rate,
concat(round(COUNT(CASE WHEN Attrition_Flag = '0' THEN Clientnum END) / COUNT(Clientnum),2) * 100,'%') AS retention_rate
FROM churncostomerseda.bankchurners;

/*Column Manipulation
transforming the customer_age column into bins using the case statement*/
SELECT 
COUNT(Attrition_FLag) AS existing_customer_count
FROM churncostomerseda.bankchurners
WHERE Attrition_Flag ='Existing Customer';
-- there are 8500 existing customers
SELECT 
COUNT(Attrition_Flag) AS churned_customer_count
FROM churncostomerseda.bankchurners
WHERE Attrition_Flag ='Attrited Customer';
-- there are 1627 churned customers indicating high imbalance
SELECT
Attrition_FLag,
CASE 
WHEN Attrition_FLag ='Attrited Customer' THEN 1 
ELSE 0 END AS attrited_customer
FROM churncostomerseda.bankchurners
GROUP BY Attrition_Flag;

UPDATE churncostomerseda.bankchurners
SET Attrition_Flag=CASE 
WHEN Attrition_FLag ='Attrited Customer' THEN 1 
ELSE 0 END;
SELECT 
Attrition_Flag
FROM churncostomerseda.bankchurners
GROUP BY Attrition_Flag;
-- customer Age
SELECT 
MAX(Customer_Age) AS max_age,
MIN(Customer_Age) AS min_age
FROM churncostomerseda.bankchurners;
-- the eldest customer is 73 while the youngest is 26

SELECT 
Customer_Age,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END))) * 100, 2), '%') AS retention_rate
FROM churncostomerseda.bankchurners
GROUP BY Customer_Age
ORDER BY Customer_Age ASC;

SELECT 
Gender,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Gender
ORDER BY Gender ASC;

SELECT 
Dependent_count,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Dependent_count
ORDER BY Dependent_count ASC;

SELECT 
Education_Level,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Education_Level
ORDER BY Education_Level ASC;

SELECT 
Marital_Status,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Marital_Status
ORDER BY Marital_Status ASC;

SELECT 
Income_Category,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) -SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS difference,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Income_Category
ORDER BY Income_Category ASC;

SELECT 
Card_Category,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) -SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS difference,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Card_Category
ORDER BY Card_Category ASC;

SELECT 
Months_on_book,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) -SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS difference,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END))) * 100, 2), '%') AS retention_rate
FROM churncostomerseda.bankchurners
GROUP BY Months_on_book
ORDER BY Months_on_book ASC;

SELECT 
Total_Relationship_Count,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) -SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS difference,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END))) * 100, 2), '%') AS retention_rate
FROM churncostomerseda.bankchurners
GROUP BY Total_Relationship_Count
ORDER BY Total_Relationship_Count ASC;

SELECT 
Months_Inactive_12_mon,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END))) * 100, 2), '%') AS retention_rate
FROM churncostomerseda.bankchurners
GROUP BY Months_Inactive_12_mon
ORDER BY Months_Inactive_12_mon ASC;

SELECT 
Contacts_Count_12_mon,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Contacts_Count_12_mon
ORDER BY Contacts_Count_12_mon ASC;

SELECT 
Attrition_Flag,
SUM(Total_Trans_Amt) AS total_transaction_amount,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count
FROM churncostomerseda.bankchurners
GROUP BY Attrition_Flag
ORDER BY SUM(Total_Trans_Amt) DESC;

SELECT 
CONCAT(ROUND(SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2), '%') AS churned_customer_percentage,
CONCAT(ROUND(SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2), '%') AS existing_customer_percentage
FROM churncostomerseda.bankchurners;


