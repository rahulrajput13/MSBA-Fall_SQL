-- ************************
-- * EXAMPLE 5
-- ************************
-- Use recursive CTE to retrieve and display each 
-- letter of the word 'Heteroskedasticity'.

DECLARE @word varchar(50) = 'Heteroskedasticity';
DECLARE @index5 int = 1;

SELECT SUBSTRING(word,index5,1);

WITH cte5 AS
(
    SELECT SUBSTRING(word,index5,1)
    UNION ALL
    SELECT SUBSTRING(word,index5+1,1)
    WHERE index5 < LEN(word)
)
SELECT * FROM cte5;

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