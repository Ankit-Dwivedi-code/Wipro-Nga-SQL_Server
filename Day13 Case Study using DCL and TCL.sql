create Database CollegeDB;
USE CollegeDB;

CREATE TABLE Student(
StudentID INT PRIMARY KEY,
FullNAME VARCHAR(100) NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL,
Age INT CHECK ( AGE >= 18)
);

CREATE TABLE Instructor(
InstructorID INT PRIMARY KEY,
FullName VARCHAR(100),
Email VARCHAR(100) UNIQUE
);

CREATE TABLE Course(
CourseID INT PRIMARY KEY,
CourseName VARCHAR(100),
InstructorID INT,
FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);

--ALTER TABLE Course rename  FullName to CourseName

--Drop table Course


CREATE TABLE Enrollment(
EnrollmentID INT PRIMARY KEY,
StudentID INT,
CourseID INT,
ErollmentDate DATE DEFAULT GETDATE(),
FOREIGN KEY(StudentID) REFERENCES Student(StudentID),
FOREIGN KEY(CourseID) REFERENCES Course(CourseID)
);


-- Inserting Into Above Tables
INSERT INTO Instructor VALUES
(1, 'Dr. Smith', 'Smith@gmail.com'),
(2, 'prof. Mani', 'Mani@gmail.com')

--select * from Instructor

--Inserting into Course Table
INSERT INTO Course VALUES
(101, 'Backend', 1),
(102, '.NET FSD with Azure Cloud', 2);

--Inserting into Student
INSERT INTO Student VALUES
(1, 'Rohit', 'Rohit@UCLA.UK', 19),
(2, 'Rashi', 'Rashi@UCLA.UK', 27);

INSERT INTO Enrollment (EnrollmentID, StudentID, CourseID)
VALUES (1002, 2, 102);

select * from Student;
select * from Enrollment;

-- Grant and Revoke
GRANT SELECT ON Student TO auditor;
GRANT SELECT ON Student TO auditor;

-- FOR ABOVE TO WORK WE HAVE TO CREATE LOGIN AND USERS
CREATE LOGIN auditor WITH PASSWORD = 'StrongPassword123';
CREATE USER auditor FOR LOGIN auditor;

-- FOR REVOKING
REVOKE SELECT ON STUDENT FROM auditor; -- for revoking access after some time

-- Implementing a transaction with commit and roll back
BEGIN TRANSACTION;
INSERT INTO Student VALUES(3, 'Alex', 'Alex@HWD.edu', 20);
INSERT INTO Enrollment VALUES(1003, 3, 101, GETDATE());
COMMIT;

-- Rollback
BEGIN TRANSACTION;
INSERT INTO Student VALUES(4, 'Angel', 'Angel@UCLA.UK', 17);
ROLLBACK;

-- Which students are enrolled in which courses
SELECT s.FullNAME, c.CourseName
FROM Enrollment e
INNER JOIN Student s ON e.StudentID = s.StudentID
INNER JOIN Course c ON e.CourseID = c.CourseID;

--Who is teaching each course 
SELECT c.CourseName, i.FullName
FROM Course c
INNER JOIN Instructor i ON c.InstructorID = i.InstructorID;

-- Procedure to get student info by ID
CREATE PROCEDURE GetStudentByID
    @StudentID INT  -- Input parameter to search by Student ID
AS
BEGIN
    -- Selecting student details for the given ID
    SELECT StudentID, FullNAME, Age, Email
    FROM Student
    WHERE StudentID = @StudentID;
END;
-- Calling the procedure to get details of student with ID = 1
EXEC GetStudentByID @StudentID = 1;