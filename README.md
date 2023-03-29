# Credit-Card-Churn-Analysis

![image](https://user-images.githubusercontent.com/92436079/228472373-b3d63413-fdd6-400b-a264-97177c8f7e46.png)

Analysing  bank credit card data and predict which group of customers are more likely to get churned so that we can target them to provide better services and turn customers' decisions in the opposite direction using MySQL and Tableau

Credit cards play an essential role in the banking world. As customers, we might scratch credit cards with the best offers and financial security. 

[Data Source](https://www.kaggle.com/datasets/sakshigoyal7/credit-card-customers)

## Data Description
The table consists of 18 columns and 10127 rows 

+ Customer_Age - Demographic variable - Customer's Age in Years
+ Gender - Demographic variable - M=Male, F=Female
+ Dependent_count - Demographic variable - Number of dependents
+ Education_Level - Demographic variable - Educational Qualification of the account holder (example: high school, college graduate, etc.)
+ Marital_Status - Demographic variable - Married, Single, Unknown
+ Income_Category - Demographic variable - Annual Income Category of the account holder (<  40K,40K - 60K,  60K-80K,  80K−120K, > $120K, Unknown)
+ Card_Category - Product Variable - Type of Card (Blue, Silver, Gold, Platinum)
+ Months_on_book - Months on book (Time of Relationship)
+ Total_Relationship_Count - Total no. of products held by the customer
+ Months_Inactive_12_mon - No. of months inactive in the last 12 monthsContacts_Count_12_mon - No. of Contacts in the last 12 months
+ Credit_Limit - Credit Limit on the Credit Card
+ Total_Revolving_Bal - Total Revolving Balance on the Credit Card
+ Avg_Open_To_Buy - Open to Buy Credit Line (Average of last 12 months)
+ Total_Amt_Chng_Q4_Q1 - Change in Transaction Amount (Q4 over Q1)
+ Total_Trans_Amt - Total Transaction Amount (Last 12 months)
+ Total_Trans_Ct - Total Transaction Count (Last 12 months)
+ Total_Ct_Chng_Q4_Q1 Num Change in Transaction Count (Q4 over Q1)
+ Avg_Utilization_Ratio - Average Card Utilization Ratio

## Objectives
1). Analysis based on Demographic Variables

2). Analysis based on Product Variables 

``` sql
SELECT *
FROM churncostomerseda.bankchurners;
DESCRIBE churncostomerseda.bankchurners;
```

![image](https://user-images.githubusercontent.com/92436079/228345475-f991c52f-955f-4d10-a586-7eb60ecba272.png)

**General Overview**
```sql
SELECT 
round(COUNT(CASE WHEN Attrition_Flag = '1' THEN Clientnum END) / COUNT(Clientnum),2) * 100 AS churn_rate,
round(COUNT(CASE WHEN Attrition_Flag = '0' THEN Clientnum END) / COUNT(Clientnum),2) * 100 AS retention_rate
FROM churncostomerseda.bankchurners;
``` 
![image](https://user-images.githubusercontent.com/92436079/228463715-3361e27d-c506-4bfd-a998-c4c29c184e29.png)

## Data Cleaning
**Checking for misssing values**

```sql
SELECT *
FROM churncostomerseda.bankchurners
WHERE CLIENTNUM is NULL OR Attrition_Flag IS NULL OR Customer_Age IS NULL OR Gender IS NULL OR Dependent_count is NULL OR Education_Level IS NULL OR Marital_Status IS Null;
```
+ No missing values

**Unique Customers**
```sql
SELECT 
DISTINCT CLIENTNUM
FROM churncostomerseda.bankchurners;
```
+ There's a total of  unique 10127 customers

## Demographic Variables

### Column Manipulation
**Transforming the Attrition flag column into 1 and 0 using  CASE statement**

```sql
SELECT 
COUNT(Attrition_FLag) AS existing_customer_count
FROM churncostomerseda.bankchurners
WHERE Attrition_Flag ='Existing Customer';
```
+ There are 8500 existing customers
```sql
SELECT 
COUNT(Attrition_Flag) AS churned_customer_count
FROM churncostomerseda.bankchurners
WHERE Attrition_Flag ='Attrited Customer';
```
+ There are 1627 churned customers

```sql
SELECT
Attrition_FLag,
CASE 
WHEN Attrition_FLag ='Attrited Customer' THEN 1 
ELSE 0 END AS attrited_customer
FROM churncostomerseda.bankchurners
GROUP BY Attrition_Flag;
```

```
UPDATE churncostomerseda.bankchurners
SET Attrition_Flag=CASE 
WHEN Attrition_FLag ='Attrited Customer' THEN 1 
ELSE 0 END;
```
```sql
SELECT 
Attrition_Flag
FROM churncostomerseda.bankchurners
GROUP BY Attrition_Flag;
```

![image](https://user-images.githubusercontent.com/92436079/228347641-a6188a51-e2c6-4082-883c-88c3cb397943.png)

**Customer Age**

```sql
SELECT 
MAX(Customer_Age) AS max_age,
MIN(Customer_Age) AS min_age
FROM churncostomerseda.bankchurners;
```
+ The eldest customer is 73 while the youngest is 26
```sql
SELECT 
Customer_Age,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END))) * 100, 2), '%') AS retention_rate
FROM churncostomerseda.bankchurners
GROUP BY Customer_Age
ORDER BY Customer_Age ASC;
```
![image](https://user-images.githubusercontent.com/92436079/228359778-457c97cd-a3e5-4600-bdf5-783feeb0ac9d.png)

![Age (1)](https://user-images.githubusercontent.com/92436079/228358020-6d0759ed-a3f1-4b7c-994c-b7d2c4290ec5.png)

**26-40**
+ The churn rate increases as the age of customers increases from 26 to 40, then decreases gradually as the customers get older, from 40 to 67. On the other hand, we can observe that the retention rate decreases as the customers get more senior, from 26 to 40, and then increases gradually as the customers get older, from 40 to 67.
+ One possible explanation for this trend is that younger customers (aged 26-40) may be more likely to churn because they are more likely to switch to other providers or cancel their subscriptions due to changing circumstances, such as moving or changing jobs. As customers get older (aged 40-67), they may become more established in their current affairs, and their loyalty to the provider may increase.
+ Additionally, other factors may be at play that could impact the churn and retention rates, such as the quality of the provider's services or changes in the market.

**60-70**
+ The churn rate gradually increases, and the retention rate gradually decreases as the customer ages 60 to 75. Indicating that customers in this age group are likelier to churn and less likely to be retained than younger customers.
+ There could be several reasons why this trend occurs. Older customers may have different needs and preferences than younger customers, which the company's products or services may need to meet. Older customers may also be more price-sensitive and less likely to spend money on non-essential items, which could lead to them canceling their subscriptions or not renewing their contracts.
+ Another factor could be changed in life circumstances, such as retirement or health issues, which may affect their ability or willingness to continue using the company's products or services. Additionally, older customers may be more likely to have experienced problems or issues with the company's products or services, which could contribute to their decision to churn

**Gender**

```sql
SELECT 
Gender,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Gender
ORDER BY Gender ASC;
```
![image](https://user-images.githubusercontent.com/92436079/228359484-d492ce1b-da7f-46c5-834f-8b970acdd08e.png)

![Gender (1)](https://user-images.githubusercontent.com/92436079/228363813-5e3b748c-753f-4925-bb4c-1b2d9d7af03f.png)


+ Female Customers have the highest churn rate of 17.36% a slightly higher rate compared to men with 14.62%


**Dependent Count** 

```sql
SELECT 
Dependent_count,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Dependent_count
ORDER BY Dependent_count ASC;
```

![image](https://user-images.githubusercontent.com/92436079/228363655-dfb64890-598f-4735-b80c-f2e79b3264e6.png)

![Dependent](https://user-images.githubusercontent.com/92436079/228364311-b3626baa-a7eb-42e8-a58e-16054e4e5acd.png)


+ Customers with 3 depedents having the highest rate of 17.64% while lowest churn rate is for customers with 5 dependents (15.09%). 
+ However, the differences in churn rates between the different groups are relatively small. Overall, the churn rates for all the groups are fairly similar, ranging from 14.64% to 17.64%. 
+ Therefore, the number of dependents does not significantly impact the customer churn rate in this dataset.

**Education Level**

```sql
SELECT 
Education_Level,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Education_Level
ORDER BY Education_Level ASC;
```

![image](https://user-images.githubusercontent.com/92436079/228409575-dc211745-d8cf-41d3-8559-2f2f935b27ca.png)


+ Customers with Doctorate level of education have the highest churn rate of 21.06% followed by those with postgraduate at 17.83%

**Marital Status**

```sql
SELECT 
Marital_Status,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Marital_Status
ORDER BY Marital_Status ASC;
```

![image](https://user-images.githubusercontent.com/92436079/228410962-8457cb7c-cedb-494a-be66-9cf8e1d6d0e5.png)

+ The marital status churn rate ranges from 15.18%-17.22%,with the unknown having the highest rate followed by the single customers.
+ The churn rate between the groups is relatively small,therefore marital status does not significantly impact the churn rate.

**Income Category**
```sql
SELECT 
Income_Category,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) -SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS difference,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Income_Category
ORDER BY Income_Category ASC;
```

![image](https://user-images.githubusercontent.com/92436079/228415019-bac583db-f956-42e3-948e-9fe145b7d5e1.png)

+ Customers earning $120K+ had the highest churn rate of 17.33%,Followed by customers earning less than $40K have the highest churn rate of 17.19%.
+ The difference between existing and attrited customers is low for that income bracket, but then again.
+ Other factors such as customer satisfaction, pricing, customer service, product, service quality, and competition should also be considered to understand better why customers are leaving and how to improve retention.


## Product Variables

**Card category**

```sql
SELECT 
Card_Category,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) -SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS difference,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Card_Category
ORDER BY Card_Category ASC;
```

+ The Platinum card has the highest churn rate of 25.00%, followed by the Gold card at 18.10%, the Blue card at 16.10%, and the Silver card at 14.77%.
+ A difference between existing and churned customers can lead to a higher churn rate. For instance, the Gold card has a relatively small difference of 74, but it has a high churn rate of 18.10%, maybe due to various factors, such as dissatisfaction with the service or better offers from competitors.

**Months_on_book** 

```sql
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
```

![image](https://user-images.githubusercontent.com/92436079/228416475-b86f8930-169e-4d46-958b-b2e07d29fa1d.png).

![Months](https://user-images.githubusercontent.com/92436079/228417862-b2aa9f9b-13c0-4058-992e-64e918568107.png)


+ The number of months a customer has been on the book increases, and the retention rate also increases.
+ For customers who have been on the book for 13 months, the retention rate is 90%, and the churn rate is 10%. However, for customers who have been on the book for 56 months, the retention rate is 83.5%, and the churn rate is 16.5%.
+ Fluctuations in the churn and retention rates for different values, for customers who have been on the book for 15 months, the churn rate is relatively high at 26.47%, while the retention rate is 73.53%. Similarly, for customers who have been on the book for 37 months,the churn rate is relatively high at 17.32%, while the retention rate is 82.68%.
+ There may be some specific periods (such as 15 months and 37 months) where the churn rate is relatively high, and the company may need to focus on improving customer retention during those periods.

**Total Relationship Count**
 
```sql
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
```

![image](https://user-images.githubusercontent.com/92436079/228431533-9c7fec9a-d18a-4324-bf5e-66e2e7521e1d.png)

+ As the total relationship count increases, the churn rate decreases, and the retention rate increases. Customers with a total relationship count of 6 have the
highest retention rate at 89.50%, while customers with a total relationship count of 2 have the highest churn rate at 27.84%.
+ Customers with multiple products or services with a company are likelier to stay, while customers with only one product or service are likelier to leave. 
+ It may be worthwhile for the company to encourage customers to sign up for additional products or services to improve retention rates.



**Month Inactive 12 Months Frame**

```sql
SELECT 
Months_Inactive_12_mon,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END))) * 100, 2), '%') AS retention_rate
FROM churncostomerseda.bankchurners
GROUP BY Months_Inactive_12_mon
ORDER BY Months_Inactive_12_mon ASC;
```

![image](https://user-images.githubusercontent.com/92436079/228430756-5a59347a-0444-4f36-8c54-15a5221781c8.png)

![Months (1)](https://user-images.githubusercontent.com/92436079/228431184-5750a718-2e3c-4dcd-be26-387aabe9f5ca.png)


+ The first row, with 0 months of inactivity, shows that 51.72% of the customers who were inactive for 0 months churned, while the remaining 48.28% were retained.
+ As the number of months of inactivity increased, the churn rate and retention rate decreased. For example, when customers were inactive for 1 month, only 4.48% of them churned, while 95.52% were retained. However, when customers were inactive for 4 months, the churn rate was 29.89%, indicating that nearly one-third of the customers who were inactive for 4 months churned.
+ This trend suggests that customer engagement is an essential factor in retaining customers. Customers are more likely to churn as they become less engaged and less active. Therefore, it is crucial for companies to continuously engage and communicate with their customers to keep them satisfied and retain their business

**Customer count within 12 months**

```sql
SELECT 
Contacts_Count_12_mon,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count,
CONCAT(ROUND((SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / (SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) + SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END))) * 100, 2), '%') AS churn_rate
FROM churncostomerseda.bankchurners
GROUP BY Contacts_Count_12_mon
ORDER BY Contacts_Count_12_mon ASC;
```

![image](https://user-images.githubusercontent.com/92436079/228420963-1c890b91-98da-41d3-8c67-aa2c91ce30ea.png)

![Sheet 9](https://user-images.githubusercontent.com/92436079/228429899-e4b8cc9a-554a-4610-aad4-616873b1f179.png)

+ As the number of times the bank contacts the customer increases, the churn rate also tends to increase. For example, customers contacted 5 times had a churn rate of 33.52%, higher than those contacted only once (7.20%). Suggesting excessive contact with customers may lead to dissatisfaction and, ultimately, churn.
+ It is also interesting to note that customers who were contacted 6 times had a 100% churn rate, meaning that all of these customers left the bank—indicating that the bank may have over-contacted these customers or that there were underlying issues with the bank's products or services that led to such high churn rates.
+ These results highlight the importance of balancing customer outreach and engagement to maintain customer satisfaction and prevent churn.

**Transaction Amount**

```sql
SELECT 
Attrition_Flag,
SUM(Total_Trans_Amt) AS total_transaction_amount,
SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) AS churned_customer_count,
SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) AS existing_customer_count
FROM churncostomerseda.bankchurners
GROUP BY Attrition_Flag
ORDER BY SUM(Total_Trans_Amt) DESC;
```
![image](https://user-images.githubusercontent.com/92436079/228430150-4972523c-5835-4d11-984e-933c7f2ef42d.png)

+ Existing customers transact more the the attrited customers

**Average Utilization Ratio**

```sql
SELECT 
CONCAT(ROUND(SUM(CASE WHEN Attrition_Flag = '1' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2), '%') AS churned_customer_percentage,
CONCAT(ROUND(SUM(CASE WHEN Attrition_Flag = '0' THEN 1 ELSE 0 END) / COUNT(*) * 100, 2), '%') AS existing_customer_percentage
FROM churncostomerseda.bankchurners;
```

![image](https://user-images.githubusercontent.com/92436079/228430990-e9eedda0-77df-416e-9b13-c249fb03bd4a.png)

+ The lesser the utilization of the card the higher the chances of attrition



