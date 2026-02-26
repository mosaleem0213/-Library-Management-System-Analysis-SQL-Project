-- Library Management System Analysis SQL Project --

-- First Is Create DataBase LibraryDB --

Create DataBase LibraryDB

-- Creating the Branch Table --
 
Create Table Branch (
branch_id VARCHAR(15) PRIMARY KEY,
manager_id VARCHAR(15),
branch_add	VARCHAR(55),
contact_no VARCHAR(15)
);

-- Creating the Employees Table --
Create Table Employees (
emp_id VARCHAR(15) PRIMARY KEY,
emp_name VARCHAR(15),
position	VARCHAR(15),
salary INT,
branch_id VARCHAR(15),
FOREIGN KEY (branch_id) REFERENCES Branch(branch_id)
);

--  Increasing size of emp_name column and change TYPE for importing the data --

ALTER TABLE EMPLOYEES ALTER COLUMN emp_name TYPE VARCHAR(25);
ALTER TABLE EMPLOYEES ALTER COLUMN salary TYPE VARCHAR(10);


-- Creating the Books Table --

Create Table Books (
isbn VARCHAR(20) PRIMARY KEY,
book_title VARCHAR(75),
category VARCHAR(15),
rental_price FLOAT,
status VARCHAR(15),
author VARCHAR(35),
publisher VARCHAR(55)
);

--  Increasing size of category column for importing the data --

ALTER TABLE Books ALTER COLUMN category TYPE VARCHAR(25);


-- Creating the Members Table --

Create Table Members (
member_id VARCHAR(20) PRIMARY KEY,
member_name VARCHAR(25),
member_address VARCHAR(55),
reg_date DATE
);

-- Creating the Issued_Satatus Table --

Create Table Issued_Satatus (
issued_id VARCHAR(15) PRIMARY KEY,
member_id VARCHAR(20),
book_name VARCHAR(15),
issued_date	DATE,
isbn VARCHAR(20),
emp_id VARCHAR(15),
FOREIGN KEY (isbn) REFERENCES Books(isbn),
FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
FOREIGN KEY (member_id) REFERENCES Members(member_id)
);


--  Increasing size of book_name column for importing the data --

ALTER TABLE Issued_Satatus ALTER COLUMN book_name TYPE VARCHAR(75);

-- Creating the Return_Satatus Table --

Create Table Return_Satatus (
return_id VARCHAR(15) PRIMARY KEY,
issued_id VARCHAR(15),
book_name VARCHAR(15),
return_date	DATE,
isbn VARCHAR(20),
FOREIGN KEY (issued_id) REFERENCES Issued_Satatus(issued_id)
);


--  Increasing size of book_name column for importing the data  --

ALTER TABLE Return_Satatus ALTER COLUMN book_name TYPE VARCHAR(75);

--  Importiing and Reviewing the csv data.

Select * FROM Branch;

Select * FROM Employees;

Select * FROM Books;

Select * FROM Members;

Select * FROM Issued_Satatus ;


Select * FROM Return_Satatus;

--  Tasks CRUD Oprations --

-- Craete a New Book Record -- '978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B Lippincott & Co.' --

Select * From Books;

Insert INTO Books Values('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B Lippincott & Co.') 

-- Update an Existing Member's Address --

Select * From Members;

Update Members 
Set member_address='123 Main St'
Where member_id='C101'

Select * From Members;


-- Delete a Record from the Issued Status Table -- Objective : Delete the record with issued id='IS121' from the issued_status table.

Select * From issued_satatus
Where Issued_id='IS121';

Delete From issued_satatus
Where Issued_id='IS121';


Select * From issued_satatus
Where Issued_id='IS121';

-- Select Statement: Retrieve All Books Issued by Specific Employee ID, Select all books issued by the employee with Emp_id is 'E101'

Select * From Issued_Satatus
Where Emp_Id='E101';


-- List Members Who Have Issued More Then One Book -- Use Group By to Find members who have issued more than one book ?

Select Emp_id,
Count(issued_id) as MorethanOneBook
From Issued_Satatus
Group By Emp_id
Having Count(issued_id) >1;

-- Create Summary Table : Used CTAS to Generate new tables based on query results - each book and total book issued count.
Select * From Books;

Create Table Book_Cnt
AS
Select b.book_title,
count(ist.issued_id) as nomber_issued_books
From books b
Join issued_satatus ist
ON
b.isbn=ist.isbn
Group By 1;

Select * From Book_Cnt;

-- Retreive All Books in Specific Category: Category is Classic ?

Select * From Books 
Where Category='Classic';

-- Find Total Rental Income by Category ?

Select b.Category,
count(ist.issued_id) * Sum(b.rental_price) as Total_Rental_Income
From books b
Join issued_satatus ist
ON
b.isbn=ist.isbn
Group By 1;

-- List Members Who Registered in last 1080 Days ?

Select * From Members
Where reg_date >= CURRENT_DATE - INTERVAL  '1080 days';

-- List Employees With Their Branch Manager's Name and their branch details;

Select  e.* ,
b.manager_id,
e2.emp_name as manager
From Employees e
Join branch b
ON
e.branch_id=b.branch_id
JOIN
Employees e2
ON
b.manager_id=e2.emp_id;

--Create a Table  of books with Rental Price above a certain Thereshold 7USD.
Create Table Books_7
AS
Select * From Books
Where rental_price>7;


Select * From Books_7;


-- Rerieve the List of Books Not yet Returned ?

Select Distinct ist.book_name
from issued_satatus ist
LEFT JOIN 
return_satatus rs
ON ist.issued_id=rs.issued_id
Where rs.return_id is null;


-- Advanced SQL Operations --

/*
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue. 
*/

Select * From Books;
Select * From Members;
Select * From Issued_Satatus;
Select * From Return_Satatus;


Select isd.member_id,m.member_name,b.book_title,isd.issued_date,
CURRENT_DATE - isd.issued_date as Over_Due_Date
From Books b
Join Issued_Satatus isd
ON
b.isbn=isd.isbn
JOIN
Members m
ON
m.member_id=isd.member_id
Left Join
Return_Satatus rs
ON
rs.issued_id=isd.issued_id
-- Book is not returned yet
Where rs.return_date is null
AND
(CURRENT_DATE - isd.issued_date ) > 30
Order by isd.member_id
;

/*
Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).
*/

Select * From Books  WHERE isbn='978-0-451-52994-2';
Select * From Issued_Satatus WHERE isbn='978-0-451-52994-2';
Select * From Return_Satatus  Where return_id ='RS119' and issued_id='IS130';

-- Use Stored Procedure --

Create OR Replace Procedure add_return_records_update_book_status(p_return_id Varchar(15),p_issued_id Varchar(15))
Language plpgsql --It's a part of syntex
AS $$
DECLARE
	v_isbn VARCHAR(50);
	v_book_name VARCHAR(75);
	
Begin

	-- Inserting Values in return table. --
	Insert Into Return_Satatus(return_id,issued_id,return_date)
	Values
	(p_return_id,p_issued_id,Current_Date);

	-- Change Status in book table. --

	Select isbn,book_name
	INTO
	v_isbn,v_book_name
	From Issued_Satatus
	Where issued_id = p_issued_id;

	Update Books
	Set Status='yes'
	Where isbn=v_isbn;

	Raise Notice 'Thank you for returning the book: %', v_book_name;
End;
$$

-- Inserting the data using procedure --

Call add_return_records_update_book_status('RS119','IS130');



/*
Branch Performance Report
Create a query that generates a performance report for each branch, 
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
*/

Select * From Books;
Select * From Branch;
Select * From Issued_Satatus;
Select * From Return_Satatus;
Select * From employees;

-- CTAS --
CREATE Table Branch_Performance_Report
AS
Select 
	b.branch_id,
	b.manager_id,
	COUNT(isd.issued_id) as Total_Issued,
	COUNT(rs.return_id)  as Total_Returned,
	SUM(bk.rental_price) as Rental_Income
From Issued_Satatus isd
JOIN
employees e
ON
e.emp_id=isd.emp_id
JOIN
Branch b
ON
b.Branch_id=e.Branch_id
LEFT JOIN
Return_Satatus rs
ON
rs.issued_id=isd.issued_id
JOIN
Books bk
ON
bk.isbn=isd.isbn
Group By 1,2
Order By 1 ;

-- Show Data Using CTAS --

Select * From Branch_Performance_Report;


-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months. --

CREATE Table active_members
AS
Select * From Members
Where member_id in 
(Select Distinct member_id as Active_Members
From 
Issued_Satatus
Where issued_date >= Current_Date - INTERVAL '6 Month' 
) ;


Select * From Active_Members;

-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
Select * From Employees;
Select * From Issued_Satatus;

Select
e.emp_name,
Count(isd.issued_id) as number_of_books_issued,
b.branch_id
From 
Issued_Satatus isd
JOIN
Employees e
ON
e.emp_id=isd.emp_id
JOIN
Branch b
ON
b.branch_id=e.branch_id
Group By 1,3;



/*
 Stored Procedure Objective: 

Create a stored procedure to manage the status of books in a library system. 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). 

If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 

If the book is not available (status = 'no'), the procedure should return an message indicating that The book is currently not available Please try after some time.
*/

Select * From Books;
Select * From Issued_Satatus;


Create OR Replace Procedure Issued_Book(p_issued_id Varchar(15),p_member_id Varchar(20),p_book_name Varchar(75),p_isbn Varchar(20),p_emp_id Varchar(15))
Language plpgsql
AS $$

Declare
--Here We can declare variables
	v_status Varchar(15);

Begin
	--Check Status
	Select status
	INTO
	v_status
	From Books
	Where
	isbn=p_isbn;

	IF v_status='yes' Then
	
		-- If book is available then insert the details.
		
		Insert INTO Issued_Satatus(issued_id,member_id,book_name,issued_date,isbn,emp_id)
		
		Values (p_issued_id,p_member_id ,p_book_name,Current_Date,p_isbn,p_emp_id);
	
		--Afer Insertion We need to be update the status of books table
	
		Update Books
		Set status='no'
		Where isbn=p_isbn;
	
		Raise Notice 'The Book has been issued successfully the isbn numnber of book is : %',p_isbn;	
	ELSE 
			Raise Notice 'The book is currently not available Please try after some time. The isbn numnber of book is : %',p_isbn;	
	
	END IF;

END;
$$

Select * From Books Where status='no';
Select * From Issued_Satatus Where isbn='978-0-307-58837-1';


Call Issued_Book('IS135','C107','Sapiens: A Brief History of Humankind','978-0-307-58837-1','E108')