CREATE DATABASE dbms_lab4;

USE dbms_lab4;


--1)	You are required to create tables for supplier,customer,category,product,productDetails,order,rating to store the data for the E-commerce with the schema definition given below.
CREATE TABLE supplier (
    supp_id INT NOT NULL AUTO_INCREMENT,
    supp_name VARCHAR(100) NOT NULL,
    supp_city VARCHAR(100) NOT NULL,
    supp_phone VARCHAR(10) NOT NULL,
    PRIMARY KEY (supp_id)
);


CREATE TABLE customer (
    cus_id INT NOT NULL AUTO_INCREMENT,
    cus_name VARCHAR(100) NOT NULL,
    cus_phone VARCHAR(10) NOT NULL,
    cus_city VARCHAR(50) NOT NULL,
    cus_gender VARCHAR(1) NOT NULL,
    PRIMARY KEY (cus_id)
);


CREATE TABLE category (
    cat_id INT NOT NULL AUTO_INCREMENT,
    cat_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (cat_id)
);


CREATE TABLE product (
    pro_id INT NOT NULL AUTO_INCREMENT,
    pro_name VARCHAR(100) NOT NULL,
    pro_desc VARCHAR(2000) NOT NULL,
    cat_id INT NOT NULL,
    PRIMARY KEY (pro_id),
    FOREIGN KEY (cat_id)
        REFERENCES category (cat_id)
        ON DELETE CASCADE
);

CREATE TABLE product_details (
    prod_id INT NOT NULL AUTO_INCREMENT,
    pro_id INT NOT NULL,
    supp_id INT NOT NULL,
    price VARCHAR(10) NOT NULL,
    PRIMARY KEY (prod_id),
    FOREIGN KEY (pro_id)
        REFERENCES product (pro_id)
        ON DELETE CASCADE,
    FOREIGN KEY (supp_id)
        REFERENCES supplier (supp_id)
        ON DELETE CASCADE
);


CREATE TABLE `order` (
    ord_id INT NOT NULL AUTO_INCREMENT,
    ord_amount INT NOT NULL,
    ord_date DATE NOT NULL,
    cus_id INT NOT NULL,
    pro_id INT NOT NULL,
    PRIMARY KEY (ord_id),
    FOREIGN KEY (cus_id)
        REFERENCES customer (cus_id)
        ON DELETE CASCADE,
    FOREIGN KEY (pro_id)
        REFERENCES product (pro_id)
        ON DELETE CASCADE
);


CREATE TABLE rating (
    rat_id INT NOT NULL AUTO_INCREMENT,
    cus_id INT NOT NULL,
    supp_id INT NOT NULL,
    rat_ratstars INT NOT NULL,
    PRIMARY KEY (rat_id),
    FOREIGN KEY (cus_id)
        REFERENCES customer (cus_id)
        ON DELETE CASCADE,
    FOREIGN KEY (supp_id)
        REFERENCES supplier (supp_id)
        ON DELETE CASCADE
);


--2)	Insert the following data in the table created above

INSERT INTO supplier
	(supp_id,supp_name,supp_city,supp_phone)
VALUES
	(1,'Rajesh Retails','Delhi',1234567890),
	(2,'Appario Ltd.','Mumbai',2589631470),
	(3,'Knome products','Banglore',9785462315),
	(4,'Bansal Retails','Kochi',8975463285),
	(5,'Mittal Ltd.','Lucknow',7898456532);

INSERT INTO customer
	(cus_id,cus_name,cus_phone,cus_city,cus_gender)
VALUES
	(1,'AAKASH',9999999999,'DELHI','M'),
	(2,'AMAN',9785463215,'NOIDA','M'),
	(3,'NEHA',9999999999,'MUMBAI','F'),
	(4,'MEGHA',9994562399,'KOLKATA','F'),
	(5,'PULKIT',7895999999,'LUCKNOW','M');

INSERT INTO category
	(cat_id,cat_name)
VALUES
	(1,'BOOKS'),
	(2,'GAMES'),
	(3,'GROCERIES'),
	(4,'ELECTRONICS'),
	(5,'CLOTHES');
	
INSERT INTO product
	(pro_id,pro_name,pro_desc,cat_id)
VALUES
	(1,'GTA V','DFJDJFDJFDJFDJFJF',2),
	(2,'TSHIRT','DFDFJDFJDKFD',5),
	(3,'ROG LAPTOP','DFNTTNTNTERND',4),
	(4,'OATS','REURENTBTOTH',3),
	(5,'HARRY POTTER','NBEMCTHTJTH',1);


INSERT INTO product_details
	(prod_id,pro_id,supp_id,price)
VALUES
	(1,1,2,1500),
	(2,3,5,30000),
	(3,5,1,3000),
	(4,2,3,2500),
	(5,4,1,1000);

INSERT INTO `order`
	(ord_id,ord_amount,ord_date,cus_id,pro_id)
VALUES
	(20,1500,'2021-10-12',3,5),
	(25,30500,'2021-09-16',5,2),
	(26,2000,'2021-10-05',1,1),
	(30,3500,'2021-08-16',4,3),
	(50,2000,'2021-10-06',2,1);


INSERT INTO rating
	(rat_id,cus_id,supp_id,rat_ratstars)
VALUES
	(1,2,2,4),
	(2,3,4,3),
	(3,5,1,5),
	(4,1,3,2),
	(5,4,5,4);



--3)	Display the number of the customer group by their genders who have placed any order of amount greater than or equal to Rs.3000.
SELECT 
    COUNT(1) tot_cus, cus_gender gender
FROM
    `order` o
        INNER JOIN
    customer c ON o.cus_id = c.cus_id
WHERE
    o.ord_amount >= 3000
GROUP BY cus_gender;


--4)	Display all the orders along with the product name ordered by a customer having Customer_Id=2.
SELECT 
    o.ord_id, o.ord_amount, p.pro_id, p.pro_name, c.cus_name
FROM
    customer c,
    `order` o,
    product p
WHERE
    c.cus_id = o.cus_id
        AND o.pro_id = p.pro_id
        AND c.cus_id = 2;
		

--5)	Display the Supplier details who can supply more than one product.
SELECT 
    s.*, COUNT(p.supp_id) AS count
FROM
    supplier s,
    product_details p
WHERE
    s.SUPP_ID = p.SUPP_ID
GROUP BY supp_id
HAVING count > 1;


--6)	Find the category of the product whose order amount is minimum.
SELECT 
    p.cat_id, c.cat_name
FROM
    product p,
    `order` o,
    category c
WHERE
    ord_amount = (SELECT 
            MIN(ord_amount)
        FROM
            `order`)
        AND p.pro_id = o.pro_id
        AND c.cat_id = p.cat_id;
		

--7)	Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT 
    p.pro_id, p.pro_name, o.ord_date
FROM
    `order` o,
    product p
WHERE
    o.pro_id = p.pro_id
        AND ord_date > '2021-10-05';
		
 
 --8)	Display customer name and gender whose names start or end with character 'A'.
SELECT 
    cus_name, cus_gender
FROM
    customer
WHERE
    cus_name LIKE '%A' OR cus_name LIKE 'A%';



--9)	Create a stored procedure to display the Rating for a Supplier if any along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
DROP PROCEDURE IF EXISTS displayFun;

DELIMITER //
CREATE PROCEDURE displayFun(id int)
BEGIN
	SELECT s.supp_id,r.rat_ratstars,
    CASE
		WHEN r.rat_ratstars > 4 THEN "Genuine Supplier"
        WHEN r.rat_ratstars > 2 THEN "Average Supplier"
        ELSE "Supplier should not be considered"
	END AS verdict
    FROM supplier s, rating r
    WHERE s.supp_id=r.supp_id AND s.supp_id=4;
END;


CALL displayFun(4);


