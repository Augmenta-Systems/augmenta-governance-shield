# This script runs in Databricks/Synapse before writing to the Gold Table
from universal_ibs_validator.engine import IBSValidator
from universal_ibs_validator.confidentiality import apply_dominance_rule

def run_triple_lock_enrichment(raw_df):
    # 1. Apply Confidentiality Logic (The Dominance Rule)
    # Checks if any bank holds >60% of the Country-Sector total
    df_tagged = apply_dominance_rule(
        raw_df, 
        value_col="VALUE", 
        group_cols=["REP_CTY", "CP_SECTOR"], 
        contributor_col="BANK_ID"
    )
    
    # 2. Apply Quality Logic (The Validator)
    validator = IBSValidator(context)
    df_final = validator.tag_dataset(df_tagged, rules=get_lbsr_rules())
    
    # 3. Write to Gold Table (With Security Columns)
    # The columns QUALITY_STATUS and CONFIDENTIALITY_STATUS are now physically present
    df_final.write.mode("append").saveAsTable("main.gold_db.fact_lbs_statistics")
