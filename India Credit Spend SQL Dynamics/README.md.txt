India Credit Spend: SQL Data Dynamics
📌 Project Overview
This project involves a deep-dive analysis of credit card transactions across various cities in India. Using a dataset of over 26,000 transactions, I authored complex SQL queries to extract meaningful business insights regarding consumer spending patterns, gender-based contributions, and card-type performance.

🛠️ Technical Skills Demonstrated
Complex Aggregations: Using SUM, COUNT, and GROUP BY to summarize large datasets.

Window Functions: Leveraging RANK(), ROW_NUMBER(), and LAG() for time-series and comparative analysis.

Common Table Expressions (CTEs): Structuring readable and modular code for multi-step logic.

Data Transformation: Using CASE statements for pivot-style reporting and DATEPART for temporal analysis.

📂 Repository Contents
Credit card transactions - India - Simple.csv: The raw transactional dataset.

Queries.sql: The complete script containing all analytical solutions.

🔍 Key Business Problems Solved
The SQL script provides answers to critical business questions, including:

Market Share Analysis: Identifying the top 5 cities by spend and calculating their percentage contribution to total national volume.

Consumer Milestones: Pinpointing the exact transaction where each card type reached a cumulative spend of 1,000,000.

Growth Metrics: Calculating Month-over-Month (MoM) growth for card and expense type combinations specifically for January 2014.

Demographic Insights: Analyzing the percentage contribution of female spenders across various expense categories.

Operational Efficiency: Identifying which city reached its 500th transaction fastest after its first recorded sale.

Behavioral Analysis: Determining which cities have the highest spend-to-transaction ratio during weekends.

💡 Query Spotlight: Cumulative Spend Milestone
One of the most complex queries in this project identifies the specific transaction when a card type crosses the 1M spend threshold using Window Functions:

SQL

with cte as (
    select *, sum(amount) over(partition by card_type order by transaction_date, transaction_id) as total_spend
    from credit_card_transcations
)
select * from (
    select *, rank() over(partition by card_type order by total_spend) as rn  
    from cte where total_spend >= 1000000
) a where rn=1;
🚀 How to Run
Import the .csv file into your SQL Server instance.

Ensure the table is named credit_card_transcations.

Execute the Queries.sql script to see the analytical outputs.