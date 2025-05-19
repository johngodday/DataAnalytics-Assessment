# DataAnalytics-Assessment


This document outlines four key SQL reporting tasks designed to support business analysis, customer segmentation, and operational decisions.

---

## 📌 QUESTIONS

### 1. High-Value Customers with Multiple Products

**Scenario:**  
The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).

**Task:**  
Write a query to find customers with at least one funded **savings plan** AND one funded **investment plan**, sorted by total deposits.

**Tables Used:**
- `users_customuser`
- `savings_savingsaccount`
- `plans_plan`


---

### 2. Transaction Frequency Analysis

**Scenario:**  
The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).

**Task:**  
Calculate the average number of transactions per customer **per month** and categorize them into:
- **High Frequency** (≥10 transactions/month)
- **Medium Frequency** (3–9 transactions/month)
- **Low Frequency** (≤2 transactions/month)

**Tables Used:**
- `users_customuser`
- `savings_savingsaccount`


---

### 3. Account Inactivity Alert

**Scenario:**  
The ops team wants to flag accounts with no inflow transactions for over one year.

**Task:**  
Find all active accounts (savings or investments) with **no transactions in the last 365 days**.

**Tables Used:**
- `plans_plan`
- `savings_savingsaccount`


### 4. Customer Lifetime Value (CLV) Estimation

**Scenario:**  
Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).

**Task:**  
For each customer, assuming the `profit_per_transaction` is **0.1% of the transaction value**, calculate:
- **Account tenure** (months since signup)
- **Total transactions**
- **Estimated CLV**

> Formula:  
> `CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction`

Order the result by **estimated CLV from highest to lowest**.

**Tables Used:**
- `users_customuser`
- `savings_savingsaccount`
