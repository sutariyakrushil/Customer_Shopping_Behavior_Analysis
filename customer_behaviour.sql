SELECT TOP 20 * FROM customer;

--Q1. What is the total revenue genrated by male vs female customer ?
select gender , SUM( purchase_amount ) as revenue from customer group by gender;

--Q2. Which customer used a discount but still spent more than the average purchase amount?
select customer_id, purchase_amount from customer
where discount_applied= 'yes' AND purchase_amount >= (select AVG(purchase_amount) from customer)

--Q3. Which are the top 5 products with the highest average review rating?
SELECT TOP 5 item_purchased, ROUND(AVG(review_rating), 2) AS avg_rating FROM customer
GROUP BY item_purchased
ORDER BY avg_rating DESC;

--Q4. Compare the average purchase amounts between standard and express shipping.
select shipping_type, round(avg(purchase_amount),2) from customer
where shipping_type in ('Standard','Express') group by shipping_type;

--Q5. Do subscribed customers spend more? Compare average spend and total revenue between subscribers and non-subscribers.
select subscription_status, count(customer_id) as total_customer,
round(avg(purchase_amount),2) as spend_amount,
round(sum(purchase_amount),2) as total_revenue from customer 
group by subscription_status order by total_revenue, spend_amount desc;

--Q6. Whihch 5 products haave the highest percentage of purchases with discount applied?
select top 5 item_purchased , round(100 * sum(case when discount_applied = 'yes' then 1 else 0 end)/count(*),2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc;

--Q7. Segment customers into New, Returning, and loyal based on their total number of previous purchases, and show the count of each segment.
WITH customer_type AS (SELECT customer_id, previous_purchases,
CASE WHEN previous_purchases = 1 THEN 'New'
WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning' ELSE 'Loyal'
END AS customer_segment FROM customer
) 
SELECT customer_segment,
COUNT(*) AS [Number of Customers]
FROM customer_type
GROUP BY customer_segment;

--Q8. What are the top 3 most purchased products within each category?
with item_counts as( select category, item_purchased, count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id)desc) as item_rank
from customer
group by category, item_purchased
)
select item_rank, category, item_purchased, total_orders
from item_counts
where item_rank <= 3;

--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases > 5
group by subscription_status;

--Q10. What is the revenue contribution of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from customer 
group by age_group
order by total_revenue desc;