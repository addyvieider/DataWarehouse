DROP TABLE IF EXISTS warehouse.location;

CREATE TABLE IF NOT EXISTS warehouse.location(
  	id SERIAL PRIMARY KEY NOT NULL,
  	city VARCHAR(100) NULL,
  	district VARCHAR(100) NULL,
	province VARCHAR(100) NULL,
	region VARCHAR(100) NULL,
	country VARCHAR(100) NOT NULL
);