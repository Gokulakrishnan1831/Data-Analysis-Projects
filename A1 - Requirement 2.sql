-- View the data
select * from hh_demographic

-- Read in the only columns AGE_DESC, INCOME_DESC, household_key 
-- and HH_COMP_DESC.
select AGE_DESC, INCOME_DESC, household_key, HH_COMP_DESC from hh_demographic

-- Group the transactions table by household_id and calculate 
-- the sum of SALES_VALUE by household.
select household_key, SUM(SALES_VALUE) from project_transactions
 GROUP BY household_key

-- Join the transactions table with demographic table. Display all
-- the demographic along with transactions that match with
-- demographic.
select * from hh_demographic hd inner join project_transactions pt 
on hd.household_key = pt.household_key