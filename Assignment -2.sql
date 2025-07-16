select * from food_orders_new_delhi
-- 2.Data Cleaning
-- Check if the Order ID, Customer ID, Restaurant ID, Payment Method, 
-- Order Date and Time, Delivery Date and Time is having null value 
SELECT COUNT(*) FROM food_orders_new_delhi WHERE "Order ID" IS NULL; --0
SELECT COUNT(*) FROM food_orders_new_delhi WHERE "Customer ID" IS NULL-- 0
SELECT COUNT(*) FROM food_orders_new_delhi WHERE "Restaurant ID" IS NULL -- 0
SELECT COUNT(*) FROM food_orders_new_delhi WHERE "Payment Method" IS NULL -- 0
SELECT COUNT(*) FROM food_orders_new_delhi WHERE "Order Date and Time" IS NULL --0
SELECT COUNT(*) FROM food_orders_new_delhi WHERE "Delivery Date and Time" IS NULL --0

-- Display unique Payment Methods
select distinct "Payment Method" from food_orders_new_delhi

-- Understand the date range
select min("Order Date and Time") from food_orders_new_delhi--2024-01-01 02:12:47
select max("Order Date and TIme") from food_orders_new_delhi --2024-02-07 23:56:12

-- Number of orders within this date range
select count("Order ID") from food_orders_new_delhi --1000

-- How many records have delivery date time before order date time(inconsistent)?
select * from food_orders_new_delhi where "Order Date and Time" > "Delivery Date and Time"--0

-- Maximum order value of customer  
select "Order ID", "Customer ID", "Order Value" from food_orders_new_delhi 
order by "Order Value" desc

-- How many times the top spent customer ordered?
select count("Order ID") from food_orders_new_delhi where "Customer ID" = 'C5544' 

-- Check for outliers(min, max, average) in the Numeric Columns
select
    min("Order Value"), max("Order Value"), avg("Order Value"),
    min("Delivery Fee"), max("Delivery Fee"), avg("Delivery Fee"),
    min("Commission Fee"), max("Commission Fee"), avg("Commission Fee"),
    min("Payment Processing Fee"), max("Payment Processing Fee"), avg("Payment Processing Fee"),
    min("Refunds/Chargebacks"), max("Refunds/Chargebacks"), avg("Refunds/Chargebacks")
from food_orders_new_delhi;

-- Look for different types of Discount and Offers
select distinct "Discounts and Offers" from food_orders_new_delhi

-- Check for orders that have order value more than 1000 
select count("Order ID") from food_orders_new_delhi where "Order Value" > 1000
-- Check for orders that have order value less than 300
select count("Order ID") from food_orders_new_delhi where "Order Value" < 300

-- How many orders were made by frequent customer?. What's their total order value for all the orders?
select "Customer ID", count("Order ID") as num_order, sum("Order Value") as order_value from food_orders_new_delhi group by "Customer ID" order by num_order desc

-- Which restaurants had more orders? How many orders were made in each restaurant? What is the total value for top restaurant?
select "Restaurant ID", count("Order ID") as num_orders, sum("Order Value") as order_value from food_orders_new_delhi group by "Restaurant ID" order by num_orders desc

-- 3. Create the view with features that directly impact cost and profitability, derived features
CREATE VIEW food_order_profitability_metrics AS
SELECT
    "Order ID",
    "Customer ID",
    "Restaurant ID",
    "Order Date and Time",
    "Delivery Date and Time",

    "Order Value",
    "Delivery Fee",
    "Commission Fee",
    "Payment Processing Fee",
    "Refunds/Chargebacks",

    -- Keep original "Discounts and Offers" for reference
    "Discounts and Offers",

    -- DERIVED FEATURE: Parsed_Discount_Amount
    COALESCE(
        CASE
            WHEN "Discounts and Offers" = '5% on App' THEN 0.05 * "Order Value"
            WHEN "Discounts and Offers" = '10%' THEN 0.10 * "Order Value"
            WHEN "Discounts and Offers" = '15% New User' THEN 0.15 * "Order Value"
            WHEN "Discounts and Offers" = '50 off Promo' THEN 50.0
            WHEN "Discounts and Offers" = 'None' THEN 0.0
            ELSE 0.0
        END,
        0.0 -- COALESCE ensures that if the CASE statement somehow results in NULL (unlikely with this specific logic), it defaults to 0.0
    ) AS Parsed_Discount_Amount,

    -- DERIVED METRIC: Gross Platform Revenue
    ("Order Value" + "Delivery Fee" + "Commission Fee") AS Gross_Platform_Revenue,

    -- DERIVED METRIC: Net Order Value After Discount (Actual amount paid by customer for the order items)
    ("Order Value" - COALESCE(
        CASE
            WHEN "Discounts and Offers" = '5% on App' THEN 0.05 * "Order Value"
            WHEN "Discounts and Offers" = '10%' THEN 0.10 * "Order Value"
            WHEN "Discounts and Offers" = '15% New User' THEN 0.15 * "Order Value"
            WHEN "Discounts and Offers" = '50 off Promo' THEN 50.0
            WHEN "Discounts and Offers" = 'None' THEN 0.0
            ELSE 0.0
        END, 0.0)
    ) AS Net_Order_Value_After_Discount,

    -- DERIVED METRIC: Net Platform Earnings (Simplified Contribution Margin)
    (
        "Commission Fee" +
        "Delivery Fee" -
        COALESCE(
            CASE
                WHEN "Discounts and Offers" = '5% on App' THEN 0.05 * "Order Value"
                WHEN "Discounts and Offers" = '10%' THEN 0.10 * "Order Value"
                WHEN "Discounts and Offers" = '15% New User' THEN 0.15 * "Order Value"
                WHEN "Discounts and Offers" = '50 off Promo' THEN 50.0
                WHEN "Discounts and Offers" = 'None' THEN 0.0
                ELSE 0.0
            END, 0.0
        ) -
        "Payment Processing Fee" -
        "Refunds/Chargebacks"
    ) AS Net_Platform_Earnings

FROM
    food_orders_new_delhi;

-- 	Display the view created
--4. Break down the costs associated with each order, including fixed costs (like packaging) and variable costs (like delivery fees and discounts).  
select * from food_order_profitability_metrics

-- Display individual variable costs and their sum
SELECT
    "Order ID",
    Parsed_Discount_Amount,
    "Payment Processing Fee",
    "Refunds/Chargebacks",
    (Parsed_Discount_Amount + "Payment Processing Fee" + "Refunds/Chargebacks") AS Total_Variable_Costs_From_Data
FROM
    food_order_profitability_metrics;
	
-- 5.Determine the revenue generated from each order, focusing on commission fees and the order value before discounts.\
select "Order ID", "Order Value", "Commission Fee", "Delivery Fee", "Gross_Platform_Revenue" from food_order_profitability_metrics

-- 6.For each order, calculate the profit by subtracting the total costs from the revenue. Analyze the distribution of profitability across all orders to identify trends. 
select "Order ID", Net_Platform_Earnings from food_order_profitability_metrics

-- Which orders have least Net_Platform_Earnings/ got losses?
select "Order ID", Net_Platform_Earnings from food_order_profitability_metrics where Net_Platform_Earnings<0 order by Net_Platform_Earnings
select * from food_order_profitability_metrics where "Order ID" = 843

--Count of Profitable vs. Unprofitable Orders: 
select
    case
        when Net_Platform_Earnings > 0 then 'Profitable'
        when Net_Platform_Earnings = 0 then 'Break-even'
        else 'Unprofitable'
    end as Profit_Category,
    count(*) as Number_Of_Orders
from
    food_order_profitability_metrics
group by
    Profit_Category
order by
    Number_Of_Orders desc;

-- 7. Based on the cost and profitability analysis, develop strategic 
-- recommendations aimed at enhancing profitability. 	

-- Optimize Discount Strategies:
-- 
-- Analysis: If Parsed_Discount_Amount is a major cost, especially for unprofitable
--  orders, or specific discount types like '15% New User' lead to low profitability.
-- 
-- Recommendation: Review the ROI of discounts. Reduce discount percentages/amounts, 
-- or make them more targeted (e.g., only for specific customer segments, off-peak 
-- hours, or higher-margin orders). Ensure new user discounts lead to repeat, 
-- profitable business.
-- 
-- Negotiate Commission Rates:
-- 
-- Analysis: If certain restaurants generate high volume but consistently low 
-- Net_Platform_Earnings due to lower commission fees or very high discounts/refunds.
-- 
-- Recommendation: Negotiate higher commission percentages with underperforming 
-- restaurants. Consider tiered commission structures that incentivize profitability.
-- 
-- Address High Costs (Payment Processing, Refunds/Chargebacks):
-- 
-- Analysis: If specific Payment Methods have higher Payment Processing Fees or
--  higher Refunds/Chargebacks. Identify restaurants or order types prone to refunds.

-- Recommendation: Explore alternative payment gateway providers with lower
--  processing fees. Investigate root causes of refunds (e.g., food quality
--  issues from specific restaurants, delivery errors, customer service problems)
--  and implement corrective measures.

-- 8. Use the data to simulate the financial impact of proposed changes, such as 
-- adjusting discount or commission rates.

--  Simulating Commission Rate Increase by 1% and Net_Platform_Earnings by 1%

select "Order ID", "Order Value", "Commission Fee" as "Current Commision Fees",
("Commission Fee"+("Order Value"*0.01)) as Proposed_Commision_Fee, 
"Net_Platform_Earnings" as "Current_net_earnings",("Net_Platform_Earnings"+
("Order Value"*0.01)) as "Proposed_net_earnings_Sim1" from food_order_profitability_metrics

--  Simulating a Discount Reduction (reducing the fixed '50 off Promo' to 
-- '40 off Promo' and percentage discounts by 2 percentage points): 
SELECT
    "Order ID",
    "Discounts and Offers" AS Current_Discount_Offer_Text,
    Parsed_Discount_Amount AS Current_Discount_Value,
    Net_Platform_Earnings AS Current_Net_Earnings,

    -- Calculate Proposed_Discount_Value based on a hypothetical change
    (
        CASE
            WHEN "Discounts and Offers" = '50 off Promo' THEN 40.0 -- From 50 to 40
            WHEN "Discounts and Offers" = '5% on App' THEN 0.03 * "Order Value" -- From 5% to 3%
            WHEN "Discounts and Offers" = '10%' THEN 0.08 * "Order Value" -- From 10% to 8%
            WHEN "Discounts and Offers" = '15% New User' THEN 0.13 * "Order Value" -- From 15% to 13%
            ELSE Parsed_Discount_Amount -- No change for 'None' or other unhandled
        END
    ) AS Proposed_Discount_Value,

    -- Calculate Proposed Net Earnings with the new discount value
    (
        Gross_Platform_Revenue -
        (
            CASE
                WHEN "Discounts and Offers" = '50 off Promo' THEN 40.0
                WHEN "Discounts and Offers" = '5% on App' THEN 0.03 * "Order Value"
                WHEN "Discounts and Offers" = '10%' THEN 0.08 * "Order Value"
                WHEN "Discounts and Offers" = '15% New User' THEN 0.13 * "Order Value"
                ELSE Parsed_Discount_Amount
            END
        ) -
        "Payment Processing Fee" -
        "Refunds/Chargebacks"
    ) AS Proposed_Net_Earnings_Sim2

FROM
    food_order_profitability_metrics;

-- Total estimated impact of this discount reduction simulation:
SELECT
    SUM(Net_Platform_Earnings) AS Total_Current_Profit,
    SUM(
        Gross_Platform_Revenue -
        (
            CASE
                WHEN "Discounts and Offers" = '50 off Promo' THEN 40.0
                WHEN "Discounts and Offers" = '5% on App' THEN 0.03 * "Order Value"
                WHEN "Discounts and Offers" = '10%' THEN 0.08 * "Order Value"
                WHEN "Discounts and Offers" = '15% New User' THEN 0.13 * "Order Value"
                ELSE Parsed_Discount_Amount
            END
        ) -
        "Payment Processing Fee" -
        "Refunds/Chargebacks"
    ) AS Total_Proposed_Profit_Sim2,
    SUM(Net_Platform_Earnings) - SUM(
        Gross_Platform_Revenue -
        (
            CASE
                WHEN "Discounts and Offers" = '50 off Promo' THEN 40.0
                WHEN "Discounts and Offers" = '5% on App' THEN 0.03 * "Order Value"
                WHEN "Discounts and Offers" = '10%' THEN 0.08 * "Order Value"
                WHEN "Discounts and Offers" = '15% New User' THEN 0.13 * "Order Value"
                ELSE Parsed_Discount_Amount
            END
        ) -
        "Payment Processing Fee" -
        "Refunds/Chargebacks"
    ) AS Total_Profit_Change_Sim2
FROM
    food_order_profitability_metrics;

	