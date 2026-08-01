-- -------------------------
-- E-COMMERCE SALES ANALYSIS
-- -------------------------

-- ------------------
-- SECTION-1 OVERVIEW
-- ------------------

-- Q1. Total Number of Orders
SELECT COUNT(*) AS total_orders
FROM ecommerce;

-- Q2. Total Revenue
SELECT SUM(total_purchase_amount) AS total_revenue
FROM ecommerce;

-- Q3. Average Order Value
SELECT ROUND(AVG(total_purchase_amount), 2) AS average_order_value
FROM ecommerce;

-- Q4. Total Unique Customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM ecommerce;

-- Q5. Average Quantity Purchased
SELECT ROUND(AVG(quantity), 2) AS average_quantity
FROM ecommerce;

-- ----------------------
-- SECTION-2 SALES ANALYSIS
-- ----------------------

-- Q6. Total Revenue by Product Category
SELECT product_category,
       SUM(total_purchase_amount) AS total_revenue
FROM ecommerce
GROUP BY product_category
ORDER BY total_revenue DESC;

-- Q7. Number of Orders by Product Category
SELECT product_category,
       COUNT(*) AS total_orders
FROM ecommerce
GROUP BY product_category
ORDER BY total_orders DESC;

-- Q8. Average Order Value by Product Category
SELECT product_category,
       ROUND(AVG(total_purchase_amount),2) AS avg_order_value
FROM ecommerce
GROUP BY product_category
ORDER BY avg_order_value DESC;

-- Q9. Top 10 Highest Revenue Orders
SELECT customer_id,
       customer_name,
       product_category,
       total_purchase_amount
FROM ecommerce
ORDER BY total_purchase_amount DESC
LIMIT 10;

-- Q10. Monthly Revenue
SELECT month_name,
       SUM(total_purchase_amount) AS revenue
FROM ecommerce
GROUP BY month, month_name
ORDER BY month;

-- Q11. Monthly Number of Orders
SELECT month_name,
       COUNT(*) AS total_orders
FROM ecommerce
GROUP BY month, month_name
ORDER BY month;

-- Q12. Highest Selling Day of the Week
SELECT day,
       COUNT(*) AS total_orders
FROM ecommerce
GROUP BY day
ORDER BY total_orders DESC;

-- Q13. The payment method that generated the highest total revenue
SELECT payment_method,
       SUM(total_purchase_amount) AS total
FROM ecommerce
GROUP BY payment_method
ORDER BY total DESC;

-- ---------------------------
-- SECTION-3 CUSTOMER ANALYSIS
-- ---------------------------

-- Q14. Top 10 Customers by Total Spending
SELECT customer_id,
       customer_name,
       SUM(total_purchase_amount) AS total_spent
FROM ecommerce
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 10;

-- Q15. Average Spending by Gender
SELECT gender,
       ROUND(AVG(total_purchase_amount),2) AS avg_spending
FROM ecommerce
GROUP BY gender;

-- Q16. Revenue by Gender
SELECT gender,
       SUM(total_purchase_amount) AS total_revenue
FROM ecommerce
GROUP BY gender
ORDER BY total_revenue DESC;

-- Q17. Revenue by Age Group
SELECT
CASE
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 45 THEN '36-45'
    WHEN age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
END AS age_group,
SUM(total_purchase_amount) AS revenue
FROM ecommerce
GROUP BY age_group
ORDER BY revenue DESC;

-- Q18. Average Purchase Amount by Age Group
SELECT
CASE
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 45 THEN '36-45'
    WHEN age BETWEEN 46 AND 55 THEN '46-55'
    ELSE '56+'
END AS age_group,
ROUND(AVG(total_purchase_amount),2) AS avg_purchase
FROM ecommerce
GROUP BY age_group
ORDER BY avg_purchase DESC;

-- Q19. Customers with More Than One Purchase
SELECT customer_id,
       customer_name,
       COUNT(*) AS total_orders
FROM ecommerce
GROUP BY customer_id, customer_name
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

-- Q20. Top 5 Customers by Number of Orders
SELECT customer_id,
       customer_name,
       COUNT(*) AS total_orders
FROM ecommerce
GROUP BY customer_id, customer_name
ORDER BY total_orders DESC
LIMIT 5;

-- ------------------------------------
-- SECTION-4 RETURNS AND CHURN ANALYSIS
-- ------------------------------------

-- Q21. Overall Return Rate
SELECT
    ROUND(AVG(returns) * 100, 2) AS return_rate_percentage
FROM ecommerce;

-- Q22. Return Rate by Product Category
SELECT product_category,
       ROUND(AVG(returns) * 100, 2) AS return_rate
FROM ecommerce
GROUP BY product_category
ORDER BY return_rate DESC;

-- Q23. Overall Churn Rate
SELECT
    ROUND(AVG(churn) * 100, 2) AS churn_rate_percentage
FROM ecommerce;

-- Q24. Churn Rate by Gender
SELECT gender,
       ROUND(AVG(churn) * 100, 2) AS churn_rate
FROM ecommerce
GROUP BY gender
ORDER BY churn_rate DESC;

-- Q25. Revenue Lost from Churned Customers
SELECT
    SUM(total_purchase_amount) AS churned_customer_revenue
FROM ecommerce
WHERE churn = 1;

-- ----------------------
-- SECTION-5 ADVANCED SQL
-- ----------------------

-- Q26. Rank Customers by Total Spending 
SELECT
    customer_id,
    customer_name,
    SUM(total_purchase_amount) AS total_spent,
    RANK() OVER (
        ORDER BY SUM(total_purchase_amount) DESC
    ) AS customer_rank
FROM ecommerce
GROUP BY customer_id, customer_name;

-- Q27. Top Customer in Each Product Category 
SELECT *
FROM (
    SELECT
        product_category,
        customer_name,
        SUM(total_purchase_amount) AS total_spent,
        ROW_NUMBER() OVER (
            PARTITION BY product_category
            ORDER BY SUM(total_purchase_amount) DESC
        ) AS rn
    FROM ecommerce
    GROUP BY product_category, customer_name
) t
WHERE rn = 1;

-- Q28. Revenue Contribution of Each Category
SELECT
    product_category,
    SUM(total_purchase_amount) AS revenue,
    ROUND(
        SUM(total_purchase_amount) * 100 /
        (SELECT SUM(total_purchase_amount) FROM ecommerce),
        2
    ) AS revenue_percentage
FROM ecommerce
GROUP BY product_category
ORDER BY revenue DESC;

-- Q29.Ranking Customers by Spending
WITH customer_sales AS
(
    SELECT
        customer_id,
        customer_name,
        SUM(total_purchase_amount) AS total_spent
    FROM ecommerce
    GROUP BY customer_id, customer_name
)
SELECT *,
       DENSE_RANK() OVER
       (
           ORDER BY total_spent DESC
       ) AS ranking
FROM customer_sales;

-- Q30. Monthly Running Revenue 
SELECT
    month,
    month_name,
    SUM(total_purchase_amount) AS revenue,
    SUM(SUM(total_purchase_amount))
        OVER (ORDER BY month) AS running_revenue
FROM ecommerce
GROUP BY month, month_name
ORDER BY month;





