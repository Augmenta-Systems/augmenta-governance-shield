/*
    AUGMENTA SYSTEMS - MODERN UNITY CATALOG RLS
    Description: Implementation of Native Row Filters (SQL Standard).
    Note: This approach replaces the OLS Orchestrator for granular row-level needs
    where specific rows must be hidden based on user attributes.
*/

-- 1. Create the Security Mapping Table in the Main Catalog
-- This table defines which users can see which region codes
CREATE TABLE IF NOT EXISTS main.security.geo_access_mapping (
  user_group STRING,
  allowed_region_code STRING
);

-- 2. Define the Security Function
-- Returns TRUE if the user is in a group authorized for the specific region
CREATE OR REPLACE FUNCTION main.security.fn_region_filter(region_col STRING)
RETURN EXISTS (
  SELECT 1 FROM main.security.geo_access_mapping
  WHERE is_account_group_member(user_group) = 1
  AND allowed_region_code = region_col
);

-- 3. Bind the Filter to Production Tables
-- This enforces the filter at the engine level
ALTER TABLE prod_cat.gold_db.fact_sales
SET ROW FILTER main.security.fn_region_filter ON (RegionCode);
