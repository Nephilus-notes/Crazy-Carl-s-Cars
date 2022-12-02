-- Customer Insert

CREATE OR REPLACE PROCEDURE  insertCustomer(_first_name varchar, _last_name varchar,
_address varchar default Null, _billing_info varchar default Null,
_phone_number varchar default Null, _email varchar default Null)
LANGUAGE plpgsql AS $$
BEGIN 
	INSERT INTO customer(first_name, last_name, address, billing_info, phone_number, email)
VALUES 
	(_first_name, _last_name, _address, _billing_info, _phone_number, _email);
END;
$$

CALL insertCustomer('Barry', 'White', '940 Soul St.');
CALL insertCustomer('Jerry', 'Mosby', '940 Dosatrepla blvd', '23424', '132-414-4145', 'mosby@architect.com');
CALL insertCustomer('Sam', 'Iam', '1314 Seuss St.');


-- Mechanic and Sales_rep insert

CREATE OR REPLACE PROCEDURE  insertEmployee(table_name varchar, 
	first_name varchar, last_name varchar, address varchar, 
	phone_number varchar, email varchar, payscale float DEFAULT Null)
LANGUAGE plpgsql AS $$
BEGIN 
	EXECUTE 'insert into ' || table_name || 
	' (first_name, last_name, address, phone_number, email, payscale) VALUES (''' || first_name || ''', '''
	|| last_name || ''', ''' || address || ''', '''
	|| phone_number || ''', ''' || email || ''', '''
	|| payscale || ''');';
END;
$$

--DROP PROCEDURE insertcustomer

CALL insertEmployee('sales_rep', 'John', 'Darmanitan', '123 Trouble Lane', '123-dont-call-me', '123@crazycarl.com', 14.90);
CALL insertEmployee('sales_rep', 'Barb', 'Ara', '123 Strange Lane', '123-dont-call-me', 'BA@crazycarl.com', 17.90);
CALL insertEmployee('sales_rep', 'Brock', 'Prog', '123 Pewter Lane', '123-dont-call-me', 'Onix@crazycarl.com', 12.90);

CALL insertEmployee('mechanic', 'Bud', 'Notbuddy', '123 Dustbowl Ave', '12341451', 'bdb@crazycarl.com', 19.75);


CALL insertEmployee('mechanic', 'John', 'Neuworth', '527 Dustbowl Ave', '12341251', 'JN@crazycarl.com', 15.75);
CALL insertEmployee('mechanic', 'Mike', 'Helful', '3553 Jeremy St', '123-424-1451', 'mikehel@crazycarl.com', 21.75);

-- Car insert

CREATE OR REPLACE PROCEDURE  insertCar(_customer_id integer, _year integer, _make varchar, _model varchar,
_color varchar, _rep_id integer DEFAULT Null)
LANGUAGE plpgsql AS $$
BEGIN 
	INSERT INTO car(rep_id, customer_id, "year", make, model, color)
VALUES 
	(_rep_id, _customer_id, _year, _make, _model, _color);
END;
$$

DROP PROCEDURE insertCar

CALL insertCar(1,1998,'Toyota', 'Camry', 'Grey', 1);
CALL insertCar(2,2019,'Tesla', 'Model S', 'Black');

INSERT INTO car (customer_id, "year", make, model, color, rep_id)
VALUES 
(1, 2003, 'Toyota', 'Camry', 'Blue', 2),
(1, 2007, 'Toyota', 'Camry', 'Silver', Null),
(2, 2003, 'Toyota', 'Camry', 'Black', 1),
(3, 2003, 'Toyota', 'Camry', 'Red', Null);


-- Service_ticket insert

INSERT INTO service_ticket (serial_number, service_description,
car_mileage, date_submitted)
VALUES 
	(3, 'Fixed breaks and rotated tires', 10000, timestamp '2022-11-08 16:05:06'),
	(5, 'Carwash', 1500, timestamp '2022-11-22 16:05:06'),
	(7, 'Carwash', 15600, timestamp '2022-11-22 17:05:06');

INSERT INTO service_ticket (serial_number, service_description,
car_mileage, date_submitted)
VALUES 
	(3, 'Changed oil, tested breaks.', 9000, '2022-10-08 10:05:06'),
	(3, 'Changed oil, fixed windshield wipers.', 8000, '2022-08-08 10:05:06');

INSERT INTO service_ticket (serial_number, service_description,
car_mileage, date_submitted)
VALUES 
		(3, 'Changed oil.', 7000, '2022-6-08 10:05:06');

-- ticket_deployment insert 
INSERT INTO ticket_deployment (ticket_id, mechanic_id, service_date)
VALUES 
	(1, 1, timestamp '2022-11-08 16:55:06'),
	(1, 2, timestamp '2022-11-08 16:59:06'),
	(1, 3, timestamp '2022-11-08 17:05:06'),
	(2, 1, timestamp '2022-11-22 16:10:06'),
	(3, 1, timestamp '2022-11-22 17:08:06');

-- invoice INSERT 
INSERT INTO invoice (customer_id, serial_number, amount,
"date", rep_id, ticket_id)
VALUES 
	(1,1, 16000, timestamp '2022-11-08 16:59:06', 1, Null),
	(2,3, 30, timestamp '2022-11-08 16:59:06', Null, 1),
	(1,4, 17080, timestamp '2022-11-08 16:59:06', 2, Null),
	(1,5, 16000, timestamp '2022-11-08 16:59:06', Null, 2),
	(2,6, 16000, timestamp '2022-11-08 16:59:06', 1, Null),
	(1,7, 16000, timestamp '2022-11-08 16:59:06', Null, 3);	

INSERT INTO invoice (customer_id, serial_number, amount,
"date", rep_id, ticket_id)
VALUES 
	(2,3, 70.14, timestamp '2022-10-08 10:50:06.000', NULL, 4),
	(2,3, 142.12, timestamp '2022-08-08 15:05:46.000', NULL, 5);

INSERT INTO invoice (customer_id, serial_number, amount,
"date", rep_id, ticket_id)
VALUES 
	(2,3, 40.12, timestamp '2022-06-08 15:05:46.000', NULL, 6);

-- Bonus Function

CREATE OR REPLACE FUNCTION Staff_earning(id_num integer)
RETURNS float
LANGUAGE plpgsql AS  $$
BEGIN 
	RETURN (SELECT sum(amount)
	FROM invoice
	WHERE rep_id = id_num);
END;
$$

SELECT staff_earning(2)
--
--SELECT rep_id, sum(amount)
--FROM invoice
--WHERE rep_id IS NOT NULL 
--GROUP BY rep_id 

CREATE OR REPLACE FUNCTION serviceHistory(car_serial integer)
RETURNS TABLE (
	"date" timestamp WITHOUT time zone,
	service_description varchar,
	car_mileage integer,
	amount MONEY
)
LANGUAGE plpgsql AS  $$
BEGIN 
	RETURN Query (SELECT invoice."date", service_ticket.service_description, service_ticket.car_mileage, invoice.amount::NUMERIC::MONEY
		FROM service_ticket 
		JOIN invoice 
		ON service_ticket.ticket_id = invoice.ticket_id 
		WHERE service_ticket.serial_number  = car_serial);
END;
$$


-- Select from the query to get a complete table returned in dbeaver
SELECT * 
FROM serviceHistory(3)

CREATE MATERIALIZED VIEW service_history_serial_number_3 AS
SELECT *
FROM serviceHistory(3)


REFRESH MATERIALIZED VIEW service_history_serial_number_3 