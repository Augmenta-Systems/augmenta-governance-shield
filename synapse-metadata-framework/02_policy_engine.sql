/*
    AUGMENTA GOVERNANCE SHIELD - SYNAPSE MODULE
    Script: 02_policy_engine.sql
    Description: Binds the Security Policy to the Metadata Matrix.
*/

-- 1. Create the Predicate Function
-- This function checks if the current user belongs to a group authorized for the specific Data Key.
CREATE FUNCTION augmenta_gov.fn_SecurityPredicate(@AccessKey AS NVARCHAR(50))  
    RETURNS TABLE  
WITH SCHEMABINDING  
AS  
RETURN SELECT 1 AS SecurityResult 
WHERE @AccessKey IN (
    SELECT DataDomainKey 
    FROM augmenta_gov.AccessControlMatrix 
    WHERE ((SecurityGroup = USER_NAME()) OR IS_MEMBER(SecurityGroup)=1)
);
GO

-- 2. Apply the Policy to Sensitive Tables
-- The State=ON ensures security is active immediately.
-- NOTE: Update 'gold_db' and table names to match target environment.

CREATE SECURITY POLICY GovernanceShieldPolicy
    ADD FILTER PREDICATE augmenta_gov.fn_SecurityPredicate(Return_ID) ON gold_db.Fact_RegulatoryReturns,
    ADD FILTER PREDICATE augmenta_gov.fn_SecurityPredicate(Region_ID) ON gold_db.Fact_SalesGeo,
    ADD FILTER PREDICATE augmenta_gov.fn_SecurityPredicate(Dept_ID)   ON gold_db.Dim_Department
WITH (STATE = ON);
GO
