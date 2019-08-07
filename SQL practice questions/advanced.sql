/*

*/

SELECT

FROM




/*
45. Fix the null, have 0 instead of NULL in the late orders.
*/
...
...

SELECT 
	`total_count`.`employee_id`,
	(CASE `late_count`.`late_order_count` WHEN NULL THEN 0
	ELSE `late_count`.`late_order_count` END) `late_order_count`,
	`total_count`.`total_order_count`
FROM 
	...



/*
44. Continue 43, Show all employees who have taken orders.
*/
	--CTE MySQL 8.0 required
WITH `late_count` AS (
	SELECT 
		`orders`.`employee_id`,
		COUNT(`order_id`) `late_order_count`
	FROM 
		`orders`
	LEFT JOIN 
		`purchase_order_details`
	ON 
		`orders`.`id` = `purchase_order_details`.`purchase_order_id`
	WHERE 
		`purchase_order_details`.`date_received` > `purchase_order_details`.`required_date`
	GROUP BY `orders`.`employee_id`
),
`total_count` AS (
	SELECT 
		`orders`.`employee_id`,
		COUNT(`order_id`) `total_order_count`
	FROM 
		`orders`
	GROUP BY `orders`.`employee_id`
)

SELECT 
	`total_count`.`employee_id`,
	`late_count`.`late_order_count`,
	`total_count`.`total_order_count`
FROM 
	`late_count`
RIGHT JOIN 
	`total_count`
ON `late_count`.`employee_id` = `total_count`.`employee_id`
;
/*
43. Compare the num of late orders against total processed by each salesperson.
*/
	--CTE MySQL 8.0 required
WITH `late_count` AS (
	SELECT 
		`orders`.`employee_id`,
		COUNT(`order_id`) `late_order_count`
	FROM 
		`orders`
	LEFT JOIN 
		`purchase_order_details`
	ON 
		`orders`.`id` = `purchase_order_details`.`purchase_order_id`
	WHERE 
		`purchase_order_details`.`date_received` > `purchase_order_details`.`required_date`
	GROUP BY `orders`.`employee_id`
),
`total_count` AS (
	SELECT 
		`orders`.`employee_id`,
		COUNT(`order_id`) `total_order_count`
	FROM 
		`orders`
	GROUP BY `orders`.`employee_id`
)

SELECT 
	`late_count`.`employee_id`,
	`late_count`.`late_order_count`,
	`total_count`.`total_order_count`
FROM 
	`late_count`
LEFT JOIN 
	`total_count`
ON `late_count`.`employee_id` = `total_count`.`employee_id`
;

/*
42. Find the salespeople that has the most orders arriving late.
*/
SELECT 
	`orders`.`employee_id`,
	COUNT(`order_id`) `late_order_count`
FROM 
	`orders`
LEFT JOIN 
	`purchase_order_details`
ON 
	`orders`.`id` = `purchase_order_details`.`purchase_order_id`
WHERE 
	`purchase_order_details`.`date_received` > `purchase_order_details`.`required_date`
GROUP BY `orders`.`employee_id`
ORDER BY `late_order_count` DESC
LIMIT 10
;
/*
41. Found out late orders
*/
SELECT 
	`orders`.`id`
FROM 
	`orders`
LEFT JOIN 
	`purchase_order_details`
ON `orders`.`id` = `purchase_order_details`.`purchase_order_id`
WHERE 
	`purchase_order_details`.`date_received` > `purchase_order_details`.`required_date`
;
/*
39. Continue Question 38: show details of the order
*/
SELECT 
	`table_1`.`order_id`,
	`table_2`.`product_id`,
	`table_2`.`unit_price`,
	`table_2`.`quantity`,
	`table_2`.`discount`
FROM 
(SELECT 
	DISTINCT `order_id` -- returns duplicates in the final result without DISTINCT
FROM 
	`order_details`
WHERE 
	`quantity` > 10
GROUP BY 
	`order_id`, `quantity`
HAVING COUNT(`product_id`) >= 2
) table_1
LEFT JOIN 
	`order_details` `table_2`
ON `table_1`.`order_id` = `table_2`.`order_id`
ORDER BY 
	`order_id` ASC
;
/*
38. Accidental double-entry:
 They have different product_id but the same quantity, which is 60 or more.
*/
SELECT 
	DISTINCT `order_id` -- order_id might have duplicates bc of double-entry
FROM 
	`order_details`
WHERE 
	`quantity` > 10
GROUP BY 
	`order_id`, `quantity`
HAVING COUNT(`product_id`) >= 2
ORDER BY 
	`order_id` ASC

-- Alternative
SELECT 
	`order_id`
FROM 
(SELECT 
	`order_id`,
	`quantity`,
	COUNT(`product_id`) AS `product_count`
FROM 
	`order_details`
GROUP BY 
	`order_id`, `quantity`
) table_1
WHERE 1=1
	AND `product_count` > 1
	AND `quantity` >= 60
ORDER BY 
	`order_id` ASC
;

/*
???? 37. Random Assortment: Show a random set of 2% of all orders.
*/
SELECT 
	*
FROM 
	`orders`
ORDER BY RAND()
LIMIT 0.01* (SELECT id FROM orders)

/*
36. Top 10 orders with the most lines of items
*/
SELECT 
	`order_id`,
	COUNT(`order_id`) AS `total_order_details`
FROM `order_details`
GROUP BY `order_id`
ORDER BY `total_order_details` DESC
LIMIT 10
;
/*
35. Find all orders made on the last day of the month. 
	Order by employee_id and order_id.
*/
SELECT 
	*
FROM 
	`orders`
WHERE
	`order_date` = LAST_DAY(`order_date`)
;
/*
34. Continue Question 34, find instead customers with total amount
	more then $2,000 in 2016 including discount.
*/
SELECT 
	`customers`.`company`,
	SUM(`order_details`.`quantity`*`order_details`.`unit_price`*(1-`order_details`.`discount`))
		 AS `total_amount`
FROM `order_details` 
LEFT JOIN `orders`
	ON `orders`.`id` = `order_details`.`id`
LEFT JOIN `customers`
	ON `orders`.`customer_id` = `customers`.`id`
WHERE 
	YEAR(`orders`.`order_date`) = 2006
GROUP BY 
	`customers`.`company`
HAVING 
	`total_amount` >=2000
;
/*
33. Continue Question 33, find instead customers with total amount
	more then $2,000 in 2016.
*/
SELECT 
	`customers`.`company`,
	SUM(`order_details`.`quantity`*`order_details`.`unit_price`) AS `total_amount`
FROM `order_details` 
LEFT JOIN `orders`
	ON `orders`.`id` = `order_details`.`id`
LEFT JOIN `customers`
	ON `orders`.`customer_id` = `customers`.`id`
WHERE 
	YEAR(`orders`.`order_date`) = 2006
GROUP BY 
	`customers`.`company`
HAVING 
	`total_amount` >=2000
;

/*
32. Find high-value customers:
	who have made at least 1 order more than $1,000 in year 2016.
*/
SELECT 
	`customers`.`company`
FROM `order_details` 
LEFT JOIN `orders`
	ON `orders`.`id` = `order_details`.`id`
LEFT JOIN `customers`
	ON `orders`.`customer_id` = `customers`.`id`
WHERE 1=1
	AND `order_details`.`quantity`*`order_details`.`unit_price` >=1000
	AND YEAR(`orders`.`order_date`) = 2006
;