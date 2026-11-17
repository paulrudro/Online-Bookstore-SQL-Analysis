--CREATING BOOKS TABLE:

CREATE TABLE BOOKS (
	BOOK_ID SERIAL PRIMARY KEY,
	TITLE VARCHAR(100),
	AUTHOR VARCHAR(100),
	GENRE VARCHAR(100),
	PUBLISHED_YEAR INT,
	PRICE NUMERIC(10, 2),
	STOCK INT
);



--CREATING CUSTOMERS TABLE:

CREATE TABLE CUSTOMERS (
	CUSTOMER_ID SERIAL PRIMARY KEY,
	NAME VARCHAR(50),
	EMAIL VARCHAR(50),
	PHONE VARCHAR(15),
	CITY VARCHAR(50),
	COUNTRY VARCHAR(100)
);



--CREATING CUSTOMERS ORDERS:

CREATE TABLE ORDERS (
	ORDER_ID SERIAL PRIMARY KEY,
	CUSTOMER_ID SERIAL REFERENCES CUSTOMERS (CUSTOMER_ID),
	BOOK_ID SERIAL REFERENCES BOOKS (BOOK_ID),
	ORDER_DATE DATE,
	QUANTITY INT,
	TOTAL_AMOUNT NUMERIC(10, 2)
);



--importing books csv:

COPY BOOKS (
	BOOK_ID,
	TITLE,
	AUTHOR,
	GENRE,
	PUBLISHED_YEAR,
	PRICE,
	STOCK
)
FROM
	'C:\Users\Public\Books.csv' DELIMITER ',' CSV HEADER;



--importing CUSTOMERS csv:

COPY CUSTOMERS (CUSTOMER_ID, NAME, EMAIL, PHONE, CITY, COUNTRY)
FROM
	'C:\Users\Public\Customers.csv' DELIMITER ',' CSV HEADER;



--importing ORDERS csv:

COPY ORDERS (
	ORDER_ID,
	CUSTOMER_ID,
	BOOK_ID,
	ORDER_DATE,
	QUANTITY,
	TOTAL_AMOUNT
)
FROM
	'C:\Users\Public\Orders.csv' DELIMITER ',' CSV HEADER;



--retrieve all books in the 'fiction' genre:

SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fiction';



--find books published after the year 1950:

SELECT
	*
FROM
	BOOKS
WHERE
	PUBLISHED_YEAR > 1950;



--list all customers from the canada:

SELECT
	*
FROM
	CUSTOMERS
WHERE
	COUNTRY = 'Canada';


--show order placed in november 2023:

SELECT
	*
FROM
	ORDERS
WHERE
	ORDER_DATE BETWEEN '2023-11-01' AND '2023-11-30';



--retrieve the total stock of books available:

SELECT
	SUM(STOCK) AS TOTAL_STOCKS_OF_BOOKS
FROM
	BOOKS;



--find the details of the most expensive books:

SELECT
	*
FROM
	BOOKS
ORDER BY
	PRICE DESC
LIMIT
	1;



--show all customers who order more than 1 quantity book:

SELECT
	C.*,
	O.QUANTITY AS QUANTITY_OF_BOOKS_PURCHASED
FROM
	CUSTOMERS C
	INNER JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
	AND O.QUANTITY > 1
ORDER BY
	O.QUANTITY DESC;



--retrieve all the orders where the total exceeds $20:

SELECT
	*
FROM
	ORDERS
WHERE
	TOTAL_AMOUNT > 20;



--list all genre available on the books table

SELECT DISTINCT
	(GENRE) AS ALL_UNIQUE_GENRE
FROM
	BOOKS;



--find the books with the lowest stock

SELECT
	*
FROM
	BOOKS
ORDER BY
	STOCK ASC
LIMIT
	1;



--calculate the total revenue generated from all orders:

SELECT
	SUM(TOTAL_AMOUNT) AS TOTAL_REVENUE_GENERATED
FROM
	ORDERS;



--retrive the total number of books sold for each genre:

SELECT
	B.GENRE,
	SUM(O.QUANTITY) AS TOTAL_QUANTITY_BY_GENRE
FROM
	ORDERS O
	JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY
	GENRE;



--find the average price of books in the fantasy genre:

SELECT
	AVG(PRICE) AS AVG_PRICE
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy';



--list customer who have atleast 2 orders:

SELECT
	C.NAME,
	C.PHONE,
	O.QUANTITY
FROM
	CUSTOMERS C
	JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
	AND O.QUANTITY >= 2
ORDER BY
	QUANTITY DESC;
	


--list customer who have atleast 2 orders:

SELECT
	O.CUSTOMER_ID,
	C.NAME,
	COUNT(O.ORDER_ID) AS TOTAL_ORDERS
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	O.CUSTOMER_ID,
	C.NAME
HAVING
	COUNT(O.ORDER_ID) >= 2
ORDER BY
	TOTAL_ORDERS DESC;



--find the most frequently ordered book:

SELECT
	O.BOOK_ID,
	B.TITLE,
	COUNT(O.ORDER_ID) AS TOTAL_BOOKS_SOLD
FROM
	ORDERS O
	JOIN BOOKS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY
	B.TITLE,
	O.BOOK_ID
ORDER BY
	TOTAL_BOOKS_SOLD DESC
LIMIT
	1;



--show the top 3 most expensive book of 'fantasy' genre:

SELECT
	*
FROM
	BOOKS
WHERE
	GENRE = 'Fantasy'
ORDER BY
	PRICE DESC
LIMIT
	3;



--retrieve the total quantity of books sold by each auther:

SELECT
	B.AUTHOR,
	SUM(O.QUANTITY) AS TOTAL_QUANTITY_OF_BOOKS_SOLD
FROM
	ORDERS O
	JOIN BOOKS B ON B.BOOK_ID = O.BOOK_ID
GROUP BY
	B.AUTHOR
ORDER BY
	TOTAL_QUANTITY_OF_BOOKS_SOLD DESC;


--list the cities where customers who spent over $30 are located:

SELECT
	C.CITY,
	SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	C.CITY
HAVING
	SUM(TOTAL_AMOUNT) > 30
ORDER BY
	TOTAL_SPENT DESC;



--find the customer who spent the most on orders:

SELECT
	C.NAME,
	SUM(O.TOTAL_AMOUNT) AS TOTAL_SPENT
FROM
	ORDERS O
	JOIN CUSTOMERS C ON O.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY
	C.NAME
ORDER BY
	TOTAL_SPENT DESC
LIMIT
	1;


	
--calculate the stock remaining after fullfilling all orders:

SELECT
	B.BOOK_ID,
	B.TITLE,
	B.STOCK,
	COALESCE(SUM(O.QUANTITY), 0) AS TOTAL_SOLD,
	B.STOCK - COALESCE(SUM(O.QUANTITY), 0) AS REMAINING_STOCK
FROM
	BOOKS B
	LEFT JOIN ORDERS O ON O.BOOK_ID = B.BOOK_ID
GROUP BY
	B.BOOK_ID,
	B.TITLE
ORDER BY
	B.BOOK_ID ASC;



SELECT * FROM BOOKS;

SELECT * FROM CUSTOMERS;

SELECT * FROM ORDERS;