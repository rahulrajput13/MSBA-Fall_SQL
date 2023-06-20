-- HOMEWORK 2 FOR RAHUL RAJPUT
-- Section 1: ENTERTAINMENT AGENCY

-- Question 1
SELECT CustFirstName, CustLastName, CASE StyleName WHEN "50's Music" THEN "Oldies"
												   WHEN "60's Music" THEN "Oldies"
                                                   WHEN "70's Music" THEN "Oldies"
                                                   WHEN "80's Music" THEN "Oldies"
                                                   ELSE StyleName
									END AS Style
FROM Customers LEFT JOIN Musical_Preferences ON Customers.CustomerID = Musical_Preferences.CustomerID
LEFT JOIN Musical_Styles ON Musical_Preferences.StyleID = Musical_Styles.StyleID;

-- Question 2
SELECT EngagementNumber
FROM Engagements
WHERE StartDate BETWEEN CAST("2017-09-30" AS DATE)
						AND CAST("2017-11-01" AS DATE)
AND StartTime BETWEEN CAST("12:00:00" AS TIME) 
					  AND CAST("17:00:00" AS TIME);
                      
-- Question 3
SELECT DISTINCT Entertainers.EntertainerID, EntStageName, IF (Engagements.StartDate < "2017-12-26" AND Engagements.EndDate > "2017-12-24" , "Yes" , "No") AS BookedOnXmas
FROM Entertainers INNER JOIN Engagements ON Entertainers.EntertainerID = Engagements.EntertainerID
WHERE Engagements.StartDate < "2017-12-26" AND Engagements.EndDate > "2017-12-24"
UNION
SELECT Entertainers.EntertainerID, EntStageName, IF (Engagements.StartDate < "2017-12-26" AND Engagements.EndDate > "2017-12-24" , "Yes" , "No")
FROM Entertainers LEFT JOIN Engagements ON Entertainers.EntertainerID = Engagements.EntertainerID
WHERE Entertainers.EntertainerID NOT IN (SELECT DISTINCT Entertainers.EntertainerID
							FROM Entertainers INNER JOIN Engagements ON Entertainers.EntertainerID = Engagements.EntertainerID
							WHERE Engagements.StartDate < "2017-12-26" AND Engagements.EndDate > "2017-12-24");

-- Question 4
SELECT CustFirstName, CustLastName
FROM Customers LEFT JOIN Musical_Preferences ON Customers.CustomerID = Musical_Preferences.CustomerID
LEFT JOIN Musical_Styles ON Musical_Preferences.StyleID = Musical_Styles.StyleID
WHERE StyleName = "Jazz"
AND Customers.CustomerID NOT IN (SELECT CustomerID FROM Musical_Preferences INNER JOIN Musical_Styles ON Musical_Preferences.StyleID = Musical_Styles.StyleID WHERE StyleName = "Standards");


-- Section 1: ACCOUNTS PAYABLE

-- Question 1
SELECT CONCAT("$",invoice_total) AS Totals 
FROM invoices;

-- Question 2
SELECT CAST(invoice_date AS CHAR) AS invoicedate, CAST(invoice_total AS UNSIGNED INT) AS invoicetotal
FROM invoices;

-- Question 3
SELECT CASE WHEN LENGTH(CAST(invoice_id AS CHAR)) = 1 THEN CONCAT("00",CAST(invoice_id AS CHAR))
									 WHEN LENGTH(CAST(invoice_id AS CHAR)) = 2 THEN CONCAT("0",CAST(invoice_id AS CHAR))
                                     ELSE invoice_id
							    END AS invoiceID
FROM invoices
ORDER BY invoiceID ASC;

-- Question 4
SELECT invoice_total, TRUNCATE(invoice_total,1) AS Trimmed1, TRUNCATE(invoice_total,0) AS Trimmed2
FROM invoices;

-- Question 5
SELECT start_date, 
    DATE_FORMAT(start_date, '%b/%d/%y') AS format1, 
    DATE_FORMAT(start_date, '%c/%e/%y') AS format2, 
    DATE_FORMAT(start_date, '%l:%i %p') AS twelve_hour,
    DATE_FORMAT(start_date, '%c/%e/%y %l:%i %p') AS format3 
FROM date_sample;

-- Question 6
SELECT vendor_name, UPPER(vendor_name) AS vendor_caps, vendor_phone, RIGHT(vendor_phone,4) AS last4,
CONCAT(TRIM(trailing ")" FROM TRIM(leading "(" FROM LEFT(vendor_phone,5))),".",SUBSTR(vendor_phone,6,4),".",RIGHT(vendor_phone,4)) AS phone_update,
SUBSTRING(vendor_name, POSITION(' ' IN vendor_name) + 1,LOCATE(' ', vendor_name, (LOCATE(' ', vendor_name) + 1)) - LOCATE(' ', vendor_name) - 1 )
FROM vendors;

-- Question 7
SELECT invoice_number, invoice_date, DATE_ADD(invoice_date, INTERVAL 30 DAY) AS Invoice_added, payment_date, (payment_date-invoice_date) AS days_to_pay, EXTRACT(MONTH FROM invoice_date) AS Month_Invoice, EXTRACT(YEAR FROM invoice_date) AS Year_invoice
FROM invoices
WHERE EXTRACT(MONTH FROM invoice_date) = 5;

-- Question 8
SELECT emp_name, SUBSTRING(emp_name,1, LOCATE(' ', emp_name)) AS FirstName, RIGHT(emp_name,LENGTH(emp_name)-LOCATE(' ', emp_name)) AS LastName
FROM string_sample;

SELECT emp_name, regexp_substr(emp_name, '^[[:alpha:]]+') as FirstName, regexp_replace(emp_name, '^[[:alpha:]]+', '') as LastName 
FROM string_sample;

