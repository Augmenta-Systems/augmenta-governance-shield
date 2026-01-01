# 🛡️ Augmenta Governance Shield

![Status](https://img.shields.io/badge/Status-Active-success)
![Platform](https://img.shields.io/badge/Platform-Azure%20Synapse%20%7C%20Databricks-blue)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

**Automated Data Governance & Zero-Trust Security Orchestration**

---

### 🚀 Overview
**Augmenta Governance Shield** is a dual-engine security suite designed for enterprise data platforms. It transforms security from a manual, ticket-based process into an automated, metadata-driven architecture.

This repository demonstrates **Augmenta Systems'** approach to "Zero-Trust Handoff": implementing robust security frameworks that persist securely even after consultant access is revoked.

### 🏗️ Architecture

#### **Module 1: Metadata-Driven Security Framework (Azure Synapse)**
*A scalable RLS engine that decouples security policies from codebase deployment.*
* **Problem:** Traditional RLS requires code changes (DDL) every time a new user group needs access.
* **Solution:** A control-plane table maps AD Groups to Data Domains (e.g., Regions, Returns, Departments). The security policy reads this table dynamically.
* **Result:** Granting access is a simple `INSERT` statement; no database locks or downtime required.

#### **Module 2: Custom Security Orchestrator (Databricks)**
*A configuration-driven Python framework for automating Object-Level Security (OLS).*
* **Problem:** Early Unity Catalog adoptions often lacked granular automated OLS for complex views.
* **Solution:** An idempotent Python orchestrator that reads a "Desired State" CSV and enforces permissions across Dev, Test, and Prod environments.
* **Self-Healing:** Automatically detects and repairs permission drift during pipeline runs.

---

### 📂 Repository Structure

```text
augmenta-governance-shield/
├── 📘 synapse-metadata-framework/    # Metadata-Driven RLS (Synapse)
│   ├── 01_security_matrix_ddl.sql    # The Control Plane
│   └── 02_policy_engine.sql          # The Security Predicate Logic
│
├── 📙 databricks-ols-orchestrator/   # Security Orchestrator (Python)
│   ├── orchestrator_engine.py        # The Automation Script
│   └── config_definitions/
│       └── access_control_list.csv   # The "Desired State" Config
│
└── 📗 databricks-native-rls/         # Modern Unity Catalog RLS
    └── native_row_filters.sql        # Future-state implementation
```

### 🤝 Contact
**Augmenta Systems** Specializing in Azure Data Engineering & Secure Cloud Architecture.
