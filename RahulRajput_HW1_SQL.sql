-- HOMEWORK 1 FOR RAHUL RAJPUT
-- Section 1: COLONIAL

-- Question 1
SELECT TripName FROM Trip WHERE Season = "Late Spring";

-- Question 2
SELECT TripName FROM Trip WHERE State = "VT" OR MaxGrpSize > 10;

-- Question 3
SELECT TripName FROM Trip WHERE Season = "Early Fall" OR Season = "Late Fall";

-- Question 4 
SELECT COUNT(TripName) FROM Trip WHERE State = "VT" OR State = "CT";

-- Question 5
SELECT TripName FROM Trip WHERE NOT State = "NH";

-- Question 6
SELECT TripName,StartLocation FROM Trip WHERE Type = "Biking";

-- Question 7
SELECT TripName FROM Trip WHERE Type = "Hiking" AND Distance > 6
	ORDER BY TripName ASC;

-- Question 8
SELECT TripName From Trip WHERE State = "VT" OR Type = "Paddling";

-- Question 9
SELECT COUNT(TripName) FROM Trip WHERE Type = "Hiking" OR Type = "Biking";

-- Question 10
SELECT TripName, State FROM Trip WHERE Season = "Summer"
	ORDER BY State ASC, TripName ASC;
    
-- Question 11
SELECT TripName 
FROM Trip, TripGuides, Guide
WHERE Trip.TripID = TripGuides.TripID
AND TripGuides.GuideNum = Guide.GuideNum
AND Guide.FirstName = "Miles";

-- Question 12
SELECT TripName
FROM Trip
INNER JOIN TripGuides ON Trip.TripID = TripGuides.TripID
INNER JOIN Guide ON TripGuides.GuideNum = Guide.GuideNum
WHERE Type = "Biking" 
AND FirstName = "Rita";

-- Question 13
SELECT Customer.LastName, Trip.TripName, Trip.StartLocation
FROM Trip, Reservation, Customer
WHERE Trip.TripID = Reservation.TripID
AND Reservation.CustomerNum = Customer.CustomerNum
AND Reservation.TripDate = "2018-07-23";

SELECT LastName, TripName, StartLocation
FROM Trip
INNER JOIN Reservation ON Trip.TripID = Reservation.TripID
INNER JOIN Customer ON Reservation.CustomerNum = Customer.CustomerNum
WHERE TripDate = "2018-07-23";

-- Question 14
SELECT COUNT(ReservationID) FROM Reservation WHERE TripPrice > 50.00 AND TripPrice < 100.00;

-- Question 15
SELECT LastName, TripName, Type
FROM Trip
INNER JOIN Reservation ON Trip.TripID = Reservation.TripID
INNER JOIN Customer ON Reservation.CustomerNum = Customer.CustomerNum
WHERE TripPrice > 100;

-- Question 16
SELECT LastName
FROM Customer, Reservation, Trip
WHERE Trip.TripID = Reservation.TripID
AND Reservation.CustomerNum = Customer.CustomerNum
AND Trip.State = "ME";

-- Question 17
SELECT State, COUNT(*)
FROM Trip
GROUP BY State
ORDER BY State;

-- Question 18
SELECT Reservation.ReservationID, Customer.LastName, Trip.TripName
FROM Trip, Reservation, Customer
WHERE Trip.TripID = Reservation.TripID
AND Reservation.CustomerNum = Customer.CustomerNum
AND Reservation.NumPersons > 4;

-- Question 19
SELECT TripName, FirstName, LastName
FROM Trip
INNER JOIN TripGuides ON Trip.TripID = TripGuides.TripID
INNER JOIN Guide ON TripGuides.GuideNum = Guide.GuideNum
WHERE Trip.State = "NH"
ORDER BY TripName ASC, LastName ASC;

-- Question 20
SELECT Reservation.ReservationID, Reservation.CustomerNum, Customer.LastName, Customer.FirstName
FROM Reservation, Customer
WHERE Reservation.CustomerNum = Customer.CustomerNum
AND Reservation.TripDate > "2018-06-30" AND Reservation.TripDate < "2018-08-01";

-- Question 21
ALTER TABLE Reservation
ADD TotalCost decimal;

SET SQL_SAFE_UPDATES = 0;
UPDATE Reservation
SET TotalCost = ((Reservation.TripPrice + Reservation.OtherFees)*Reservation.NumPersons);
SET SQL_SAFE_UPDATES = 1;

SELECT ReservationID, TripName, LastName, FirstName, TotalCost
FROM Trip
INNER JOIN Reservation ON Trip.TripID = Reservation.TripID
INNER JOIN Customer ON Reservation.CustomerNum = Customer.CustomerNum
WHERE Reservation.NumPersons > 4;

-- Question 22
SELECT FirstName, LastName FROM Customer WHERE FirstName LIKE "S%" OR FirstName LIKE "L%";

-- Question 23
SELECT DISTINCT TripName
FROM Trip
INNER JOIN Reservation ON Trip.TripID = Reservation.TripID
WHERE Reservation.TripPrice BETWEEN 30.00 AND 50.00;

-- Question 24
SELECT COUNT(TripName)
FROM Trip
INNER JOIN Reservation ON Trip.TripID = Reservation.TripID
WHERE Reservation.TripPrice BETWEEN 30.00 AND 50.00;

-- Question 25
SELECT Trip.TripID, Trip.TripName, Reservation.ReservationID
FROM Trip
LEFT OUTER JOIN Reservation ON Trip.TripID = Reservation.TripID
WHERE Reservation.ReservationID is NULL;

-- Question 26
SELECT A.TripName AS TripName1, B.TripName AS TripName2, A.StartLocation
FROM Trip A, Trip B
WHERE A.StartLocation = B.StartLocation
AND A.TripID <> B.TripID
ORDER BY A.TripID, B.TripID;

-- Question 27
SELECT DISTINCT * 
FROM Customer
LEFT JOIN Reservation ON Customer.CustomerNum = Reservation.CustomerNum
WHERE Customer.State = "NJ" OR ReservationID IS NOT NULL;

-- Question 28
SELECT *
FROM Guide
LEFT OUTER JOIN TripGuides ON Guide.GuideNum = TripGuides.GuideNum
WHERE TripID IS NULL;

-- Question 29
SELECT A.FirstName AS FirstName1, A.LastName AS LastName1, B.FirstName AS FirstName2, B.LastName AS LastName2, A.State
FROM Guide A, Guide B
WHERE A.State = B.State
AND A.GuideNum <> B.GuideNum
ORDER BY A.FirstName, B.FirstName;

-- Question 30
SELECT A.FirstName AS FirstName1, A.LastName AS LastName1, B.FirstName AS FirstName2, B.LastName AS LastName2, A.City
FROM Guide A, Guide B
WHERE A.City = B.City
AND A.GuideNum <> B.GuideNum
ORDER BY A.FirstName, B.FirstName;


-- SECTION 2: ENTERTAINMENT AGENCY


-- Question 1
SELECT AgtFirstName, AgtLastName, AgtPhoneNumber FROM Agents ORDER BY AgtLastName ASC, AgtFirstName ASC;

-- Question 2
SELECT EngagementNumber, StartDate FROM Engagements ORDER BY StartDate DESC, EngagementNumber ASC;

-- Question 3
SELECT AgtFirstName, AgtLastName, DateHired, DATE_ADD(DateHired, Interval 6 month) AS PerfReviewDate FROM Agents;

-- Question 4
SELECT EngagementNumber FROM Engagements 
WHERE EndDate BETWEEN "2017-09-30" AND "2017-11-01"
AND StartDate BETWEEN "2017-09-30" AND "2017-11-01";

-- Question 5
SELECT EngagementNumber FROM Engagements
WHERE EndDate BETWEEN "2017-09-30" AND "2017-11-01"
AND StartDate BETWEEN "2017-09-30" AND "2017-11-01"
AND StartTime BETWEEN "13:00:00" AND "17:00:00"; 

-- Question 6
SELECT EngagementNumber FROM Engagements
WHERE StartDate = EndDate; 

-- Question 7
SELECT Agents.AgtFirstName, Agents.AgtLastName, Engagements.StartDate
FROM Agents, Engagements
WHERE Agents.AgentID = Engagements.AgentID
ORDER BY Engagements.StartDate;

-- Question 8
SELECT Customers.CustFirstName, Customers.CustLastName, Entertainers.EntStageName
FROM Customers
INNER JOIN Engagements ON Customers.CustomerID = Engagements.CustomerID
INNER JOIN Entertainers ON Engagements.EntertainerID = Entertainers.EntertainerID;

-- Question 9
SELECT DISTINCT AgtFirstName, AgtLastName, EntStageName, AgtZipCode
FROM Agents
INNER JOIN Engagements ON Agents.AgentID = Engagements.AgentID
INNER JOIN Entertainers ON Engagements.EntertainerID = Entertainers.EntertainerID
WHERE Agents.AgtZipCode = Entertainers.EntZipCode;

-- Question 10
SELECT EntStageName, EntPhoneNumber, EntCity FROM Entertainers
WHERE EntCity = "Bellevue" OR EntCity = "Redmond" OR EntCity = "Woodinville"
ORDER BY EntStageName ASC;

-- Question 11
SELECT EngagementNumber FROM Engagements
WHERE (EndDate - StartDate) = 4;

-- Question 12
SELECT Entertainers.EntStageName, Engagements.StartDate, Engagements.EndDate, Engagements.ContractPrice
FROM Entertainers, Engagements
WHERE Engagements.EntertainerID = Entertainers.EntertainerID
ORDER BY Entertainers.EntStageName;

-- Question 13
SELECT Entertainers.EntStageName, Engagements.StartDate, Engagements.EndDate, Engagements.ContractPrice
FROM Entertainers, Engagements
WHERE Engagements.EntertainerID = Entertainers.EntertainerID
ORDER BY Entertainers.EntStageName;

-- Question 14
SELECT DISTINCT EntStageName
FROM Entertainers
INNER JOIN Engagements ON Engagements.EntertainerID = Entertainers.EntertainerID
INNER JOIN Customers ON Engagements.CustomerID = Customers.CustomerID
WHERE CustLastName = "Berg" OR CustLastName = "Hallmark";

-- Question 15
SELECT Agents.AgtFirstName, Agents.AgtLastName, Engagements.StartDate
FROM Agents, Engagements
WHERE Agents.AgentID = Engagements.AgentID
ORDER BY Engagements.StartDate;

-- Question 16
SELECT Customers.CustFirstName, Customers.CustLastName, Entertainers.EntStageName
FROM Customers
INNER JOIN Engagements ON Customers.CustomerID = Engagements.CustomerID
INNER JOIN Entertainers ON Engagements.EntertainerID = Entertainers.EntertainerID
ORDER BY CustFirstName;

-- Question 17
SELECT DISTINCT AgtFirstName, AgtLastName, EntStageName, AgtZipCode AS zipcode
FROM Agents
INNER JOIN Engagements ON Agents.AgentID = Engagements.AgentID
INNER JOIN Entertainers ON Engagements.EntertainerID = Entertainers.EntertainerID
WHERE Agents.AgtZipCode = Entertainers.EntZipCode;

-- Question 18
SELECT EntStageName
FROM Entertainers
LEFT JOIN Engagements ON Entertainers.EntertainerID = Engagements.EntertainerID
WHERE EngagementNumber IS NULL;

-- Question 19
SELECT StyleName, CustFirstName, CustLastName
FROM Musical_Styles
LEFT JOIN Musical_Preferences ON Musical_Styles.StyleID = Musical_Preferences.StyleID
LEFT JOIN Customers ON Musical_Preferences.CustomerID = Customers.CustomerID;

-- Question 20
SELECT AgtFirstName, AgtLastName
FROM Agents
LEFT JOIN Engagements ON Agents.AgentID = Engagements.AgentID
LEFT JOIN Entertainers ON Engagements.EntertainerID = Entertainers.EntertainerID
WHERE Entertainers.EntertainerID IS NULL;

-- Question 21
SELECT CustFirstName, CustLastName
FROM Customers
LEFT JOIN Engagements ON Customers.CustomerID = Engagements.CustomerID
WHERE EngagementNumber IS NULL;

-- Question 22
SELECT EntStageName, EngagementNumber
FROM Entertainers
LEFT JOIN Engagements ON Entertainers.EntertainerID = Engagements.EntertainerID;

-- Question 23
SELECT CustFirstName, CustLastName, EntStageName
FROM Customers
LEFT JOIN Engagements ON Customers.CustomerID = Engagements.CustomerID
LEFT JOIN Entertainers ON Engagements.EntertainerID = Entertainers.EntertainerID
UNION
SELECT CustFirstName, CustLastName, EntStageName
FROM Customers
RIGHT JOIN Engagements ON Customers.CustomerID = Engagements.CustomerID
RIGHT JOIN Entertainers ON Engagements.EntertainerID = Entertainers.EntertainerID;
-- OR
SELECT CustFirstName FROM Customers
UNION
SELECT EntStageName FROM Entertainers;

-- Question 24
SELECT Customers.CustomerID, CustFirstName
FROM Customers
INNER JOIN Musical_Preferences ON Customers.CustomerID = Musical_Preferences.CustomerID
INNER JOIN Musical_Styles ON Musical_Preferences.StyleID = Musical_Styles.StyleID
WHERE StyleName = "Contemporary"
UNION
SELECT Entertainers.EntertainerID, EntStageName
FROM Entertainers
INNER JOIN Entertainer_Styles ON Entertainers.EntertainerID = Entertainer_Styles.EntertainerID
INNER JOIN Musical_Styles ON Entertainer_Styles.StyleID = Musical_Styles.StyleID
WHERE StyleName = "Contemporary";

-- Question 25
SELECT Agents.AgentID AS ID, AgtFirstName AS Name
FROM Agents
UNION
SELECT Entertainers.EntertainerID, EntStageName
FROM Entertainers;


-- SECTION 3: ACCOUNTS PAYABLE

-- Question 1
SELECT * FROM invoices;

-- Question 2
SELECT invoice_number, invoice_date, invoice_total FROM invoices
ORDER BY invoice_total DESC;

-- Question 3
SELECT * FROM invoices WHERE invoice_date BETWEEN "2014-05-31" AND "2014-07-01";

-- Question 4
SELECT vendor_name, vendor_id, vendor_contact_first_name, vendor_contact_last_name FROM vendors 
ORDER BY vendor_contact_last_name ASC, vendor_contact_first_name ASC;

-- Question 5
SELECT vendor_contact_first_name, vendor_contact_last_name FROM vendors
WHERE vendor_contact_last_name LIKE "A%" or vendor_contact_last_name LIKE "B%" OR vendor_contact_last_name LIKE "C%" OR vendor_contact_last_name LIKE "D%"
ORDER BY vendor_contact_last_name ASC, vendor_contact_first_name ASC;

-- Question 6
SELECT invoices.invoice_due_date, (invoices.invoice_total*1.1), (invoices.payment_total*1.1)
FROM invoices
WHERE invoices.invoice_total BETWEEN 500 AND 1000
ORDER BY invoices.invoice_due_date DESC;

-- Question 7
SELECT invoice_number, invoice_total, credit_total, payment_total, (invoice_total-credit_total-payment_total) AS balance_due
FROM invoices
WHERE (invoice_total-credit_total-payment_total) > 50
ORDER BY (invoice_total-credit_total-payment_total) DESC
LIMIT 5;

-- Question 8
SELECT * FROM invoices
WHERE (invoice_total-credit_total-payment_total) > 0;

-- Question 9
SELECT vendor_name FROM vendors
INNER JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE (invoice_total-credit_total-payment_total) > 0;

-- Question 10
SELECT vendors.vendor_id, vendors.vendor_name, general_ledger_accounts.account_description
FROM vendors, general_ledger_accounts
WHERE vendors.default_account_number = general_ledger_accounts.account_number;

-- Question 11
SELECT vendors.vendor_name, invoices.* FROM vendors
LEFT JOIN invoices ON invoices.vendor_id = vendors.vendor_id
WHERE invoice_number IS NOT NULL
ORDER BY vendor_name;

-- Question 12
SELECT A.vendor_name
FROM vendors A, vendors B
WHERE A.vendor_contact_last_name = B.vendor_contact_last_name
AND A.vendor_id <> B.vendor_id;

-- Question 13
SELECT * FROM general_ledger_accounts
LEFT JOIN vendors ON general_ledger_accounts.account_number = vendors.default_account_number
LEFT JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE vendors.vendor_id IS NULL
ORDER BY account_number;


-- Question 14
SELECT vendor_name, vendor_state, IF(vendor_state = "CA","CA","Outside CA") 
FROM vendors;