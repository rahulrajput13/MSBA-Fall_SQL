SELECT ReservationID, Reservation.TripID, Reservation.TripDate
FROM Reservation
INNER JOIN Trip ON Reservation.TripID = Trip.TripID
WHERE State = "ME";

SELECT ReservationID, TripID, TripDate
FROM Reservation
WHERE TripID IN (SELECT TripID FROM TRIP WHERE State = "ME");

SELECT ReservationID, TripDate, Reservation.TripID
FROM (SELECT State, TripID FROM Trip WHERE State="ME") AS A 
INNER JOIN Reservation ON A.TripID = Reservation.TripID;

SELECT TripID, TripName
FROM Trip
WHERE MaxGrpSize > (SELECT MAX(MaxGrpSize) FROM Trip WHERE Type = "Hiking");

SELECT TripID, TripName
FROM Trip
WHERE MaxGrpSize > (SELECT MIN(MaxGrpSize) FROM Trip WHERE Type = "Biking");

SELECT EntertainerID
FROM Engagements INNER JOIN 
(SELECT CustomerID FROM Customers WHERE CustLastName = "Berg" or CustLastName = "Hallmark") AS A
ON A.CustomerID = Engagements.CustomerID;

SELECT EntertainerID
FROM Engagements 
WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE CustLastName = "Berg" or CustLastName = "Hallmark");

SELECT EntertainerID FROM Engagements WHERE CustomerID = 10005 OR CustomerID = 10006;

SELECT AVG(Salary) FROM Agents;

SELECT Engagements.EngagementNumber
FROM Engagements
WHERE Engagements.ContractPrice >= (SELECT AVG(Engagements.ContractPrice) FROM Engagements);

SELECT COUNT(EntertainerID)
FROM Entertainers
WHERE Entertainers.EntCity = "Bellevue";

SELECT Engagements.EngagementNumber
FROM Engagements
WHERE StartDate > "2017-09-30" AND StartDate < "2017-10-10";

SELECT EntertainerID, COUNT(EngagementNumber)
FROM Engagements
GROUP BY EntertainerID;

SELECT DISTINCT CustomerID 
FROM Engagements WHERE EntertainerID IN (SELECT EntertainerID FROM Entertainer_Styles WHERE StyleID IN (SELECT StyleID FROM Musical_Styles WHERE StyleName = "Country" OR StyleName = "Country Rock"));

SELECT DISTINCT CustomerID
FROM Engagements INNER JOIN Entertainer_Styles ON Engagements.EntertainerID = Entertainer_Styles.EntertainerID
INNER JOIN Musical_Styles ON Entertainer_Styles.StyleID = Musical_Styles.StyleID
WHERE Musical_Styles.StyleName = "Country" OR Musical_Styles.StyleName = "Country Rock";

SELECT EntertainerID
FROM Engagements WHERE CustomerID IN (SELECT CustomerID FROM Customers WHERE CustLastName = "Berg" OR CustLastName = "Hallmark");

SELECT EntertainerID
FROM Engagements INNER JOIN Customers ON Engagements.CustomerID = Customers.CustomerID
WHERE Customers.CustLastName = "Berg" OR CustLastName = "Hallmark";

SELECT AgentID 
FROM Agents 
WHERE AgentID NOT IN (SELECT DISTINCT(AgentID) FROM Engagements);

SELECT Agents.AgentID
FROM Agents LEFT JOIN Engagements ON Agents.AgentID = Engagements.AgentID
LEFT JOIN Entertainers ON Engagements.EntertainerID = Entertainers.EntertainerID
WHERE Entertainers.EntertainerID IS NULL;

SELECT CustomerID, MAX(StartDate)
FROM Engagements
GROUP BY CustomerID;

SELECT Entertainers.EntertainerID
FROM Entertainers LEFT JOIN Engagements ON Entertainers.EntertainerID = Engagements.EntertainerID
LEFT JOIN Customers ON Engagements.CustomerID = Customers.CustomerID
WHERE CustLastName = "Berg" OR CustLastName = "Hallmark";

SELECT Engagements.EngagementNumber, ContractPrice
FROM Engagements
WHERE ContractPrice > (SELECT SUM(ContractPrice) FROM Engagements WHERE StartDate > "2017-10-31" OR EndDate < "2017-12-01");

SELECT SUM(ContractPrice) 
FROM Engagements 
WHERE StartDate > "2017-09-30" OR StartDate < "2017-11-01";

SELECT CustLastName, CustFirstName
FROM Customers
LEFT JOIN Engagements ON Customers.CustomerID = Engagements.CustomerID
WHERE Engagements.EntertainerID IS NULL; 

SELECT CustFirstName, CustLastName
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT(CustomerID) FROM Engagements);

SELECT CustFirstName, CustLastName
FROM Customers LEFT JOIN
(SELECT CustomerID, EngagementNumber FROM Engagements) AS A
ON Customers.CustomerID = A.CustomerID
WHERE A.EngagementNumber is NULL;
