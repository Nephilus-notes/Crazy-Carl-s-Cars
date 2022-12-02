CREATE TABLE customer (
	customer_id serial PRIMARY KEY,
	customer_first_name varchar(45) NOT NULL,
	customer_last_name varchar(45) NOT NULL,
	customer_address varchar(255),
	customer_billing_info varchar(255),
	customer_phone_number varchar(45),
	customer_email varchar(255)
);


CREATE TABLE sales_rep (
	rep_id serial PRIMARY KEY,
	rep_first_name varchar(45) NOT NULL,
	rep_last_name varchar(45) NOT NULL,
	rep_address varchar(255) NOT NULL,
	rep_phone_number varchar(45) NOT NULL,
	rep_email varchar(255) NOT NULL,
	rep_pay_scale float
);

CREATE TABLE mechanic ( 
	mechanic_id serial PRIMARY KEY,
	mechanic_first_name varchar(45) NOT NULL,
	mechanic_last_name varchar(100) NOT NULL,
	mechanic_address varchar(255) NOT NULL,
	mechanic_phone_number varchar(45) NOT NULL,
	mechanic_email varchar(255) NOT NULL,
	mechanic_payscale float
);

ALTER TABLE mechanic 
 RENAME column mechanic_first_name TO first_name;
ALTER TABLE mechanic 
 RENAME column mechanic_last_name TO last_name;
ALTER TABLE mechanic 
 RENAME column mechanic_address TO address;
ALTER TABLE mechanic 
 RENAME column mechanic_phone_number TO phone_number;
ALTER TABLE mechanic 
 RENAME column mechanic_email TO email;
ALTER TABLE mechanic 
 RENAME column mechanic_payscale TO payscale;

ALTER TABLE sales_rep  
 RENAME column rep_first_name TO first_name;
ALTER TABLE sales_rep 
 RENAME column rep_last_name TO last_name;
ALTER TABLE sales_rep 
 RENAME column rep_address TO address;
ALTER TABLE sales_rep 
 RENAME column rep_phone_number TO phone_number;
ALTER TABLE sales_rep 
 RENAME column rep_email TO email;
ALTER TABLE sales_rep 
 RENAME column rep_pay_scale TO payscale;


CREATE TABLE car (
	serial_number serial PRIMARY KEY,
	rep_id integer REFERENCES sales_rep(rep_id),
	customer_id integer REFERENCES customer(customer_id) NOT null,
	"year" integer NOT NULL,
	make varchar(45) NOT NULL,
	model varchar(45) NOT NULL,
	color varchar(45) NOT null
);

CREATE TABLE service_ticket ( 
	ticket_id serial PRIMARY KEY,
	serial_number integer REFERENCES car(serial_number) NOT NULL,
	service_description varchar(1000) NOT NULL,
	car_mileage integer NOT NULL,
	date_submitted timestamp NOT null
);

CREATE TABLE ticket_deployment ( 
	deployment_id serial PRIMARY KEY,
	ticket_id integer REFERENCES service_ticket(ticket_id) NOT null,
	mechanic_id integer REFERENCES mechanic(mechanic_id) NOT null,
	service_date timestamp NOT NULL 
);

CREATE TABLE invoice (
	invoice_id serial PRIMARY KEY,
	customer_id integer REFERENCES customer(customer_id) NOT NULL,
	serial_number integer REFERENCES car(serial_number) NOT NULL,
	amount float NOT NULL,
	"date" timestamp NOT NULL,
	rep_id integer REFERENCES sales_rep(rep_id),
	ticket_id integer REFERENCES service_ticket(ticket_id)
);

