use day14DB;

SELECT * FROM Students, Courses, StudentCourses;

-- Indexing on above table for faster lookups

CREATE NONCLUSTERED INDEX IX_STUDENT_EMAIL ON Students(email); -- Student Email

CREATE NONCLUSTERED INDEX IX_StudentMajor_Year ON Students(major, enrollment_year);  -- cOMPOSITE ON CLUSTURED Based on student major and year

-- Creating a Unique Index on email to prevent duplicates
CREATE unique INDEX UQ_Students_Email ON Students(email) WHERE email IS NOT NULL;


-- Create a non clustured Index on StudentCourses for common query patterns
CREATE NONCLUSTERED INDEX IX_StudentCourses_Grade ON StudentCourses(semester, grade)

-- Ananlyzing index usage
-- Check existing Indexes

SELECT 
	t.name AS TableName,
	i.name AS IndexName,
	i.type_desc AS IndexType,
	i.is_unique AS IsUnique

FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
where i.name IS NOT NULL;


-- Sample Queries based on indexing
SELECT * FROM Students WHere email = 'john@example.com';

-- Using composite index
SELECT * FROM Students WHERE major = 'Computer Science' AND enrollment_year = 2020;


--This tells you:

--How often each index is used (seeks/scans).

--If your index is being ignored, consider dropping or modifying it.
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks, s.user_scans, s.user_lookups, s.user_updates
FROM sys.dm_db_index_usage_stats s
JOIN sys.indexes i ON i.index_id = s.index_id AND i.object_id = s.object_id
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
ORDER BY s.user_seeks DESC;

-- List of all tables in the database
SELECT * FROM sys.tables

-- Most views in MsSQL  Server are read only by design? justify How?

-- Only simple views meeting strict criteria can be updated directly ? How?

-- View with DISTINCT
--CREATE VIEW ToAddStudentDetails
--INSERT INTO Students VALUES(1, 'Aman', 'aman@gmail.com', 'Physics', 2022);

Select * FROM CS_Students_New; -- simple updatable view ( Meets all criteria)
SELECT * FROM StudentEnrollments; --View with Join( Not directly Updatable)
SELECT OBJECT_DEFINITION(OBJECT_ID('DBO.StudentEnrollments')) AS ViewDefinition;

-- View with DISTINCT(not updatable)
CREATE VIEW UniqueMajors AS
SELECT DISTINCT major FROM Students;
SELECT * FROM UniqueMajors;

-- Below operatioj is failing because 
-- DISTINCT create a derived result set
-- SQL SERVER can't map updates back to the base table 
BEGIN TRY 
	PRINT 'Attempting to update DISTINCT view..'
	UPDATE UniqueMajors
	SET major = 'Computer Sciences'
	Where Major = 'Computer Science'
END TRY

BEGIN CATCH
	PRINT 'update failed(as Expected)';
	PRINT 'ERROR: ' +ERROR_MESSAGE();
END CATCH;


-- View with computed column ( non updatable)
Create VIEW StudentNameLengths1 AS
SELECT student_id,student_name, LEN(student_name) AS name_length
FROM Students;
SELECT * FROM StudentNameLengths;
SELECT * FROM StudentNameLengths1;


-- Thi will fail because :
-- Contain a derived column( name_length)
-- SQL Server can't update calculated values 

BEGIN TRY
	PRINT'Attempting to updated computed column';
	UPDATE StudentNameLengths
	SET student_name = 'John Travolta'
	Where name_length = 6;
END TRY

BEGIN CATCH
	PRINT 'Update Failed( a expected)';
	PRINT 'Error' + Error_Message();
END CATCH;