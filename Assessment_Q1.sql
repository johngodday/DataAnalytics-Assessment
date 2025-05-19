

####################################################################################################################################
####################################################################################################################################
########################### Assessmen Q1 ###########################################################################################

#-----------------------------------------------------------------------------------------------------------------------------
#The First common Table Expression Creates a table that holds customers plan (Savings/Investment) with Cowrywise
#Excluding Staff accounts and Inactive accounts, focusing our data retrival on only customers that are active by status
#-----------------------------------------------------------------------------------------------------------------------------

WITH customers_plan AS (
    SELECT
        u.id AS customer_id,
        concat(u.first_name,' ', u.last_name) as name,
        u.phone_number,
        u.username,
        CASE
            WHEN p.is_regular_savings = 1 THEN 'Savings Plan'
            WHEN p.is_a_fund = 1 THEN 'Investment Plan'
        END AS plan_tag,
        p.id AS customer_plan_id
    FROM 
        users_customuser u
    JOIN 
        plans_plan p ON u.id = p.owner_id
    WHERE 
        u.is_staff != 1
        AND u.is_active != 0
        AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
),

#This CTE sums up customer's successful transactions.
customer_deposits AS (
    SELECT
        cp.customer_id,
        SUM(s.confirmed_amount) AS total_deposits
    FROM 
        customers_plan cp
    LEFT JOIN 
        savings_savingsaccount s
        ON cp.customer_id = s.owner_id
        AND cp.customer_plan_id = s.plan_id
    WHERE 
        s.transaction_status = 'success'
        AND confirmed_amount > 0
    GROUP BY 
        cp.customer_id
),
#---------------------------------------------------------------------------------------------------
#This CTE counts the total number of savings/investments plan each cutomer is running
#---------------------------------------------------------------------------------------------------
plan_counts AS (
    SELECT
        customer_id,
        name,
        SUM(CASE WHEN plan_tag = 'Savings Plan' THEN 1 ELSE 0 END) AS savings_count,
        SUM(CASE WHEN plan_tag = 'Investment Plan' THEN 1 ELSE 0 END) AS investment_count
    FROM 
        customers_plan
    GROUP BY 
        customer_id,
        name
)
#---------------------------------------------------------------------------------------------------
#Final Output:- Showing count of customers  with atleast one or more savings/investments plan 
#and the total sum of deposits done by each customer
#---------------------------------------------------------------------------------------------------
SELECT
    pc.customer_id as owner_id,
    pc.name,
    pc.savings_count,
    pc.investment_count,
    ROUND(cd.total_deposits, 2) AS total_deposits
FROM 
    plan_counts pc
LEFT JOIN 
    customer_deposits cd
    ON pc.customer_id = cd.customer_id
WHERE 
    pc.savings_count >= 1 
    AND pc.investment_count >= 1
ORDER BY total_deposits DESC;


