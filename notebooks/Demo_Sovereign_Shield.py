# -------------------------------------------------------------------------
# AUGMENTA SYSTEMS - SOVEREIGN GOVERNANCE SHIELD
# DEMO: The "World Aggregation" Paradox
# -------------------------------------------------------------------------
# Description: 
# Demonstrates the "Triple-Lock" Governance model.
# We show how data can be "Mathematically Valid" and "Authorized" 
# but still hidden due to "Statistical Dominance" (Confidentiality).
# -------------------------------------------------------------------------

import pyspark.sql.functions as F
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, StringType, DoubleType

# Initialize Spark (Simulating the Data Engine)
spark = SparkSession.builder \
    .appName("Augmenta_Sovereign_Shield_Demo") \
    .getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

print("⚡ Augmenta Sovereign Shield: System Initialized\n")

# =========================================================================
# 🎬 SCENE 1: THE SETUP (Raw Data)
# =========================================================================
print("--- SCENE 1: INGESTING RAW DATA ---")
print("Context: We have banking data from Canada and the US.")
print("Challenge: Bank A in Canada holds 90% of the assets. This is 'Identifying'.\n")

data = [
    # Canada: Total 100. Bank A has 90 (Dominant).
    ("CA", "Banking", "BANK_A", 90.0),
    ("CA", "Banking", "BANK_B", 10.0),
    
    # USA: Total 100. Split evenly (No Dominance).
    ("US", "Banking", "BANK_C", 50.0),
    ("US", "Banking", "BANK_D", 50.0),
    
    # World: Total 200. No single bank has >60% of 200.
    ("WORLD", "Banking", "AGGREGATE", 200.0) 
]

schema = StructType([
    StructField("REP_CTY", StringType(), True),
    StructField("SECTOR", StringType(), True),
    StructField("BANK_ID", StringType(), True),
    StructField("VALUE", DoubleType(), True)
])

df_raw = spark.createDataFrame(data, schema)
print(">>> RAW DATA PREVIEW:")
df_raw.show()

# =========================================================================
# 🎬 SCENE 2: THE TAGGING PIPELINE (The "Enrichment" Phase)
# =========================================================================
print("\n--- SCENE 2: EXECUTING GOVERNANCE PIPELINE ---")
print("Action: Applying 'Dominance Rule' (Threshold: 60%)")
print("Logic: If a bank holds >60% of the Country Total, mark as Confidential (N).")

# 1. Calculate Totals per Country (Window Function Simulation)
# (In prod, this calls your 'confidentiality.py' module)
window_spec = F.window("REP_CTY") # simplified group logic

# We join totals back to calculate share
df_totals = df_raw.groupBy("REP_CTY").agg(F.sum("VALUE").alias("TOTAL_CTY"))
df_enriched = df_raw.join(df_totals, "REP_CTY")

# 2. Calculate Market Share
df_enriched = df_enriched.withColumn("MARKET_SHARE", F.col("VALUE") / F.col("TOTAL_CTY"))

# 3. Apply the "Confidentiality Lock"
# 'N' = Not Free (Hidden), 'F' = Free (Visible)
df_tagged = df_enriched.withColumn(
    "CONFIDENTIALITY_STATUS",
    F.when(F.col("MARKET_SHARE") > 0.60, "N").otherwise("F")
)

# 4. Apply the "Integrity Lock" (Simulated Validator)
# Assume all math passed for this demo
df_tagged = df_tagged.withColumn("QUALITY_STATUS", F.lit("PASS"))

print(">>> GOVERNANCE TAGS APPLIED:")
df_tagged.select("REP_CTY", "BANK_ID", "VALUE", "MARKET_SHARE", "CONFIDENTIALITY_STATUS", "QUALITY_STATUS").show()
print("NOTE: Observe that BANK_A is tagged 'N' (0.9 share), while WORLD is 'F'.")

# =========================================================================
# 🎬 SCENE 3: THE PUBLIC USER (Restricted Access)
# =========================================================================
print("\n--- SCENE 3: SIMULATING PUBLIC USER ACCESS ---")
print("User Identity: 'public_analyst'")
print("Policy: Can ONLY see rows where CONFIDENTIALITY_STATUS = 'F'")

def security_policy_engine(df, user_role):
    """
    Simulates Unity Catalog Row Filter
    """
    if user_role == 'internal_admin':
        return df # See everything
    elif user_role == 'public_analyst':
        # The Filter Predicate:
        return df.filter(F.col("CONFIDENTIALITY_STATUS") == "F")

# Apply Policy
df_public_view = security_policy_engine(df_tagged, 'public_analyst')

print(">>> PUBLIC VIEW (What the world sees):")
df_public_view.select("REP_CTY", "BANK_ID", "VALUE").show()

print("✅ SUCCESS: The 'World' aggregate (200.0) is VISIBLE.")
print("✅ PRIVACY PRESERVED: 'Bank A' (90.0) is HIDDEN.")

# =========================================================================
# 🎬 SCENE 4: THE INTERNAL USER (Sovereign Access)
# =========================================================================
print("\n--- SCENE 4: SIMULATING INTERNAL USER ACCESS ---")
print("User Identity: 'internal_admin'")
print("Policy: Bypass Confidentiality Lock (Full Audit Access)")

# Apply Policy
df_internal_view = security_policy_engine(df_tagged, 'internal_admin')

print(">>> INTERNAL VIEW (Sovereign Audit):")
df_internal_view.select("REP_CTY", "BANK_ID", "VALUE", "CONFIDENTIALITY_STATUS").show()

print("✅ SUCCESS: Internal teams see the raw data to validate the math.")
print("\n--- DEMO COMPLETE ---")
