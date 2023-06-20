-- What is a recursive query?
-- A recursive query is a query that is able to loop
-- through a result set and perform the processing to return 
-- a final result set.

-- What is a recursive CTE?
-- Recursive CTE is a block of query that contains a
-- recursive query; i.e., it references itself recursively
-- an returns a set of data.

-- Use cases:
-- Query hierarchical data (org charts, Bill of Materials, etc.)
-- Creating any sequence
-- Extracting characters of a string

-- Structure of a recursive CTE
-- WITH RecursiveCTEName AS
-- (
--		Anchor member (query)
--		UNION ALL (separator)
--		Recursive member (query)
--		Termination check
-- )
-- SELECT * FROM RecursiveCTEName

-- Anchor member and the recursive member 
-- must have the same number of columns.

-- ************************
-- * EXAMPLE 1
-- ************************
-- Create a sequence of numbers from 1 to 20.
WITH SequenceCTE AS
(
	SELECT 1 As Cnt					-- Anchor member
	UNION ALL
	SELECT Cnt + 1 FROM SequenceCTE -- Recursive member
	WHERE Cnt < 20					-- Termination check
)
SELECT * FROM SequenceCTE;			-- Invocation

-- ************************
-- * EXERCISE 1
-- ************************
-- Copy and paste the query from Example 1 below.
-- Modify the query to show numbers from 20 to 5 
-- (inclusive in descending order.)
/* WRITE YOUR QUERY TO EXERCISE 1 HERE...*/

WITH SequenceCTE AS
(
	SELECT 20 As Cnt					-- Anchor member
	UNION ALL
	SELECT Cnt - 1 FROM SequenceCTE -- Recursive member
	WHERE Cnt > 5					-- Termination check
)
SELECT * FROM SequenceCTE;			-- Invocation

-- ************************
-- * EXAMPLE 2
-- ************************
-- Display two columns: First column containing the sequence
-- from 1 to 10 and the second column containing the running
-- total of the values.
DECLARE @PreviousValue INT = 1;
DECLARE @PreviousSum INT = 1;

WITH RunningTotalCTE AS
(
	SELECT @PreviousValue AS PreviousValue, @PreviousSum AS RunningTotal
	UNION ALL
	SELECT PreviousValue + 1, (PreviousValue + 1)*2
	FROM RunningTotalCTE
	WHERE PreviousValue < 10
)
SELECT * FROM RunningTotalCTE;

-- ************************
-- * EXERCISE 2
-- ************************
-- Copy and paste the query from Example 2 below.
-- Modify the query to show two columns:
-- First column: Numbers from 1 to 10
-- Second column: Respective number multiplied by 2
/* WRITE YOUR QUERY TO EXERCISE 2 HERE...*/

DECLARE @PreviousValue INT = 1;
DECLARE @PreviousSum INT = 1;

WITH RunningTotalCTE AS
(
	SELECT @PreviousValue AS PreviousValue, @PreviousSum AS RunningTotal
	UNION ALL
	SELECT PreviousValue + 1, (PreviousValue + 1)*2
	FROM RunningTotalCTE
	WHERE PreviousValue < 10
)
SELECT * FROM RunningTotalCTE;

-- RISK: Recursive query entering an infinite loop.
-- May be due to code error
-- Default MaxRecursion (max. no. of cycles executed by 
-- the recursive CTE).

-- ************************
-- * EXAMPLE 3
-- ************************
-- Try to generate a sequence from 1 to 150.
WITH SequenceCTE AS
(
	SELECT 1 As Cnt					-- Anchor member
	UNION ALL
	SELECT Cnt + 1 FROM SequenceCTE -- Recursive member
	WHERE Cnt < 150					-- Termination check
)
SELECT * FROM SequenceCTE;			-- Invocation

-- Using MAXRECURSION
WITH SequenceCTE AS
(
	SELECT 1 As Cnt					-- Anchor member
	UNION ALL
	SELECT Cnt + 1 FROM SequenceCTE -- Recursive member
	WHERE Cnt < 150					-- Termination check
)
SELECT * FROM SequenceCTE			-- Invocation
OPTION (MAXRECURSION 200);			-- 0 means no limit

-- ************************
-- * EXAMPLE 4
-- ************************
-- Create a sequence of dates, say from, Nov 1, 2023 to Nov 10, 2023.
DECLARE @StartDate DATE = '2022-11-01';
DECLARE @EndDate DATE = '2022-11-10';

WITH DateSequenceCTE AS
(
	SELECT @StartDate AS SomeDate
	UNION ALL
	SELECT DATEADD(dd, 1, SomeDate)
	FROM DateSequenceCTE
	WHERE DATEADD(dd, 1, SomeDate) <= @EndDate
)
SELECT * FROM DateSequenceCTE;

-- ************************
-- * EXAMPLE 5
-- ************************
-- Use recursive CTE to retrieve and display each 
-- letter of the word 'Heteroskedasticity'.

DECLARE @word varchar(50) = 'Heteroskedasticity';

WITH LetterRetrieveCTE AS
(
	SELECT 1 As Cnt						  -- Anchor member
	UNION ALL
	SELECT Cnt + 1 FROM LetterRetrieveCTE -- Recursive member
	WHERE Cnt < LEN(@word)				  -- Termination check
)
SELECT SUBSTRING(@word, Cnt, 1) as Character 
FROM LetterRetrieveCTE;					  -- Invocation

-- ************************
-- * EXAMPLE 6
-- ************************
-- Query hierarchical data.
---------------------
---------------------
DROP TABLE IF EXISTS #Employees;
GO

---------------------
---------------------
CREATE TABLE #Employees
(
EmployeeID  INTEGER PRIMARY KEY,
FirstName	VARCHAR(100),
LastName	VARCHAR(100),
JobTitle    VARCHAR(100),
ManagerID	INTEGER
);
GO

---------------------
---------------------
INSERT INTO #Employees VALUES
(1, 'Madeline', 'Ray', 'President', NULL),
(2,	'Violet', 'Green', 'Director of Finance', 1),
(3,	'Alton', 'Vasquez', 'Director of Engg.', 1),
(4,	'Geoffrey', 'Delago', 'HR Director', 1),
(5,	'Paul', 'Allen', 'Director of Policy and Planning', 1),
(6,	'Allen', 'Garcia', 'Sr. Engg. Manager', 3),
(7,	'Marian', 'Daniels', 'Sr. Financial Manager', 2),
(8,	'Tricia', 'Wong', 'Sr. Personnel Analyst', 4),
(9,	'Bruce', 'Grant', 'Research Analyst', 5),
(10,'Bob', 'Freeman', 'Engineer', 6),
(11,'Darin', 'Burke', 'Engineer', 6),
(12,'Patricia', 'Wheeler', 'Accountant', 7),
(13,'Jeff', 'Trumbo', 'Budget Analyst', 7);
GO

SELECT * FROM #EMPLOYEES;

-- Query to create the hierarchy
WITH EmployeeSupvCTE AS
(
	SELECT EmployeeID, FirstName, LastName, JobTitle, ManagerID, CAST('Boss' as Varchar(200)) AS path
	FROM #Employees
	WHERE ManagerID IS NULL
	UNION ALL
	SELECT emp.EmployeeID, emp.FirstName, emp.LastName, emp.JobTitle, emp.ManagerID,
		  CAST(CONCAT_WS(' -> ', mgr.path, emp.LastName) as Varchar(200)) AS path
	FROM #Employees emp
	INNER JOIN EmployeeSupvCTE mgr
	ON emp.ManagerID = mgr.EmployeeID
)
SELECT * FROM EmployeeSupvCTE;

-- ************************
-- * EXERCISE 3
-- ************************
-- Extend the previous query to include the a new column "Distance"
-- which is defined as the number of people from the boss
-- to that person. Boss: Distance = 0, Boss's direct
-- subordinates: Distance = 1, Their subordinates: Distance = 2,...
/* WRITE YOUR QUERY TO EXERCISE 3 HERE...*/

DECLARE @distance INT = 1;

WITH EmployeeSupvCTE AS
(
	SELECT EmployeeID, FirstName, LastName, JobTitle, ManagerID, CAST('Boss' as Varchar(200)) AS path, @distance AS DISTANCE
	FROM #Employees
	WHERE ManagerID IS NULL
	UNION ALL
	SELECT emp.EmployeeID, emp.FirstName, emp.LastName, emp.JobTitle, emp.ManagerID,
		  CAST(CONCAT_WS(' -> ', mgr.path, emp.LastName) as Varchar(200)) AS path, DISTANCE+1
	FROM #Employees emp
	INNER JOIN EmployeeSupvCTE mgr
	ON emp.ManagerID = mgr.EmployeeID
)
SELECT * FROM EmployeeSupvCTE;

-- ************************
-- * EXERCISE 4
-- ************************
-- Show the EmployeeID, FirstName, LastName, JobTitle,
-- ManagerID of each subordinate of the employee with EmployeeID = 2 
-- (not only the direct subordinates, but also their 
-- subordinates etc.) and the employee herself.
/* WRITE YOUR QUERY TO EXERCISE 4 HERE...*/

WITH EmployeeSupvCTE AS
(
	SELECT EmployeeID, FirstName, LastName, JobTitle, ManagerID, CAST('Boss' as Varchar(200)) AS path
	FROM #Employees
	WHERE EmployeeID = 2
	UNION ALL
	SELECT emp.EmployeeID, emp.FirstName, emp.LastName, emp.JobTitle, emp.ManagerID,
		  CAST(CONCAT_WS(' -> ', mgr.path, emp.LastName) as Varchar(200)) AS path
	FROM #Employees emp
	INNER JOIN EmployeeSupvCTE mgr
	ON emp.ManagerID = mgr.EmployeeID
)
SELECT * FROM EmployeeSupvCTE;

-- ************************
-- * EXERCISE 5
-- ************************
-- Show only the complete path from the Boss to the 
-- employee with EmployeeID = 10.
/* WRITE YOUR QUERY TO EXERCISE 5 HERE...*/

WITH EmployeeSupvCTE AS
(
	SELECT EmployeeID, FirstName, LastName, JobTitle, ManagerID, CAST('Boss' as Varchar(200)) AS path
	FROM #Employees
	WHERE ManagerID = NULL
	UNION ALL
	SELECT emp.EmployeeID, emp.FirstName, emp.LastName, emp.JobTitle, emp.ManagerID,
		  CAST(CONCAT_WS(' -> ', mgr.path, emp.LastName) as Varchar(200)) AS path
	FROM #Employees emp
	INNER JOIN EmployeeSupvCTE mgr
	ON emp.ManagerID = mgr.EmployeeID
)
SELECT * FROM EmployeeSupvCTE
WHERE EmployeeID=10;
