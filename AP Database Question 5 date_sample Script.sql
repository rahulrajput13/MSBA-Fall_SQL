USE accountspayable;
CREATE TABLE date_sample (
	date_id INT NOT NULL,
    start_date DATETIME);
INSERT INTO date_sample VALUES 
(1, '1986-03-01 00:00:00'),
(2, '2006-02-28 00:00:00'),
(3, '2010-10-31 00:00:00'),
(4, '2018-02-28 10:00:00'),
(5, '2019-02-28 13:58:32'),
(6, '2019-03-01 09:02:25');

SELECT * FROM date_sample;

SELECT start_date, 
    DATE_FORMAT(start_date, '%b/%d/%y') AS format1, 
    DATE_FORMAT(start_date, '%c/%e/%y') AS format2, 
    DATE_FORMAT(start_date, '%l:%i %p') AS twelve_hour,
    DATE_FORMAT(start_date, '%c/%e/%y %l:%i %p') AS format3 
FROM date_sample;