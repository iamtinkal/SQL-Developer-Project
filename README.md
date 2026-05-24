# 🛒 MoreRetail — SQL Developer Internship Project

## 📌 Project Overview
A fully functional SQL database for **MoreRetail**, a retail chain 
with 900+ stores across India. This project demonstrates real-world 
SQL development skills including schema design, query optimization, 
stored procedures, triggers, and security implementation.

---

## 👤 Author
- **Name:** Tinkal Singh
- **Batch:** CG-0904-46
- **Internship:** SQL Developer — ClinchEdge Global Services
- **Tool:** MySQL 8.0 | MySQL Workbench

---

## 🗄️ Database Schema (8 Tables)
| Table | Description |
|---|---|
| categories | Product categories |
| products | All products/SKUs |
| customers | Customer information |
| employees | Employee details with hierarchy |
| orders | All customer orders |
| order_items | Individual items in each order |
| payments | Payment records |
| reviews | Customer product reviews |

---

## 📋 Project Phases

### ✅ Phase 1: Schema Design
- 8 tables with PRIMARY KEY, FOREIGN KEY
- Constraints: NOT NULL, UNIQUE, CHECK, DEFAULT
- Self-referencing FK in employees (manager hierarchy)

### ✅ Phase 2: Data Insertion
- Sample data inserted in all 8 tables
- Covers all business scenarios

### ✅ Phase 3: Query Development
- Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
- All JOIN types (INNER, LEFT, RIGHT, SELF, CROSS)
- Subqueries and correlated subqueries
- CTEs and Recursive CTEs
- Window Functions (ROW_NUMBER, RANK, DENSE_RANK)

### ✅ Phase 4: Stored Procedures, Functions & Triggers
- Stored Procedure: GetOrdersByCustomerID
- UDF: fn_GetGST (GST calculator)
- 4 Triggers: Auto payment, Audit log, Rating validation, Price validation
- 2 Events: System health log, Pending orders monitor

### ✅ Phase 5: Optimization & Security
- 7 Indexes on FK and frequently queried columns
- EXPLAIN analysis for query optimization
- Role-based access control (3 users with different permissions)

---

## 🚀 How to Run
1. Open MySQL Workbench
2. Open `MoreRetail.sql`
3. Press `Ctrl + A` to select all
4. Press `Ctrl + Shift + Enter` to run
