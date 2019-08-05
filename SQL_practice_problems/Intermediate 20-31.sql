/*
My answers to the intermediate SQL questions
in the book 'SQL Practice Problems' by Sylvia Moestl Vasilik
*/

/*
31. Find customers who never placed an order 
	with an employee.
*/
SELECT 
	`customers`.`last_name`,
	`customers`.`first_name`
FROM `customers`
WHERE 
	`customers`.`id` NOT IN 
	(
	SELECT `customer_id` 
	FROM `orders` 
	WHERE `employee_id` = 3)
;

/*
30. Find customers who never placed an order.
*/
SELECT 
	`customers`.`last_name`,
	`customers`.`first_name`
FROM `customers`
LEFT JOIN `orders` ON 1=1
	AND `customers`.`id` = `orders`.`customer_id`
WHERE 1=1
	AND `orders`.`customer_id` IS NULL
;

--
SELECT 
	`customers`.`last_name`,
	`customers`.`first_name`
FROM `customers`
WHERE 
	`customers`.`id` NOT IN 
	(
	SELECT `customer_id` 
	FROM `orders`)
;
/*
29. Join 4 tables to make an Inventory List,
	sort by Order_ID and Product_ID.
*/
SELECT 
	`employees`.`id` AS `employee_id`,
	`employees`.`last_name` AS `last_name`,
	`orders`.`id` AS `order_id`,
	`products`.`product_name` AS `product_name`,
	`order_details`.`quantity` AS `quantity`
FROM 
	`employees`
LEFT JOIN `orders`
	ON `employees`.`id` = `orders`.`employee_id`
LEFT JOIN `order_details`
	ON `orders`.`id` = `order_details`.`order_id` 
LEFT JOIN `products`
	ON `order_details`.`product_id` = 	`products`.`id`
ORDER BY
	`order_details`.`order_id`,
	`products`.`id`
;
/*
28. Continue Question 25, top three countries 
from the last 12 months of order data.
*/
SELECT 
	`ship_country_region`,
	AVG(`shipping_fee`) AS `average_fee`
FROM `orders`
WHERE
	`order_date` >= DATE_ADD('2006-08-31',INTERVAL -12 MONTH)
GROUP BY `ship_country_region`
ORDER BY  `average_fee` DESC
LIMIT 3
;

/*
27. An incorrect answer check


'BETWEEN' statement is inclusive on BOTH ends.

When looking at shipped_date(DateTime format), "between 1/1/2015 and 12/31/2015"
does not include orders on 12/31/2015, because shipped_date, 
not in the Date but Datetime format, becomes 12/31/2015 00.00.000. 
Be careful.
*/

/*
26. Continue Question 25, only orders from the year 2006.
*/
SELECT 
	`ship_country_region`,
	AVG(`shipping_fee`) AS `average_fee`
FROM `orders`
WHERE 1=1
	AND YEAR(`shipped_date`) = 2006
GROUP BY `ship_country_region`
ORDER BY `average_fee` DESC
LIMIT 3
;

/*
25. Three ship countries with the highest average frieght fee,
	ordered in descending order by average frieght.
*/
SELECT 
	`ship_country_region`,
	AVG(`shipping_fee`) AS `average_fee`
FROM `orders`
GROUP BY `ship_country_region`
ORDER BY `average_fee` DESC
LIMIT 3
;
/*
24. See a list of customers, sorted by region, alphabetically.
	Customers with no region to be at the end.
*/
SELECT 
	`company`,
	CONCAT(`first_name`, " ",`last_name`) AS `customer_name`,
	`country_region`
FROM `customers`
ORDER BY 
	(CASE WHEN `country_region` IS NULL THEN 1 ELSE 0 END),
	`country_region`,
	`customer_name`
;

/*
23. Continue Question 22, 
	with Discontinued and united_on_order included.
*/
SELECT 
	`product_id`,
	`product_name`
FROM `products`
WHERE 1=1
	AND `units_in_stock`+`units_on_order` <= `reorder_level`
	AND `discontinued` = 0
ORDER BY `product_id` ASC
;
/*
22. Inventory below reorder level 
	needs to be reordered, ordered by product_id
*/
SELECT 
	`product_id`,
	`product_name`, 
	`units_in_stock`, 
	`reorder_level`	
FROM `products`
WHERE 1=1
	AND `units_in_stock` <= `reorder_level`
ORDER BY `product_id`
;
/*
21. Number of customers per Country and City in descending order.
*/
SELECT 
	`country_region`,`city`, COUNT(`id`) AS `customer_count`
FROM `customers`
GROUP BY `country_region`,`city`
ORDER BY `customer_count` DESC
;
/*
#20. Number of Products by Category; 
	Sort by the total number of products in descending order.
*/
SELECT 
	`category`, 
	COUNT(`product_code`) AS `product_count`
FROM `products`
GROUP BY `category`
ORDER BY `product_count`
;
