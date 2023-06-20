### MIDTERM FOR RAHUL RAJPUT

## DATABASE 1
# Answer 1
SELECT Check_Num, Book_Num, Pat_ID, Check_Out_Date, Check_Due_Date
FROM CHECKOUT
WHERE Check_In_Date IS NULL
ORDER BY Book_Num;

# Answer 2
SELECT COUNT(DISTINCT Book_Subject)
FROM BOOK;

# Answer 3
SELECT Book_Subject, COUNT(Book_Title)
FROM BOOK
GROUP BY Book_Subject
ORDER BY COUNT(Book_Title) DESC, Book_Subject ASC;

# Answer 4
SELECT AU_ID, COUNT(Book_Num)
FROM WRITES
GROUP BY AU_ID
ORDER BY COUNT(Book_Num) DESC, AU_ID ASC;

# Answer 5
SELECT BOOK.Book_Num, COUNT(Check_Num)
FROM BOOK INNER JOIN CHECKOUT ON BOOK.Book_Num = CHECKOUT.Book_Num
GROUP BY BOOK.Book_Num
ORDER BY COUNT(Check_Num) DESC, BOOK.Book_Num DESC;

# Answer 6
SELECT PATRON.Pat_ID, Pat_Lname, COUNT(CHECKOUT.Pat_ID) AS NCheckouts, COUNT(DISTINCT CHECKOUT.Book_Num) AS NDiffBooks
FROM PATRON LEFT JOIN CHECKOUT ON PATRON.Pat_ID = CHECKOUT.Pat_ID
GROUP BY PATRON.Pat_ID
HAVING NCheckouts > 2
ORDER BY NDiffBooks DESC, NCheckouts DESC, Pat_ID ASC;

# Answer 7
SELECT A.Pat_ID, A.AvgDays
FROM (SELECT Pat_ID, COUNT(Check_Num), AVG(Check_In_Date - Check_Out_Date) AS AvgDays FROM CHECKOUT GROUP BY Pat_ID HAVING COUNT(Check_Num)>2) AS A
ORDER BY A.AvgDays DESC;


## DATABASE 2

# Answer 1
SELECT invoice_number, invoice_date, invoice_total
FROM invoices INNER JOIN vendors ON invoices.vendor_id = vendors.vendor_id
WHERE vendor_state = "CA";

SELECT invoice_number, invoice_date, invoice_total
FROM invoices
WHERE vendor_id IN (SELECT vendor_id FROM vendors WHERE vendor_state = "CA");

# Answer 2
SELECT vendors.vendor_id, vendors.vendor_name, vendors.vendor_state
FROM vendors
WHERE vendors.vendor_id NOT IN (SELECT DISTINCT vendor_id FROM invoices);

SELECT vendors.vendor_id, vendors.vendor_name, vendors.vendor_state
FROM vendors LEFT JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_id IS NULL;

SELECT vendors.vendor_id, vendors.vendor_name, vendors.vendor_state
FROM (SELECT vendors.vendor_id FROM vendors WHERE vendors.vendor_id NOT IN (SELECT DISTINCT vendor_id FROM invoices)) AS A
INNER JOIN vendors ON A.vendor_id = vendors.vendor_id;

# Answer 3
SELECT vendor_name, invoice_number, invoice_total
FROM vendors INNER JOIN invoices ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_total > (SELECT MAX(invoice_total) FROM invoices WHERE vendor_id = 34);

SELECT vendors.vendor_name, invoice_number, invoice_total
FROM (SELECT vendor_id, invoice_number, invoice_total FROM invoices) AS A INNER JOIN vendors ON A.vendor_id = vendors.vendor_id
WHERE A.invoice_total > (SELECT MAX(invoice_total) FROM invoices WHERE vendor_id = 34);

# Answer 4
# Defining top vendor from each state who has the largest total value of orders respectively
SELECT invoices.vendor_id,MAX(invoice_total), vendor_state 
FROM invoices INNER JOIN vendors ON invoices.vendor_ID = vendors.vendor_ID
WHERE invoice_total IN (SELECT MAX(invoice_total)
FROM invoices INNER JOIN vendors ON invoices.vendor_id = vendors.vendor_id
GROUP BY vendors.vendor_state)
GROUP BY vendor_id
ORDER BY vendor_state;

# Answer 5
SELECT vendor_id, COUNT(DISTINCT account_number)
FROM invoices LEFT JOIN invoice_line_items ON invoices.invoice_id = invoice_line_items.invoice_id
GROUP BY vendor_id
HAVING COUNT(DISTINCT account_number) > 1;

# Answer 6
SELECT default_terms_id, vendors.vendor_id, payment_date, SUM(invoice_total-credit_total-payment_total)
FROM invoices INNER JOIN vendors ON invoices.vendor_id = vendors.vendor_id
GROUP BY default_terms_id;



