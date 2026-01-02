# 🛡️ $\Lambda$ugmenta Sovereign Governance Shield

![Status](https://img.shields.io/badge/Status-Active-success)
![Architecture](https://img.shields.io/badge/Architecture-Triple--Lock-blue)
![Platform](https://img.shields.io/badge/Platform-Databricks%20Unity%20Catalog%20%7C%20Azure-orange)

**The "Triple-Lock" Governance Framework for Sovereign Financial Data.**

---

### 🚀 Overview
**Augmenta Sovereign Shield** is not just an access control list; it is a **context-aware governance engine**. It moves beyond simple "Who are you?" checks to answer three critical questions before granting access to a single cell of data:

1.  **Identity:** Are you authorized?
2.  **Integrity:** Is the data mathematically valid?
3.  **Confidentiality:** Is the data statistically free to publish?

This repository contains the **Infrastructure-as-Code (IaC)** to deploy these gates on Databricks Unity Catalog and Azure Synapse, enforcing a "Zero-Trust Handoff" between external consultants and internal sovereign data owners.

---

### 🔐 The Triple-Lock Architecture

We enforce security at the **Row Level** using a simultaneous three-key turn:

| Lock | Question | Logic Enforced |
| :--- | :--- | :--- |
| **1. Identity Lock** 👤 | *Who are you?* | Standard RBAC (Role-Based Access Control). e.g., "Only `Region_NA` users see North America." |
| **2. Integrity Lock** 📐 | *Is the math right?* | **Quality-Aware Access.** Rows that fail the $B=I+J+M$ identity check are hidden from economists to prevent "bad math" analysis, but visible to Data Engineers for fixing. |
| **3. Confidentiality Lock** 👁️ | *Is it too revealing?* | **Dominance-Aware Access.** Implementation of the "Dominance Rule" (e.g., if one bank holds >60% of a country's assets). The system automatically redacts the country detail while allowing the World Total to remain visible. |

---

### 🎤 The "Sovereign Demo" (Sales Pitch)
*How we solve the "Aggregation vs. Privacy" Paradox.*

Run the notebook `notebooks/Demo_Sovereign_Shield.py` to demonstrate the following narrative to stakeholders:

> **Scene 1: The Liability**
> "Everyone can store data. But look at this 'Canada' row. Bank A holds 90% of the assets. If we publish this row, we reveal Bank A's proprietary position. That is illegal under statistical confidentiality laws."
>
> **Scene 2: The Judgment**
> "Our pipeline doesn't just copy data; it **judges** it. The Shield automatically detects that Bank A has 90% dominance. It tags the row as `Status: N` (Not Free) immediately during ingestion."
>
> **Scene 3: The Public User (The Climax)**
> "Here is the magic. A Public Analyst queries the dataset. They see the **World Total** (which includes Canada). They get the global insight they need. But if they look for **Canada**, it's gone. We protected the bank *and* served the public in the same query."
>
> **Scene 4: The Sovereign Owner**
> "And of course, you (the Internal Auditor) see everything. The data isn't deleted; it's Sovereign."

---

### 📂 Repository Structure

```text
augmenta-governance-shield/
├── 📓 notebooks/
│   └── Demo_Sovereign_Shield.py     # The "Money Demo" showing the Triple-Lock in action
│
├── 📜 policies/
│   ├── triple_lock.py               # The Master Security Function (UDF)
│   ├── definitions.yaml             # Config for Embargo times and Confidentiality thresholds
│   └── legacy/                      # (Archived) Synapse T-SQL policies
│
├── 🔌 src/
│   ├── enrichment_pipeline.py       # Bridge script: Calls the Validator to tag data
│   └── apply_tags.py                # Automated tagging based on definitions
│
└── 🛠️ databricks-native-rls/        # SQL Deployment Scripts
    ├── 01_access_matrix_setup.sql   # The Control Plane
    ├── 02_security_functions.sql    # The Triple-Lock Logic Implementation
    └── 03_apply_policies.sql        # Binding logic to tables
```
### 🤝 Dependencies
This framework acts as the **Enforcement Layer**. It relies on the **Logic Layer** provided by:

_universal-ibs-validator_ (Handles the Math & Dominance algorithms)

### 📞 Contact
**Augmenta Systems** Sovereign Data Architecture & Regulatory Modernization.
