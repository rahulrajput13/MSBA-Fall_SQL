-- Create the table
DROP TABLE IF EXISTS #TimeCards;

CREATE TABLE #TimeCards(
	TimeStampID INT NOT NULL IDENTITY PRIMARY KEY,
	EmployeeID INT NOT NULL,
	ClockDateTime DATETIME2(0) NOT NULL,
	EventType VARCHAR(5) NOT NULL);

-- Populate the table
INSERT INTO #TimeCards(EmployeeID,
	ClockDateTime, EventType)
VALUES
	(1,'2021-01-02 08:00','ENTER'),
	(2,'2021-01-02 08:03','ENTER'),
	(2,'2021-01-02 12:00','EXIT'),
	(2,'2021-01-02 12:34','ENTER'),
	(3,'2021-01-02 16:30','ENTER'),
	(2,'2021-01-02 16:00','EXIT'),
	(1,'2021-01-02 16:07','EXIT'),
	(3,'2021-01-03 01:00','EXIT'),
	(2,'2021-01-03 08:10','ENTER'),
	(1,'2021-01-03 08:15','ENTER'),
	(2,'2021-01-03 12:17','EXIT'),
	(3,'2021-01-03 16:00','ENTER'),
	(1,'2021-01-03 15:59','EXIT'),
	(3,'2021-01-04 01:00','EXIT');

	SELECT * FROM #TimeCards;

	
	WITH CTE5 AS(
	SELECT  TimeStampID, EmployeeID, CONVERT(VARCHAR(10), ClockDateTime, 111) AS WorkDate, ClockDateTime, CAST(ClockDateTime AS TIME) AS ClockTime, EventType, RANK() OVER(PARTITION BY EmployeeID ORDER BY ClockDateTime) AS rank_time
	FROM #TimeCards
	WHERE #TimeCards.EventType = 'ENTER'
	),
	CTE6 AS(
	SELECT  TimeStampID, EmployeeID, CONVERT(VARCHAR(10), ClockDateTime, 111) AS WorkDate, ClockDateTime, CAST(ClockDateTime AS TIME) AS ClockTime, EventType, RANK() OVER(PARTITION BY EmployeeID ORDER BY ClockDateTime) AS rank_time
	FROM #TimeCards
	WHERE #TimeCards.EventType = 'EXIT'
	)
	SELECT CTE5.EmployeeID, CTE5.WorkDate AS WorkDate, convert(varchar(5),DateDiff(s, CTE5.ClockDateTime, CTE6.ClockDateTime)/3600)+':'+convert(varchar(5),DateDiff(s, CTE5.ClockDateTime, CTE6.ClockDateTime)%3600/60)+':'+convert(varchar(5),(DateDiff(s, CTE5.ClockDateTime, CTE6.ClockDateTime)%60)) as [hh:mm:ss]
	FROM CTE5 JOIN CTE6 ON CTE5.EmployeeID = CTE6.EmployeeID AND CTE5.rank_time = CTE6.rank_time
	ORDER BY CTE5.EmployeeID, WorkDate;

	
	SELECT A.EmployeeID, B.EmployeeID, A.TimeStampID, A.EventType, B.TimeStampID, A.ClockDateTime, B.ClockDateTime
	FROM #TimeCards A INNER JOIN #TimeCards B ON
	A.EmployeeID = B.EmployeeID
	AND A.ClockDateTime < B.ClockDateTime
	AND A.EventType != B.EventType
	AND A.EventType = 'ENTER'
	AND B.EventType = 'EXIT'
	AND DATEDIFF(HOUR,A.ClockDateTime,B.ClockDateTime) < 24
	ORDER BY A.EmployeeID, A.ClockDateTime;



