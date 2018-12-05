
DROP TABLE IF EXISTS warehouse.showroom_visit;

DROP TABLE IF EXISTS warehouse.showroom;
DROP TABLE IF EXISTS warehouse.visitor;
DROP TABLE IF EXISTS warehouse.sales_representative;
DROP TABLE IF EXISTS warehouse.date;
DROP TABLE IF EXISTS warehouse.department;
DROP TABLE IF EXISTS warehouse.order;
DROP TABLE IF EXISTS warehouse.visitor_type;

DROP INDEX IF EXISTS d_date_date_actual_idx;
DROP TABLE IF EXISTS warehouse.location;


CREATE TABLE IF NOT EXISTS warehouse.location(
  	location_id SERIAL PRIMARY KEY NOT NULL,
  	city VARCHAR(100) NULL,
  	district VARCHAR(100) NULL,
	province VARCHAR(100) NULL,
	region VARCHAR(100) NULL,
	country VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.date
(
  date_id              SERIAL PRIMARY KEY NOT NULL,
  date_actual              DATE NOT NULL,
  day_name                 VARCHAR(9) NOT NULL,
  day_of_week              INT NOT NULL,
  day_of_month             INT NOT NULL,
  day_of_quarter           INT NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  month_actual             INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL,
  quarter_actual           INT NOT NULL,
  quarter_name             VARCHAR(9) NOT NULL,
  year_actual              INT NOT NULL,
  mmyyyy                   CHAR(6) NOT NULL,
  mmddyyyy                 CHAR(10) NOT NULL,
  holiday				   BOOLEAN NOT NULL,
  holiday_name			   VARCHAR(50)
);

CREATE INDEX d_date_date_actual_idx ON warehouse.date(date_actual);

INSERT INTO warehouse.date
SELECT TO_CHAR(datum,'yyyymmdd')::INT AS date_id,
       datum AS date_actual,
       TO_CHAR(datum,'Day') AS day_name,
       EXTRACT(isodow FROM datum) AS day_of_week,
       EXTRACT(DAY FROM datum) AS day_of_month,
       datum - DATE_TRUNC('quarter',datum)::DATE +1 AS day_of_quarter,
       EXTRACT(doy FROM datum) AS day_of_year,
       TO_CHAR(datum,'W')::INT AS week_of_month,
       EXTRACT(week FROM datum) AS week_of_year,
       EXTRACT(MONTH FROM datum) AS month_actual,
       TO_CHAR(datum,'Month') AS month_name,
       EXTRACT(quarter FROM datum) AS quarter_actual,
       CASE
         WHEN EXTRACT(quarter FROM datum) = 1 THEN 'First'
         WHEN EXTRACT(quarter FROM datum) = 2 THEN 'Second'
         WHEN EXTRACT(quarter FROM datum) = 3 THEN 'Third'
         WHEN EXTRACT(quarter FROM datum) = 4 THEN 'Fourth'
       END AS quarter_name,
	   EXTRACT(year FROM datum) AS year_actual,
       TO_CHAR(datum,'mmyyyy') AS mmyyyy,
       TO_CHAR(datum,'mmddyyyy') AS mmddyyyy,
       FALSE,
       NULL
FROM (SELECT '2010-01-01'::DATE+ SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES (0,3286) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;	


CREATE TABLE IF NOT EXISTS warehouse.visitor(
	visitor_id SERIAL PRIMARY KEY NOT NULL,
	visitor_name VARCHAR(100),
	visitor_telephone VARCHAR(100),
	visitor_email VARCHAR(100),
	customer_number VARCHAR(100),
	visitor_sector VARCHAR(50),
	visitor_gender VARCHAR(10),
	visitor_language VARCHAR(50),
	location_id int REFERENCES warehouse.location(location_id)
);


CREATE TABLE IF NOT EXISTS warehouse.sales_representative(
	sales_rep_id SERIAL PRIMARY KEY NOT NULL,
	sales_rep_name VARCHAR(100) NOT NULL,
	sales_rep_telephone VARCHAR(100) NOT NULL,
	sales_rep_email VARCHAR(100) NOT NULL,
	sales_rep_gender VARCHAR(10) NOT NULL,
	sales_rep_language VARCHAR(50) NOT NULL,
	location_id int REFERENCES warehouse.location(location_id) NOT NULL
);


CREATE TABLE IF NOT EXISTS warehouse.showroom(
	showroom_id SERIAL PRIMARY KEY NOT NULL,
	showroom_name VARCHAR(100) NOT NULL,
	showroom_telephone VARCHAR(100) NOT NULL,
	showroom_address VARCHAR(100) NOT NULL,
	showroom_size int NOT NULL,
	showroom_manager VARCHAR(100) NOT NULL,
	location_id int REFERENCES warehouse.location(location_id) NOT NULL
);


CREATE TABLE IF NOT EXISTS warehouse.department(
	department_id SERIAL PRIMARY KEY NOT NULL,
	department_name VARCHAR(100) NOT NULL
);

INSERT INTO warehouse.department (department_name) VALUES
('Küche'), 
('Wohnzimmer'), 
('Schlafzimmer'),  
('Badezimmer'),
('Kinder'), 
('Hotel'), 
('Büro');


CREATE TABLE IF NOT EXISTS warehouse.order(
	order_id SERIAL PRIMARY KEY NOT NULL,
	order_number VARCHAR(100) NOT NULL,
	order_total_price numeric NOT NULL
);


CREATE TABLE IF NOT EXISTS warehouse.visitor_type(
	visitor_type_id SERIAL PRIMARY KEY NOT NULL,
	visitor_type_name VARCHAR(100) NOT NULL
);

INSERT INTO warehouse.visitor_type (visitor_type_name) VALUES
('Single'), 
('Pair'), 
('Family'),  
('Group');

CREATE TABLE IF NOT EXISTS warehouse.showroom_visit(
	showroom_visit_id SERIAL PRIMARY KEY NOT NULL,
	visitor_id int REFERENCES warehouse.visitor(visitor_id),
	sales_rep_id int REFERENCES warehouse.sales_representative(sales_rep_id) NOT NULL,
	showroom_id int REFERENCES warehouse.showroom(showroom_id) NOT NULL,
	department_id int REFERENCES warehouse.department(department_id) NOT NULL,
	date_id int REFERENCES warehouse.date(date_id) NOT NULL,
	order_id int REFERENCES warehouse.order(order_id),
	visitor_type_id int REFERENCES warehouse.visitor_type(visitor_type_id),

	duration int NOT NULL,
	number_of_visitors int NOT NULL
);