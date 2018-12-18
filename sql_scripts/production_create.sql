DROP TABLE IF EXISTS warehouse.production;

DROP TABLE IF EXISTS warehouse.operator;
DROP TABLE IF EXISTS warehouse.quality_control;
DROP TABLE IF EXISTS warehouse.machine;
DROP TABLE IF EXISTS warehouse.production_stage;
DROP TABLE IF EXISTS warehouse.product;

CREATE TABLE IF NOT EXISTS warehouse.operator(
  	operator_id SERIAL PRIMARY KEY NOT NULL,
  	operator_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.quality_control(
  	quality_control_id SERIAL PRIMARY KEY NOT NULL,
  	quality_control_grade int NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.machine(
  	machine_id SERIAL PRIMARY KEY NOT NULL,
  	machine_name VARCHAR(100) NOT NULL,
  	machine_vendor VARCHAR(100) NOT NULL,
  	machine_purchasing_year int NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.production_stage(
  	production_stage_id SERIAL PRIMARY KEY NOT NULL,
  	production_stage_name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS warehouse.product(
  	product_id SERIAL PRIMARY KEY NOT NULL,
  	product_name VARCHAR(100) NOT NULL,
  	product_number int NOT NULL,
  	product_department VARCHAR(100) NOT NULL,
  	product_category VARCHAR(100) NOT NULL,
);

CREATE TABLE IF NOT EXISTS warehouse.production(
	production_id SERIAL PRIMARY KEY NOT NULL,
	operator_id int REFERENCES warehouse.operator(operator_id) NOT NULL,
	quality_control_id int REFERENCES warehouse.quality_control(quality_control_id),
	machine_id int REFERENCES warehouse.machine(machine_id) NOT NULL,
	production_stage_id int REFERENCES warehouse.production_stage(production_stage_id) NOT NULL,
	product_id int REFERENCES warehouse.product(product_id),
	start_date_id int REFERENCES warehouse.date(date_id) NOT NULL,
	end_date_id int REFERENCES warehouse.date(date_id) NOT NULL,

	duration int NOT NULL,
	raw_material_cost int NOT NULL
);