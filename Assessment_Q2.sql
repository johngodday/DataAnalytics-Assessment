########################################################################################################
########################################################################################################
########################### Assessmen Q2 ###############################################################

#-----------------------------------------------------------------------------------------------------------------------------
#The First common Table Expression Creates a table that holds customers count of transactions per month
#Including only transactions that are successful
#-----------------------------------------------------------------------------------------------------------------------------
WITH customers_monthly_transactions AS (
    SELECT
        u.id AS customer_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m-01') AS month,
        COUNT(s.id) AS total_monthly_transactions
    FROM 
        users_customuser AS u
    LEFT JOIN 
        savings_savingsaccount AS s
        ON u.id = s.owner_id 
    WHERE 
        s.transaction_status = 'success'
    GROUP BY 
        customer_id, 
        DATE_FORMAT(s.transaction_date, '%Y-%m-01')
),
#-----------------------------------------------------------------------------------------------------------
-- The second Common Table Expression creates a table that holds customer's average monthly transaction
#-----------------------------------------------------------------------------------------------------------
customers_avg_monthly_transaction AS (
    SELECT 
        customer_id,
        ROUND(AVG(total_monthly_transactions), 2) AS avg_monthly_transaction
    FROM 
        customers_monthly_transactions
    GROUP BY 
        customer_id
)
#-----------------------------------------------------------------------------------------------------------------------------
#Query Final output:- Customer segregation by Transaction activities
#-----------------------------------------------------------------------------------------------------------------------------

SELECT 
    CASE
        WHEN avg_monthly_transaction >= 10.0 THEN 'High Frequency'
        WHEN avg_monthly_transaction <= 2.0 THEN 'Low Frequency'
        ELSE 'Medium Frequency'
    END AS frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_monthly_transaction), 1) AS avg_transaction_per_month
FROM 
    customers_avg_monthly_transaction
GROUP BY 
    frequency_category
ORDER BY 
    avg_transaction_per_month DESC;
     