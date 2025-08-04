--Steps for implemeting a function
-- Step 1: Creating a table, Inserting values
-- Step 2: Implementing Builtin Scalar function

use lms;

-- Creating Department table
create TABLE Department(
DeptID int primary KEY,
DeptName varchar(50)
);

-- Creating a Employee table
create TABLE Employee(
EmpID INT primary KEY,
EmpName varchar(100),
Salary decimal(10, 2),
DeptID int,
ManagerID int,
DateOfJoining date,
);

INSERT INTO Department VALUES(1, 'HR'),(2, 'Finance'), (3, 'IT');

INSERT INTO Employee VALUES
(101, 'Raj', 30000, 3, null, '2024-01-15'),
(102, 'Rajeev', 35000, 2, 101, '2021-03-12'),
(103, 'Raju', 50000, 3, 101, '2022-11-25'),
(104, 'Rajni', 39000, 2, null, '2024-01-15'),
(105, 'Ankit', 90000, 3, 102, '2002-10-29')

-- Implementing built in SCALAR Function

SELECT EmpName, Len(EmpName) As NameLength FROM Employee;

SELECT EmpName, ROUND(Salary, -1) As RoundedSalary FROM Employee;
--positive value rounds to decimal place (Round(123.456,2) -> 123.46)
--Negative values rounds to power of 10 of the left(Round(12345, -2)) -> 12300

SELECT GETDATE() As CurrentDate;

-- Aggregate Functions

Select Count(*) As TotalEmployees FROM Employee;
Select ROUND(AVG(Salary), -2) AS AverageSalary FROM Employee;
SELECT MAX(Salary) AS MaxSalary FROM Employee;

-- Types of JOINS
-- Inner Joins : Return only matching rows from both table

SELECT E.EmpName, D.DeptName
FROM Employee AS E
INNER JOIN Department AS D
ON E.DeptID = D.DeptID;

Select E.EmpName, D.DeptName
FROM Employee E
INNER JOIN Department D ON E.DeptID = D.DeptID;

-- Left Joins: Returns all rows from the left table and matched rows from the right table

SELECT E.EmpName, D.DeptName
From Employee As E
Left Join Department as D On E.DeptID = D.DeptID;
-- Right Joins: Returns all rows from the right table and matched rows from the left
SELECT E.EmpName, D.DeptName
FROM Employee AS E
RIGHT JOIN Department as D On E.DeptId = D.DeptId;
-- Full joins: Return all rows where there is a match in one of the table

SELECT E.EmpName, D.DeptName
From Employee As E
Full outer  JOIN Department as D On E.DeptID = D.DeptID;
-- Self JOINS: A Table is joined with itself , of the using aliases.

SELECT E1.EmpName as Employee, E2.EmpName As Manager
From Employee E1
 JOIN Employee E2 On E1.ManagerID = E2.EmpID;

SELECT E1.EmpName as Employee, E2.EmpName As Manager
From Employee E1
LEFT JOIN Employee E2 On E1.ManagerID = E2.EmpID;


-- Cross JOINS: Returns the cartsian product of two table(All Possible combination

 
SELECT EmpName, DeptName from Employee 
Cross Join Department;


-- UNION 
SELECT EmpName FROM Employee
UNION
SELECT DeptName FROM Department;


--INTERSECTION
SELECT EmpName FROM Employee
INTERSECT
SELECT DeptName FROM Department;


SELECT DeptID FROM Employee
INTERSECT
SELECT DeptID FROM Department;

--Creating a procedure

CREATE procedure GetEmployeeDetails
@EmpID INT, @EmpName varchar(100) OUTPUT
AS 
BEGIN
SELECT @EmpName = EmpName FROM  Employee
WHERE EmpID = @EmpID;
END

Declare @Name VARCHAR(100);
EXEC GetEmployeeDetails 103, @EmpName = @Name
OUTPUT;
PRINT @Name;

-- Update employee details

Create procedure UpdateEmployeeDetails 
@EmpID int, @NewSalary decimal(10,2) output
as
begin
update Employee
set salary = @NewSalary
where EmpID = @EmpID;
end;

execute UpdateEmployeeDetails @EmpID= 103, @NewSalary = 90000;


-- Check salary

create procedure CheckSalary
@EmpID int
as begin
declare @Salary decimal(10, 2)
select @Salary = Salary from Employee where EmpID = @EmpID
if @Salary > 55000
print 'High Earner'
else
print 'Low Earner'
end

EXEC CheckSalary 103;

-- Creating a Transaction & Error Handling

BEGIN TRY
	BEGIN Transaction;
	UPDATE Employee SET Salary = Salary + 5000 WHERE DeptID = 2;
	commit -- All changes will be permanent here
END TRY

BEGIN CATCH
    rollback;
	Print 'Something went wrong!';
END CATCH

SELECT * FROM Employee WHERE DeptID = 2;

-- Saclar Function

CREATE function GetYearOfJoining( @EmpID int)
returns INT

AS

BEGIN 
	Declare @Year INT;
	SELECT @Year = Year(DateOfJoining) FROM Employee WHERE EmpID = @EmpID;
	RETURN @Year;
END

-- Calling a function
SELECT EmpName, dbo.GetYearOfJoining(EmpID) AS JoiningYear FROM Employee;
SELECT * FROM sys.objects WHERE name = 'GetYearOfJoining';

--Inline Table Valued Function

CREATE FUNCTION GetEmployeeByDept(@DeptID int)
returns Table
AS
return
(
  SELECT EmpID, EmpName, Salary FROM Employee Where DeptID = @DeptID
  )

  SELECT * FROM dbo.GetEmployeeByDept(2);

  -- Using funct in procedure

create procedure PrintEmployeeJoiningYear
@EmpID int
as
begin
declare @Year int;
set @Year = dbo.GetYearOfJoining(@EmpID); 
print 'Joined' + cast (@Year as varchar);
end

execute PrintEmployeeJoiningYear 101;
