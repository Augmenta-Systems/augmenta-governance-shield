/*
    AUGMENTA SYSTEMS - NATIVE UC RLS
    Script: 01_access_matrix_setup.sql
    Description: Defines the "Control Plane" - a secured mapping table that drives security logic.
*/

-- 1. Create a dedicated Governance Schema
-- We separate security metadata from business data.
CREATE SCHEMA IF NOT EXISTS main.augmenta_gov;

-- 2. Create the Access Matrix Table
-- This table maps AD Groups (Principals) to allowed Data Values (Attributes).
CREATE TABLE IF NOT EXISTS main.augmenta_gov.auth_matrix (
    user_group STRING,      -- The Entra ID / AD Group Name
    allowed_value STRING,   -- The value they can access (e.g., 'NA', 'EU', 'Finance')
    access_level STRING     -- Optional: 'READ', 'MASKED', 'ADMIN'
);

-- 3. Security Hardening
-- CRITICAL: Revoke access from standard users. 
-- Only the Security Admin and the RLS Functions (via DEFINER privileges) should read this.
REVOKE ALL PRIVILEGES ON TABLE main.augmenta_gov.auth_matrix FROM users;
GRANT SELECT ON TABLE main.augmenta_gov.auth_matrix TO `sg_governance_admins`;

-- 4. Seed Initial Permissions (Configuration)
INSERT INTO main.augmenta_gov.auth_matrix VALUES 
('sg_sales_na',    'NorthAmerica', 'READ'),
('sg_sales_eu',    'Europe',       'READ'),
('sg_execs',       'ALL',          'ADMIN'),
('sg_hr_managers', 'SENSITIVE',    'UNMASKED');
