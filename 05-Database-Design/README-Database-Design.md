# Database Design — Appointment Allowance System

Proposed technical model for a **fictional** business-analysis portfolio case study.

- `ERD-Appointment-Allowance.drawio`: editable logical entity-relationship diagram.
- `Data-Dictionary.xlsx`: proposed table and field definitions, keys and assumptions.
- `Database-Schema.sql`: SQLite-compatible example DDL.
- `SQL-Queries.sql`: six read-only reporting/tracking examples.

**Source baseline:** BRD v1.0 and reviewed Use Case Descriptions. Database entities and field types are design proposals, **not** additional approved business requirements. Specific request form fields, eligibility rules, evidence requirements, status values, retention and permissions remain TBD. Finance handoff is conditional and payment processing is excluded.

**How to run:** Execute `Database-Schema.sql` in a disposable SQLite database, then run queries with appropriate bound parameters after adding your own test data. No real employee data is provided.
