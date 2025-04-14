create table orders (
	order_id Integer,
	user_id Integer,
	order_date Timestamp,
	total_amount Float,
	payment_status String
)
engine = MergeTree()
order by order_id;

select * from orders;

create table order_items (
	item_id Integer,
	order_id Integer,
	product_name String,
	product_price Float,
	quantity Integer
)
engine = MergeTree()
order by item_id;

select * from order_items;

-- 1

select
	payment_status,
	count(order_id) as cnt_order,
	round(sum(total_amount), 2) sum_order,
	round(avg(total_amount), 2) as avg_order
from orders
group by payment_status
order by payment_status asc;

--|payment_status|cnt_order|sum_order|avg_order|
--|--------------|---------|---------|---------|
--|cancelled|2|120.0|60.0|
--|paid|10|11198.99|1119.9|
--|pending|4|3049.5|762.38|

-- 2

select
	o.order_id,
	sum(oi.quantity) as quantity,
	sum(oi.product_price * oi.quantity) as total,
	avg(oi.product_price) as average
from orders o 
	left join order_items oi on o.order_id = oi.order_id
group by o.order_id
order by o.order_id;

--|order_id|quantity|total|average|
--|--------|--------|-----|-------|
--|1001|2|1200.0|600.0|
--|1002|1|999.5|999.5|
--|1003|0|0.0|0.0|
--|1004|3|650.0|175.0|
--|1005|0|0.0|0.0|
--|1006|0|0.0|0.0|
--|1007|2|50.0|25.0|
--|1008|0|0.0|0.0|
--|1009|2|1000.0|500.0|
--|1010|1|799.0|799.0|
--|1011|3|60.0|20.0|
--|1012|3|1950.0|650.0|
--|1013|10|150.0|15.0|
--|1014|1|300.0|300.0|
--|1015|3|650.0|175.0|
--|1016|2|500.0|250.0|

-- 3

select
	date(order_date) as dt,
	count(order_id) as cnt_order,
	round(sum(total_amount), 2) sum_order
from orders
group by date(order_date)
order by dt desc;

--|dt|cnt_order|sum_order|
--|--|---------|---------|
--|2023-03-03|5|5449.99|
--|2023-03-02|6|4769.0|
--|2023-03-01|5|4149.5|

-- 4

select
	user_id,
	count(order_id) as cnt
from orders
group by user_id
order by cnt desc;

--|user_id|cnt|
--|-------|---|
--|10|5|
--|15|3|
--|14|2|
--|12|2|
--|11|2|
--|13|2|
