DROP TABLE IF EXISTS #Destination;
GO

---------------------
CREATE TABLE #Destination
(
ID			INTEGER PRIMARY KEY,
Name		VARCHAR(100)
);
GO

---------------------
INSERT INTO #Destination VALUES
(1, 'Warsaw'),
(2,	'Berlin'),
(3, 'Bucharest'),
(4, 'Prague');
GO

DROP TABLE IF EXISTS #Ticket;
GO

---------------------
CREATE TABLE #Ticket
(
CityFrom	INTEGER,
CityTo		INTEGER,
Cost		INTEGER
);
GO

---------------------
INSERT INTO #Ticket VALUES
(1, 2, 350),
(1, 3, 80),
(1, 4, 220),
(2, 3, 410),
(2, 4, 230),
(3, 2, 160),
(3, 4, 110),
(4, 2, 140),
(4, 3, 75);
GO

SELECT * FROM #Destination;
SELECT * FROM #Ticket;


DECLARE @distance INT = 1;
WITH TicketCTE AS
(
    SELECT CityFrom, CAST('1' AS VARCHAR(200)) AS Route, @distance AS DISTANCE
    FROM #Ticket
    WHERE CityFrom = 1
    UNION ALL
    SELECT B.CityTo, CAST(CONCAT_WS('->',A.Route, B.CityTo) AS VARCHAR(200)) AS Route, DISTANCE + 1
    FROM #Ticket B JOIN TicketCTE A ON B.CityTo != A.CityFrom
)
SELECT * FROM TicketCTE
OPTION (MAXRECURSION 500);


WITH CTE1 AS(
    SELECT #Ticket.* ,CityStart.Name AS StartCity ,CityEnd.Name AS EndCity
    FROM #Ticket INNER JOIN #Destination CityStart ON #Ticket.CityFrom = CityStart.ID
    INNER JOIN #Destination CityEnd ON #Ticket.CityTo = CityEnd.ID
),
CTE2 AS 
(
    SELECT CityFrom, CityTo, CAST(CONCAT_WS('->',StartCity,EndCity) AS VARCHAR(200)) AS Route ,Cost ,2 AS Distance
    FROM CTE1
    WHERE CityFrom = 1
    UNION ALL
    SELECT CTE1.CityFrom ,CTE1.CityTo ,CAST(CONCAT_WS('->',CTE2.Route,CTE1.EndCity) AS VARCHAR(200)) AS PATH ,CTE1.Cost + CTE2.Cost ,CTE2.Distance + 1
    FROM CTE1 INNER JOIN CTE2 ON CTE1.CityFrom = CTE2.CityTo
    WHERE CTE2.Route NOT LIKE '%' + CTE1.EndCity +'%' 
)
SELECT Name, Route, Cost, Distance FROM CTE2 INNER JOIN #Destination ON CTE2.CityTo = #Destination.ID
WHERE Distance = 4
ORDER BY Cost DESC;

SELECT *
FROM #TICKET;


SELECT * FROM #Destination;
SELECT * FROM #Ticket;

WITH cte1 AS(
    SELECT CityTo, CONCAT(CityFrom, '->', CityTo) AS routes, Cost
    FROM #Ticket JOIN #Destination ON #Ticket.CityFrom = #Destination.ID
    WHERE CityFrom = 1
    UNION ALL
    SELECT #Ticket.CityTo, CONCAT(cte1.routes ,'->', #Ticket.CityTo), (cte1.Cost + #Ticket.Cost) AS Cost
    FROM cte1 INNER JOIN #Ticket ON #Ticket.CityFrom = cte1.CityTo
)
SELECT cte1.routes, cte1.Cost
FROM cte1;

SELECT B.CityTo, CONCAT(A.CityFrom, '->', B.CityTo) AS Route
FROM #Ticket A JOIN #Ticket B ON B.CityTo <> A.CityFrom
WHERE A.CityFrom = 1;








WITH Travel(Path, LastId,
    TotalCost, CountPlaces) AS (
  SELECT
    CAST(Name AS NVARCHAR(MAX)),
    Id,
    0,
    1
  FROM #Destination
  WHERE Name = 'Warsaw'
  UNION ALL
  SELECT
    Travel.Path + N'->' + C2.Name,
    C2.Id,
    Travel.TotalCost + T.Cost,
    Travel.CountPlaces + 1
    FROM Travel
  INNER JOIN #Ticket T
    ON Travel.LastId = T.CityFrom
  INNER JOIN #Destination C1
    ON C1.Id = T.CityFrom
  INNER JOIN #Destination C2
    ON C2.Id = T.CityTo
  WHERE CHARINDEX(c2.name, Travel.Path) = 0
)
SELECT
  *
FROM Travel
WHERE CountPlaces = 4
ORDER BY TotalCost DESC;