-- Create the temp table
CREATE TABLE #Registrations(ID INT NOT NULL IDENTITY PRIMARY KEY,
	DateJoined DATE NOT NULL, DateLeft DATE NULL);

-- Variables
DECLARE @Rows INT = 10000, 
		@Years INT = 5, 
		@StartDate DATE = '2011-01-01'

-- Insert 10,000 rows with five years of possible dates
INSERT INTO #Registrations (DateJoined)
	SELECT TOP(@Rows) DATEADD(DAY,CAST(RAND(CHECKSUM(NEWID())) * @Years *
			365 as INT) ,@StartDate)
	FROM sys.objects a
		CROSS JOIN sys.objects b
		CROSS JOIN sys.objects c;

-- Give cancellation dates to 75% of the subscribers
UPDATE TOP(75) PERCENT #Registrations
	SET DateLeft = DATEADD(DAY,CAST(RAND(CHECKSUM(NEWID())) * @Years * 365
		as INT),DateJoined)

SELECT SUM(CASE WHEN DateLeft IS NULL THEN 1 ELSE 0 END)
FROM #Registrations;

WITH cte1 AS (
SELECT ID, DateJoined, DateLeft, EOMONTH(DateJoined) AS EndMonth
FROM #Registrations
),
cte2 AS (
SELECT DISTINCT EndMonth, COUNT(DateJoined) OVER(PARTITION BY EndMonth) AS NumJoin, COUNT(DateLeft) OVER(PARTITION BY EndMonth) AS NumLeft, (COUNT(DateJoined) OVER(PARTITION BY EndMonth) - COUNT(DateLeft) OVER(PARTITION BY EndMonth)) AS ActiveMonth
FROM cte1
)
SELECT EndMonth, NumJoin, NumLeft, SUM(ActiveMonth) OVER(ORDER BY EndMonth) AS TotalActive
FROM cte2
ORDER BY EndMonth;