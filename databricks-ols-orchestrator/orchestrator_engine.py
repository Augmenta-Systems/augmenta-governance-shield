# -------------------------------------------------------------------------
# AUGMENTA SYSTEMS - SECURITY ORCHESTRATOR ENGINE
# Platform: Databricks Unity Catalog
# Description: Automates Object-Level Security (OLS) via Configuration
# -------------------------------------------------------------------------

from pyspark.sql.functions import *
import pandas as pd

# 1. Initialize Widgets (Inputs from ADF or Jobs)
# These allow the script to be dynamic across environments
dbutils.widgets.text("config_path", "abfss://config@datalake.dfs.core.windows.net/access_control_list.csv")
dbutils.widgets.text("environment", "dev") # Options: dev, uat, prod

# 2. Read Configuration
config_path = dbutils.widgets.get('config_path')
env_context = dbutils.widgets.get('environment')

print(f"Starting Security Orchestration for Environment: {env_context}")

# Load the "Desired State" configuration
# Using Pandas for easy iteration over the config rows
df_config = spark.read.option("header", "true").csv(config_path).toPandas()

# 3. Catalog Resolution Logic
# Dynamically resolves generic placeholders to actual environment catalogs
def resolve_catalog_name(object_pattern, env):
    """
    Replaces {env} placeholder with actual environment prefix.
    Example: {env}_cat -> dev_cat or prod_cat
    """
    return object_pattern.replace("{env}", env)

# 4. Idempotent Permission Enforcer
def check_and_grant_permission(full_object_name, ad_group):
    """
    Checks if permission exists. If not, grants it.
    This prevents redundant GRANT statements and cleaner logs.
    """
    try:
        # Check current permissions on the object
        # We query information schema or SHOW GRANTS to see current state
        current_grants = spark.sql(f"SHOW GRANTS ON {full_object_name}") \
                              .filter(col("Principal") == ad_group) \
                              .collect()
        
        if not current_grants:
            # Grant Access if it doesn't exist
            spark.sql(f"GRANT SELECT ON {full_object_name} TO `{ad_group}`")
            print(f"[APPLIED] Granted SELECT on {full_object_name} to {ad_group}")
        else:
            # Skip (Idempotency) - reduces log noise
            print(f"[SKIPPED] Access already exists for {ad_group} on {full_object_name}")
            
    except Exception as e:
        print(f"[ERROR] Failed to secure object: {full_object_name}. Reason: {str(e)}")
        # In a real scenario, this would trigger an alert to the Governance Team

# 5. Execution Loop
for index, row in df_config.iterrows():
    # Resolve the dynamic object name (e.g., dev_cat.db.table)
    target_object = resolve_catalog_name(row['uc_object'], env_context)
    target_group = row['user_ad_group']
    
    # Enforce Security
    check_and_grant_permission(target_object, target_group)

print("Security Orchestration Completed.")
