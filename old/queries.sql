SELECT v.visitor_name, s.showroom_name, sr.sales_rep_name, duration, number_of_visitors
FROM warehouse.showroom_visit as sv
join warehouse.visitor as v on sv.visitor_id = v.visitor_id
join warehouse.sales_representative as sr on sv.sales_rep_id = sr.sales_rep_id
join warehouse.showroom as s on sv.showroom_id = s.showroom_id
join warehouse.department as de on sv.department_id = de.department_id
join warehouse.date as d on sv.date_id = d.date_id
join warehouse.visitor_type as vt on sv.visitor_type_id = vt.visitor_type_id;

SELECT v.visitor_id, v.visitor_name, s.showroom_name, count(v.visitor_id)
FROM warehouse.showroom_visit as sv
join warehouse.visitor as v on sv.visitor_id = v.visitor_id
join warehouse.showroom as s on sv.showroom_id = s.showroom_id
group by v.visitor_id, s.showroom_id
order by v.visitor_id;

SELECT s.showroom_name, count(v.visitor_id), count(distinct v.visitor_id)
FROM warehouse.showroom_visit as sv
join warehouse.visitor as v on sv.visitor_id = v.visitor_id
join warehouse.showroom as s on sv.showroom_id = s.showroom_id
group by s.showroom_id;

SELECT s.showroom_name, sr.sales_rep_name
FROM warehouse.showroom_visit as sv
join warehouse.sales_representative as sr on sv.sales_rep_id = sr.sales_rep_id
join warehouse.showroom as s on sv.showroom_id = s.showroom_id
group by s.showroom_id, sr.sales_rep_id
order by  sr.sales_rep_id
