/*
    AUGMENTA SYSTEMS - NATIVE UC RLS
    Script: 02_security_functions.sql
    Description: SQL User Defined Functions (UDFs) that return Boolean logic for access.
*/

-- Function 1: Region-Based Row Filter
-- Logic: Return TRUE if user is Admin OR if user belongs to a group mapped to the specific region.
CREATE OR REPLACE FUNCTION main.augmenta_gov.fn_filter_by_region(region_col STRING)
RETURN 
    -- Optimization: Admin Bypass
    is_account_group_member('sg_platform_admins') 
    OR
    -- Lookup in Matrix
    EXISTS (
        SELECT 1 
        FROM main.augmenta_gov.auth_matrix m
        WHERE 
            is_account_group_member(m.user_group) 
            AND 
            (m.allowed_value = region_col OR m.allowed_value = 'ALL')
    );

-- Function 2: PII Column Masking
-- Logic: Return the raw value for authorized groups, otherwise return a redacted string.
CREATE OR REPLACE FUNCTION main.augmenta_gov.fn_mask_pii(col_value STRING)
RETURN CASE 
    WHEN is_account_group_member('sg_hr_managers') THEN col_value
    WHEN is_account_group_member('sg_compliance_auditors') THEN col_value
    ELSE '***-***-****' -- Redacted for everyone else
END;
