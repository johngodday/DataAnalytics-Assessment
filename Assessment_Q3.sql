########################################################################################################
########################################################################################################
########################### Assessmen Q2 ###############################################################

#-----------------------------------------------------------------------------------------------------------------------------
#Curated Query to checkfor customer latest transaction date
#-----------------------------------------------------------------------------------------------------------------------------
SELECT plan_id,
       owner_id,
       plan_tag AS type,
       transaction_date AS last_transaction_date,
       inactivity_days
FROM
  (SELECT plan.id AS plan_id,
          plan.owner_id,
          transaction_date,
          datediff(CURRENT_DATE, transaction_date) AS inactivity_days,
          CASE
              WHEN plan.is_regular_savings = 1 THEN 'Savings Plan'
              WHEN plan.is_a_fund = 1 THEN 'Investment Plan'
          END AS plan_tag,
          ROW_NUMBER() OVER(PARTITION BY plan.owner_id
                            ORDER BY transaction_date DESC) latest_deposit
   FROM plans_plan PLAN
   LEFT JOIN savings_savingsaccount savings ON plan.owner_id = savings.owner_id
   AND plan.id = savings.plan_id
   WHERE transaction_status = 'success'
     AND (plan.is_regular_savings = 1
          OR plan.is_a_fund = 1)) AS last_transaction
WHERE latest_deposit = 1
  AND (year(current_date()) - year(transaction_date)) >= 1 
  
#-----------------------------------------------------------------------------------------------------------------------------
#This added a subquery,making sure we ARE checking FOR ONLY active accounts 
#-----------------------------------------------------------------------------------------------------------------------------

  AND owner_id NOT IN
    (
    SELECT id
     FROM users_customuser
	WHERE is_active = 1
	 AND is_staff = 0
       ) ;
      