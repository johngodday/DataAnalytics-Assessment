########################################################################################################
########################################################################################################
########################### Assessmen Q4 ###############################################################


#-----------------------------------------------------------------------------------------------------------------------------
#The First common Table Expression Creates a table that holds customers aggregated transaction and average
#profit per transaction done
#----------------------------------------------------------------------------------------------------------------------
WITH transaction_aggregation AS (
    SELECT 
        users.id AS customer_id,
        CONCAT(first_name, ' ', last_name) AS name, 
        TIMESTAMPDIFF(MONTH, date_joined, CURDATE()) AS tenure_months,
        COUNT(savings.id) AS total_transactions,
        AVG((confirmed_amount / 1000)) AS avg_profit_per_transaction
    FROM 
        users_customuser users
    LEFT JOIN 
        savings_savingsaccount savings 
        ON users.id = savings.owner_id
    WHERE 
        transaction_status = 'Success' 
        AND confirmed_amount > 0
    GROUP BY 
       1,
       2,
       3
)
#-----------------------------------------------------------------------------------------------------------------------------
#Query Final Out:- Showing Estmated CLV
#----------------------------------------------------------------------------------------------------------------------
SELECT  
    customer_id, 
    name,
    tenure_months,
    total_transactions,
    ROUND(
        ((total_transactions / NULLIF(tenure_months, 0)) * 12 * avg_profit_per_transaction),
        2
    ) AS estimated_clv
FROM 
    transaction_aggregation
ORDER BY 
    estimated_clv DESC;