SELECT showroom_name, department_name, season, count(visitor_id)
	FROM warehouse.showroom_visit
	JOIN warehouse.showroom using (showroom_id)
	JOIN warehouse.department using (department_id)
	JOIN warehouse.date using (date_id)
	GROUP BY ROLLUP(showroom_name, department_name, season);
	
SELECT visitor_sector, vl.district, sl.district, sum(number_of_visitors)
	FROM warehouse.showroom_visit
	JOIN warehouse.visitor using (visitor_id)
	JOIN warehouse.location as vl on warehouse.visitor.location_id = vl.location_id 
	JOIN warehouse.showroom using (showroom_id)
	JOIN warehouse.location as sl on warehouse.showroom.location_id = sl.location_id
	WHERE vl.province = 'Bozen'
	GROUP BY CUBE(vl.district, visitor_sector, sl.district)
	ORDER BY visitor_sector, vl.district, sl.district;
	
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
		 
SELECT vl.city, count(visitor_id), NTILE(4) OVER (ORDER BY count(visitor_id)) AS TILE4
	FROM warehouse.showroom_visit
	JOIN warehouse.visitor using (visitor_id)
	JOIN warehouse.location as vl on warehouse.visitor.location_id = vl.location_id 
	WHERE vl.province = 'Bozen'
	GROUP BY vl.city;

																 
SELECT showroom_name, count(distinct visitor_id), 
		RANK() OVER (ORDER BY count(distinct visitor_id) DESC)
	FROM warehouse.showroom_visit
	JOIN warehouse.showroom using (showroom_id)
	GROUP BY showroom_name;
																 

SELECT showroom_name, department_name, season, count(visitor_id)
	FROM warehouse.showroom_visit
	JOIN warehouse.showroom using (showroom_id)
	JOIN warehouse.department using (department_id)
	JOIN warehouse.date using (date_id)
	GROUP BY ROLLUP(showroom_name, department_name, season);
																 
	
-- Not working:																 
SELECT date_id, sum(order_total_price), 
		AVG(SUM(order_total_price))
			OVER ( ORDER BY date_actual
			RANGE BETWEEN INTERVAL '1' DAY PRECEDING
			AND INTERVAL '1' DAY FOLLOWING)
	FROM warehouse.showroom_visit
	JOIN warehouse.date using (date_id)
	JOIN warehouse.order using (order_id)
	GROUP date_id
	ORDER BY date_id;