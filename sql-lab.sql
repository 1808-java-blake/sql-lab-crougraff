-- Part I – Working with an existing database

-- 1.0	Setting up Oracle Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_Oracle.sql file and execute the scripts within.
-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Oracle Chinook database.
-- 2.1 SELECT
-- Task – Select all records from the Employee table.
SET SCHEMA 'chinook';
SELECT * FROM employee;
-- Task – Select all records from the Employee table where last name is King.
SELECT * FROM employee
    WHERE lastname = 'King';
-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
SELECT * FROM employee
    WHERE firstname = 'Andrew' and reportsto is null;
-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
SELECT * FROM album
ORDER BY title DESC;
-- Task – Select first name from Customer and sort result set in ascending order by city
SELECT firstname FROM customer
ORDER BY city;
-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
INSERT INTO genre (genreid, name) VALUES (26, 'Jam Band');
INSERT INTO genre (genreid, name) VALUES (27, 'Slow Dance');
-- Task – Insert two new records into Employee table
INSERT INTO employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone,fax,email) 
VALUES (9,'Rougraff','Chris','Software Developer',null,'1995-03-27 00:00:00', '2018-07-22 00:00:00', '122 Carica Road', 'Naples','FL','USA','34108','2397766792','123','croug327@gmail.com');
INSERT INTO employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone,fax,email) 
VALUES (10,'Kruppa','Blake','Software Trainer',null,'1993-04-22 00:00:00', '2016-07-22 00:00:00', '30440 USF Holly Drive', 'Tampa','FL','USA','33620','9093804081','321','blake.kruppa@revature.com');
-- Task – Insert two new records into Customer table
INSERT INTO customer
VALUES(60, 'Chris', 'Rougraff', 'Revature', '122 Carica Road', 'Naples', 'FL', 'USA', '34108', '2397766792', '123','croug327@gmail.com',3 );
INSERT INTO customer
VALUES(61, 'Blake', 'Kruppa', 'Revature', '30440 USF Holly Drive', 'Tampa', 'FL', 'USA', '33620', '9093804081', '321','blake.kruppa@revature.com', 4 );
-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
UPDATE customer SET firstname = 'Robert' , lastname ='Walter'
WHERE firstname = 'Aaron' and lastname = 'Mitchell';
-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
UPDATE artist SET name = 'CCR'
    WHERE name = 'Creedence Clearwater Revival';
-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
 SELECT * FROM invoice 
 WHERE billingaddress LIKE 'T%';
-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
 SELECT * FROM invoice 
 WHERE total between 15 and 50;
-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
SELECT * FROM employee
WHERE hiredate BETWEEN '2003-06-01 00:00:00' and '2004-03-01 00:00:00';
-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
DELETE FROM invoiceline
WHERE invoiceline.invoiceid IN (SELECT invoiceid FROM invoice
	  	WHERE invoice.customerid = (SELECT customerid FROM customer
			  	WHERE  firstname = 'Robert' and lastname = 'Walter'));
DELETE FROM invoice
 WHERE invoice.customerid = (SELECT customerid FROM customer
 			  	WHERE  firstname = 'Robert' and lastname = 'Walter');
DELETE FROM customer
 WHERE firstname = 'Robert' and lastname = 'Walter';
-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database
-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
CREATE OR REPLACE FUNCTION get_current_time()
RETURNS time with time zone AS $$
BEGIN
RETURN current_time;
END;
$$ LANGUAGE plpgsql;
-- Task – create a function that returns the length of a mediatype from the mediatype table
SELECT get_current_time();
create a function that returns the length of a mediatype from the mediatype table
CREATE OR REPLACE FUNCTION get_len_media_table()
RETURNS INTEGER AS $$
BEGIN
RETURN COUNT(mediatypeid) FROM mediatype;
END;
$$ LANGUAGE plpgsql;
-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
CREATE OR REPLACE FUNCTION get_avg_total()
RETURNS NUMERIC(10,2) AS $$
BEGIN
RETURN AVG(total) FROM invoice;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a function that returns the most expensive track
CREATE OR REPLACE FUNCTION most_expensive_track()
RETURNS NUMERIC(10,2) AS $$
BEGIN
	RETURN MAX(unitprice) FROM track;
END;
$$ LANGUAGE plpgsql;
-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
CREATE OR REPLACE FUNCTION avg_invoiceline_items()
RETURNS NUMERIC(10,2) AS $$
BEGIN
	RETURN AVG(unitprice) FROM invoiceline;
END;
$$ LANGUAGE plpgsql;
-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
CREATE OR REPLACE FUNCTION born_after_1968()
RETURNS refcursor AS $$
DECLARE 
	curs refcursor;
BEGIN 
     OPEN curs for SELECT * FROM employee WHERE birthdate > '1968-12-31 00:00:00';
	RETURN curs;
END;
$$ LANGUAGE plpgsql;
-- 4.0 functions
--  In this section you will be creating and executing functions. You will be creating various types of functions that take input and output parameters.
-- 4.1 Basic function
-- Task – Create a function that selects the first and last names of all the employees.
CREATE OR REPLACE FUNCTION first_last_names()
RETURNS refcursor AS $$
DECLARE curs refcursor;
BEGIN 
    OPEN curs for SELECT firstname, lastname FROM employee;
    RETURN curs;
END;
$$ LANGUAGE plpgsql;
-- 4.2 function Input Parameters
-- Task – Create a function that updates the personal information of an employee.
CREATE OR REPLACE FUNCTION employee_info_update(INOUT a INTEGER)
AS $$
BEGIN
	UPDATE employee SET firstname = 'changed user info'
	where employeeid = a;
END
$$ LANGUAGE plpgsql;
-- Task – Create a function that returns the managers of an employee.
CREATE OR REPLACE FUNCTION get_employees_managers(eid INTEGER)
RETURNS refcursor AS $$
DECLARE curs refcursor;
BEGIN
    OPEN curs for SELECT e2.* FROM employee e1, employee e2
		  WHERE e1.employeeid = e2.reportsto;
    RETURN curs;
END;
$$ LANGUAGE plpgsql;
-- 4.3 function Output Parameters
-- Task – Create a function that returns the name and company of a customer.
CREATE OR REPLACE FUNCTION get_name_company_of_customer (cid INTEGER)
RETURNS refcursor AS $$
DECLARE curs refcursor;
BEGIN
    OPEN curs for SELECT c.firstname, c.lastname, c.company FROM customer c
    WHERE c.customerid = cid;
    RETURN curs;
END;
$$ LANGUAGE plpgsql;
-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a function. You will also be working with handling errors in your SQL.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
CREATE OR REPLACE FUNCTION delete_invoice(invID INTEGER)
RETURNS void AS $$
BEGIN
DELETE FROM invoiceline
WHERE invoiceline.invoiceid IN (SELECT invoiceid FROM invoice
	  	WHERE invoice.invoiceid = invID);
DELETE FROM invoice
 WHERE invoice.invoiceid = invID;
END;
$$ LANGUAGE plpgsql;
-- Task – Create a transaction nested within a function that inserts a new record in the Customer table
DROP FUNCTION insert_customer();
CREATE OR REPLACE FUNCTION insert_customer()
RETURNS void AS $$
BEGIN
    INSERT INTO customer 
        VALUES (60,'chris','rougraff','revature','address', 'city','state','country','post', 'fax', 'email', 5);
END;
$$ LANGUAGE plpgsql;
-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.
-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
CREATE OR REPLACE FUNCTION after_insert_trigger_employee()
RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP = 'INSERT') THEN
    --do something
    END IF;
 
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER after_insert_trig
AFTER INSERT ON employee
FOR EACH ROW
EXECUTE PROCEDURE after_insert_trigger_employee(); 
-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
CREATE OR REPLACE FUNCTION after_update_trigger_album()
RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP = 'UPDATE') THEN
    --do something
    END IF;
 
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER after_update_trig
AFTER INSERT ON album
FOR EACH ROW
EXECUTE PROCEDURE after_update_trigger_album(); 
-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
CREATE OR REPLACE FUNCTION after_delete_trigger_customer()
RETURNS TRIGGER AS $$
BEGIN
    IF(TG_OP = 'DELETE') THEN
    --do something
    END IF;
 
END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER after_delete_trig
AFTER INSERT ON customer
FOR EACH ROW
EXECUTE PROCEDURE after_delete_trigger_customer(); 
-- 6.2 INSTEAD OF
-- Task – Create an instead of trigger that restricts the deletion of any invoice that is priced over 50 dollars.

-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.
-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
SELECT concat(c.firstname,concat(' ',c.lastname)) AS "Name" , i.invoiceid from customer c
INNER JOIN invoice i ON c.customerid = i.customerid;
-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
SELECT c.customerid, c.firstname, c.lastname, i.invoiceid, i.total FROM customer c
FULL JOIN invoice i ON c.customerid = i.customerid;
-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
SELECT art.name, alb.title FROM 
artist art RIGHT JOIN album alb
			ON art.artistid = alb.artistid;
-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
SELECT * FROM album alb CROSS JOIN artist art
ORDER BY art.name;
-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
SELECT * FROM employee e1, employee e2
WHERE e1.reportsto = e2.reportsto;







