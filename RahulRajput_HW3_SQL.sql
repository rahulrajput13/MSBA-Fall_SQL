-- HOMEWORK 2 FOR RAHUL RAJPUT
-- Section 1: ENTERTAINMENT AGENCY

-- Question 1
SELECT Customers.CustomerID, CONCAT(CustFirstName, ' ', CustLastName) AS CustName, StyleName AS PreferredStyle, COUNT(StyleName) OVER NumStyles
FROM Customers LEFT JOIN Musical_Preferences ON Customers.CustomerID = Musical_Preferences.CustomerID
INNER JOIN Musical_Styles ON Musical_Preferences.StyleID = Musical_Styles.StyleID;