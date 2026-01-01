/*
    AUGMENTA SYSTEMS - NATIVE UC RLS
    Script: 03_apply_policies.sql
    Description: Binds the security logic to physical tables.
*/

-- 1. Apply Horizontal Security (Row Filter)
-- Users will only see rows where their group matches the 'SalesRegion' column.
ALTER TABLE main.gold_db.fact_transactions
SET ROW FILTER main.augmenta_gov.fn_filter_by_region ON (SalesRegion);

-- 2. Apply Vertical Security (Column Masking)
-- The 'CustomerEmail' column will be masked for non-HR users.
ALTER TABLE main.gold_db.dim_customers
ALTER COLUMN CustomerEmail SET MASK main.augmenta_gov.fn_mask_pii;

-- 3. Verification Steps
/*
    -- Test as Restricted User:
    SELECT * FROM main.gold_db.fact_transactions; -- Should return limited rows
    
    -- Test as Admin:
    SELECT * FROM main.gold_db.fact_transactions; -- Should return all rows
*/
