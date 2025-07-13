-- View the datat 
select * from product

-- Read in PRODUCT_ID and DEPARTMENT from product
select PRODUCT_ID, DEPARTMENT from product

-- Join the product DataFrame to transactions and demographics tables, 
-- performing an inner join when joining both tables.
select * from product p inner join project_transactions pt on p.PRODUCT_ID=pt.PRODUCT_ID
inner join hh_demographic hd on hd.household_key=pt.household_key

