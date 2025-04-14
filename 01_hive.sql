create table logs_v2 (
	log_id bigint,
	transaction_id bigint,
	category string,
	comment string,
	log_timestamp timestamp
)
row format delimited
fields terminated by '.'
stored as parquet;

select * from logs_v2;

create table transactions_v2 (
	transaction_id bigint,
	user_id bigint,
	amount float,
	currency string,
	transaction_date timestamp,
	is_fraud tinyint
)
row format delimited
fields terminated by '.'
stored as parquet;

select * from transactions_v2;

-- 1

select
	currency,
	round(sum(amount),0) as amount
from transactions_v2
where currency in ('USD', 'EUR', 'RUB')
group by currency
order by amount desc;

--|currency|amount|
--|--------|------|
--|USD|12264.0|
--|EUR|2171.0|
--|RUB|320.0|

-- 2

select
	is_fraud,
	round(sum(amount), 0) as total_amount,
	round(avg(amount), 2) as average_amount
from transactions_v2
group by is_fraud
order by is_fraud asc;

--|is_fraud|total_amount|average_amount|
--|--------|------------|--------------|
--|0|3654.0|365.37|
--|1|12170.0|1217.05|

-- 3

select 
	to_date(transaction_date) as dt,
	count(*) as cnt_amount,
	round(sum(amount), 2) as sum_amount,
	round(avg(amount), 2) as avg_amount
from transactions_v2
group by to_date(transaction_date)
order by dt desc;

--|dt|cnt_amount|sum_amount|avg_amount|
--|--|----------|----------|----------|
--|2023-03-14|4|1374.5|343.63|
--|2023-03-13|4|10743.94|2685.99|
--|2023-03-12|4|895.75|223.94|
--|2023-03-11|4|1869.5|467.38|
--|2023-03-10|4|940.5|235.13|

-- 4

select
	trunc(transaction_date, 'MM') as month,
	sum(amount) as sum_amount
from transactions_v2
group by trunc(transaction_date, 'MM')
order by month;

--|month|sum_amount|
--|-----|----------|
--|2023-03-01|15824.190231323242|

-- 5

select 
	tv.transaction_id,
	count(lv.log_id) as log_cnt
from transactions_v2 tv
	left join logs_v2 lv on tv.transaction_id = lv.transaction_id
group by tv.transaction_id
order by log_cnt desc;

--|transaction_id|log_cnt|
--|--------------|-------|
--|10010|2|
--|10020|1|
--|10002|1|
--|10004|1|
--|10006|1|
--|10007|1|
--|10001|1|
--|10013|1|
--|10014|1|
--|10015|1|
--|10019|1|
--|10012|0|
--|10017|0|
--|10005|0|
--|10018|0|
--|10011|0|
--|10008|0|
--|10009|0|
--|10003|0|
--|10016|0|
