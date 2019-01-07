SELECT showroom_name, department_name, season, count(visitor_id)
	FROM warehouse.showroom_visit
	JOIN warehouse.showroom using (showroom_id)
	JOIN warehouse.department using (department_id)
	JOIN warehouse.date using (date_id)
	GROUP BY ROLLUP(showroom_name, department_name, season);
	
SELECT product_category, product_name, production_stage_name, ROUND(avg(duration)::numeric,2)
	FROM warehouse.production
	JOIN warehouse.product using (product_id)
	JOIN warehouse.production_stage using (production_stage_id)
	GROUP BY ROLLUP(product_category, product_name, production_stage_name);
	
SELECT visitor_sector, vl.district, sl.district, sum(number_of_visitors)
	FROM warehouse.showroom_visit
	JOIN warehouse.visitor using (visitor_id)
	JOIN warehouse.location as vl on warehouse.visitor.location_id = vl.location_id 
	JOIN warehouse.showroom using (showroom_id)
	JOIN warehouse.location as sl on warehouse.showroom.location_id = sl.location_id
	WHERE vl.province = 'Bozen'
	GROUP BY CUBE(vl.district, visitor_sector, sl.district)
	ORDER BY visitor_sector, vl.district, sl.district;
	
SELECT product_department, machine_name, ROUND(avg(quality_control_grade)::numeric,2)
	FROM warehouse.production
	JOIN warehouse.product using (product_id)
	JOIN warehouse.machine using (machine_id)
	JOIN warehouse.quality_control using (quality_control_id)
	WHERE quality_control_grade is not NULL
	GROUP BY CUBE(product_department, machine_name)
	ORDER BY avg(quality_control_grade) desc;	

SELECT showroom_name, sales_rep_name, visitor_language, sum(order_total_price)
	FROM warehouse.showroom_visit
	JOIN warehouse.visitor using (visitor_id)
	JOIN warehouse.sales_representative using (sales_rep_id)
	JOIN warehouse.order using (order_id)
	JOIN warehouse.showroom using (showroom_id)
	GROUP BY GROUPING SETS(
		(showroom_name, sales_rep_name, visitor_language),
		(showroom_name, visitor_language),
		(showroom_name, sales_rep_name));
		 
SELECT product_category, year_actual, quality_control_grade, count(product_id)
	FROM warehouse.production
	JOIN warehouse.product using (product_id)
	JOIN warehouse.date ON date.date_id = production.end_date_id
	JOIN warehouse.quality_control using (quality_control_id)
	GROUP BY GROUPING SETS(
		(product_category, year_actual, quality_control_grade),
		(year_actual, quality_control_grade));
	
		 
SELECT vl.city, count(visitor_id), NTILE(4) OVER (ORDER BY count(visitor_id)) AS TILE4
	FROM warehouse.showroom_visit
	JOIN warehouse.visitor using (visitor_id)
	JOIN warehouse.location as vl on warehouse.visitor.location_id = vl.location_id 
	WHERE vl.province = 'Bozen'
	GROUP BY vl.city;
	
SELECT operator_name, ROUND(sum(duration)::numeric,2), NTILE(4) OVER (ORDER BY sum(duration)) AS TILE4
	FROM warehouse.production
	JOIN warehouse.operator using (operator_id)
	GROUP BY operator_name;
																 																 
SELECT showroom_name, count(distinct visitor_id), 
		RANK() OVER (ORDER BY count(distinct visitor_id) DESC)
	FROM warehouse.showroom_visit
	JOIN warehouse.showroom using (showroom_id)
	GROUP BY showroom_name;


SELECT product_category, ROUND(avg(raw_material_cost)::numeric,2),
		RANK() OVER (ORDER BY (avg(raw_material_cost)) DESC)
	FROM warehouse.production
	JOIN warehouse.product using (product_id)
	GROUP BY product_category;																				   
																				   
																				   
SELECT date_actual, sum(order_total_price), 
		ROUND(AVG(SUM(order_total_price))
			OVER ( ORDER BY date_actual
			ROWS BETWEEN 7 PRECEDING
			AND CURRENT ROW)::numeric,2)
	FROM warehouse.showroom_visit
	JOIN warehouse.date using (date_id)
	JOIN warehouse.order using (order_id)
	WHERE year_actual > 2017
	GROUP BY date_actual
	ORDER BY date_actual;
				  
				  
				  
SELECT year_actual, month_actual, sum(raw_material_cost), 
		ROUND(AVG(SUM(raw_material_cost))
			OVER ( ORDER BY year_actual, month_actual
			ROWS BETWEEN 6 PRECEDING
			AND CURRENT ROW)::numeric,2)
	FROM warehouse.production
	JOIN warehouse.date ON date.date_id = production.end_date_id
	GROUP BY year_actual, month_actual
	ORDER BY year_actual, month_actual;	
				  
				  
SELECT year_actual, quarter_actual, 
	visitors_this_year, visitors_last_year,
	visitors_this_year - visitors_last_year as difference
	FROM (
		SELECT year_actual, quarter_actual,
			count(visitor_id) as visitors_this_year,
			LAG(count(visitor_id), 4) OVER (ORDER BY year_actual, quarter_actual) as visitors_last_year 
		FROM warehouse.showroom_visit
			JOIN warehouse.date using (date_id)
			JOIN warehouse.order using (order_id)
			GROUP BY year_actual, quarter_actual
			ORDER BY year_actual, quarter_actual) as last_year
		WHERE year_actual > 2010;
				  
				  
				  