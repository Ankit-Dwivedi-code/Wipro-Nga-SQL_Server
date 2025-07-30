-- Creating the databse
create database lms;

-- Using the database
use lms;

-- Droping the database
--drop database lms;

--Step 1: Creating and using the Database
--Step 2:  Create a table

Create TABLE Students(
 StudentId int primary key,
 FullName varchar(100),
 Age int,
 Email varchar(100) unique
 );
 
 Create TABLE Courses(
 CourseID int primary key,
 Coursename varchar(50),
 Credits int
 );
 
 Create table Enrollments(
 EnrollmentID int primary key,
 StudentId int,
 CourseID int,
 EnrollmentDate date
 foreign key(StudentId) references Students(StudentId),  -- Defining foreign Key 
 foreign key(CourseID) references Courses (CourseID)
 );

-- Inserting values in above table
INsert INto Students(StudentId,FullName,Age,Email)
VALUES(1,'Raj',24,'Raj@gmail.com'),
      (2,'Aditi',25,'Aditi@gmail.com');

Select * from Students;-- We never prefer uing * during development 
INsert INto Courses (CourseID,Coursename,Credits)
 VALUES (101, 'C# with MSSQL', 5),
        (102,'ASP.NET COre with Angular',6);
Select * FROM Courses;

INsert into Enrollments( EnrollmentID, StudentId, CourseID, EnrollmentDate)
VALUES(1,1,101,'2025-01-10'),
       (2,2,102,'2025-04-12');
Select * FROM Enrollments;



--updating Age = 22
update Students 
SET Age = 22
where StudentId = 1;

Select * from Students;
-- Performing airmatic/ Logical operators operations 
SELECT FullName, Age + 1 AS NextYearAge FROM Students
where Age> 22 and Email Like '%gmail.com'; -- pattern matching 


--Join
SELECT s.FullName, c.Coursename, e.EnrollmentDate
FROM Enrollments e
JOIN Students s on e.StudentId = s.StudentId
JOIN Courses c ON e.CourseID = c.CourseID



