/*
    AUGMENTA GOVERNANCE SHIELD - SYNAPSE MODULE
    Script: 01_security_matrix_ddl.sql
    Description: Establishes the Metadata Control Plane.
    
    This table acts as the "Source of Truth" for all data access.
    By modifying this table, you control access without altering Security Policies.
*/

CREATE SCHEMA augmenta_gov;
GO

-- 1. Create the Permission Matrix Table
-- This replaces hardcoded roles with a data-driven approach
CREATE TABLE augmenta_gov.AccessControlMatrix 
    (  
    DataDomainKey nvarchar(50),  -- Generic Key (e.g., ReturnID, Region, Department)
    SecurityGroup nvarchar(100)  -- The Active Directory Group or SQL Role
    );
GO

-- 2. Seed Initial Permissions (Examples)

-- Scenario A: Read-Only Analysts (Restricted by specific Data Keys)
INSERT INTO augmenta_gov.AccessControlMatrix(DataDomainKey, SecurityGroup) VALUES ('RET_001', 'sg_finance_analysts');
INSERT INTO augmenta_gov.AccessControlMatrix(DataDomainKey, SecurityGroup) VALUES ('RET_002', 'sg_risk_analysts');
INSERT INTO augmenta_gov.AccessControlMatrix(DataDomainKey, SecurityGroup) VALUES ('GEO_NA',   'sg_sales_north_america');

-- Scenario B: ETL Pipelines (Must see all data to process it)
-- It is critical that ETL Service Principals are mapped to ALL keys to prevent data loss during processing.
INSERT INTO augmenta_gov.AccessControlMatrix(DataDomainKey, SecurityGroup) VALUES ('RET_001', 'sp_adf_etl_service');
INSERT INTO augmenta_gov.AccessControlMatrix(DataDomainKey, SecurityGroup) VALUES ('RET_002', 'sp_adf_etl_service');
INSERT INTO augmenta_gov.AccessControlMatrix(DataDomainKey, SecurityGroup) VALUES ('GEO_NA',   'sp_adf_etl_service');

-- Scenario C: Developers (DDL access for maintenance)
INSERT INTO augmenta_gov.AccessControlMatrix(DataDomainKey, SecurityGroup) VALUES ('RET_001', 'sg_developers_admin');
