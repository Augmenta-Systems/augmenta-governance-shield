/*
    AUGMENTA TRIPLE-LOCK SECURITY FUNCTION
    Inputs:
      - region_col: For Identity Lock (Role based)
      - quality_col: For Integrity Lock (Math based)
      - conf_col: For Confidentiality Lock (Dominance based)
*/
CREATE OR REPLACE FUNCTION main.augmenta_gov.fn_triple_lock(
    region_col STRING, 
    quality_col STRING, 
    conf_col STRING
)
RETURN 
    -- ---------------------------------------------------------
    -- 1. ADMIN BYPASS (The "God Mode" Key)
    -- ---------------------------------------------------------
    is_account_group_member('sg_platform_admins') 
    OR 
    is_account_group_member('sp_global_aggregator_service') -- Crucial for World Calculations
    OR
    (
        -- -----------------------------------------------------
        -- LOCK 1: IDENTITY (Can I see this region?)
        -- -----------------------------------------------------
        EXISTS (
            SELECT 1 FROM main.augmenta_gov.auth_matrix m
            WHERE is_account_group_member(m.user_group) 
            AND (m.allowed_value = region_col OR m.allowed_value = 'ALL')
        )
        AND
        -- -----------------------------------------------------
        -- LOCK 2: INTEGRITY (Is the data valid?)
        -- -----------------------------------------------------
        (
            quality_col = 'PASS' 
            OR is_account_group_member('sg_data_fixers') -- Only fixers see broken data
        )
        AND
        -- -----------------------------------------------------
        -- LOCK 3: CONFIDENTIALITY (Is it free to publish?)
        -- -----------------------------------------------------
        (
            conf_col = 'F' 
            OR is_account_group_member('sg_internal_analysts') -- Internal users can see 'N'
            -- Public users (default) are blocked if 'N'
        )
    );
