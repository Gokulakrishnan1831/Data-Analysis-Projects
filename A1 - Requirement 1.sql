-- view the data
select * from project_transactions

-- Read in the only columns household_key, BASKET_ID, PRODUCT_ID, QUANTITY and SALES_VALUE.
select household_key, BASKET_ID, PRODUCT_ID, QUANTITY, SALES_VALUE from project_transactions
 

--Find maximum, maximum integer in PRODUCT_ID 
select min(PRODUCT_ID) from project_transactions --25671
select max(PRODUCT_ID) from project_transactions --18316298

-- Since the maximum PRODUCT_ID in project_transactions table is 18316298 and
--  integer is the current data type and Integer can hold the values 
-- between -2,147,483,648 to 2,147,483,647,  there is no other smaller 
-- numeric data type that can hold this maximum value. So no need to change
--  the data type of PRODUCT_ID

-- Find minimum,maximum integer in QUANTITY
SELECT min(quantity) from project_transactions --0
SELECT max(quantity) from project_transactions --89638

-- Since the quantity column contains maximum integer as 89638 and integer
-- is the current data type of the column, there is a data type in MYSQL
-- called MEDIUMINT that can hold integers in the range between 
-- -8,388,608 to 8,388,607 (signed) or 0 to 16,777,215 (unsigned). To efficiently
-- utilize the storage used, it is a good idea to convert the column quantity 
-- from integer to MEDIUMINT data type using the following QUERY

ALTER TABLE project_transactions MODIFY COLUMN QUANTITY MEDIUMINT;

