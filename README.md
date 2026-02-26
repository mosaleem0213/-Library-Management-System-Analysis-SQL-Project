# 📚 Library Management System – SQL Project

## 📌 Project Overview
The Library Management System is a SQL-based relational database project designed to manage and organize library operations efficiently.  

This project demonstrates:
- Database design and schema creation
- Table relationships using Primary & Foreign Keys
- Data integrity constraints
- Real-world SQL queries for reporting and analysis

It simulates how libraries manage:
- Branches
- Employees
- Books
- Members
- Issue & Return Transactions

---

## 🗂️ Database Name
`LibraryDB`

---

## 🏗️ Database Schema Structure

### 1️⃣ Branch Table
Stores branch details.
- branch_id (Primary Key)
- manager_id
- branch_address
- contact_no

### 2️⃣ Employees Table
Stores employee information.
- emp_id (Primary Key)
- emp_name
- position
- salary
- branch_id (Foreign Key)

### 3️⃣ Books Table
Stores book information.
- book_id (Primary Key)
- title
- author
- category
- price
- availability_status

### 4️⃣ Members Table
Stores member details.
- member_id (Primary Key)
- member_name
- member_address
- reg_date

### 5️⃣ Issue_Status Table
Tracks issued books.
- issue_id (Primary Key)
- issued_member_id (Foreign Key)
- issued_book_id (Foreign Key)
- issue_date

### 6️⃣ Return_Status Table
Tracks returned books.
- return_id (Primary Key)
- return_book_id (Foreign Key)
- return_date

---

## 🔗 Relationships

- One Branch → Many Employees
- One Member → Many Issued Books
- One Book → Issue & Return Tracking

---

## 🛠️ Technologies Used

- SQL (Posgree / SQL Server Compatible)
- Relational Database Concepts
- ER Modeling
- Joins, Aggregations, Subqueries

---

## 📊 Sample SQL Operations Performed

✔ Create Database & Tables  
✔ Insert Sample Data  
✔ Retrieve Available Books  
✔ Find Issued Books  
✔ Calculate Total Salary per Branch  
✔ Track Overdue Books  
✔ Join Multiple Tables for Reporting  
✔ Aggregate Functions (SUM, COUNT, AVG)  

---

## 📈 Analytical Queries Included

- Total books per category
- Branch-wise employee salary analysis
- Most issued books
- Member borrowing history
- Available vs Issued books count

---

## 🎯 Learning Outcomes

This project helped in understanding:

- Real-world database structure
- SQL constraints & relationships
- Data normalization
- Writing optimized SELECT queries
- Business-oriented SQL analysis

---
Aouhor : Mo Saleem
LinkDin : www.linkedin.com/in/sal013
