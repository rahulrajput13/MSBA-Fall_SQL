-- Create the table

CREATE TABLE #TableValues(ID INT, Data INT);

-- Populate the table
INSERT INTO #TableValues(ID, Data)
VALUES(1,100),(2,100),(3,NULL),
(4,NULL),(5,600),(6,NULL),
(7,500),(8,1000),(9,1300),
(10,1200),(11,NULL);

SELECT * FROM #TableValues;

SELECT ID, #TableValues.DATA, CASE WHEN (#TableValues.DATA IS NULL) 
                THEN 
                CASE WHEN (LAG(Data,1) OVER(ORDER BY ID)) IS NULL THEN (LAG(Data,2) OVER(ORDER BY ID))
                ELSE (LAG(Data,1) OVER(ORDER BY ID))
                END
            ELSE #TableValues.DATA
           END AS New_Data
FROM #TableValues;





WITH MaxData AS

(SELECT ID, Data, MAX(CASE WHEN Data IS NOT NULL THEN ID END) OVER(ORDER BY ID) AS MaxRowID
FROM #TableValues)

SELECT ID, Data, MAX(Data) OVER(PARTITION BY MaxRowID) AS NewData
FROM MaxData;

SELECT ID, Data, MAX(CASE WHEN Data IS NOT NULL THEN ID END) OVER(ORDER BY ID) AS MaxRowID
FROM #TableValues;







DECLARE @word varchar(50) = 'Heteroskedasticity';

WITH cte5 AS
(
    SELECT 1 AS index5
    UNION ALL
    SELECT index5 + 1 FROM cte5
    WHERE index5 < LEN(@word)
)
SELECT SUBSTRING(@word,index5,1) FROM cte5;
