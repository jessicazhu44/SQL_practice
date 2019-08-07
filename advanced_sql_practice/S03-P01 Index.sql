/*
Create a new partial index on sample_staff.employee.personal_codeÂ with the first 2 characters only.

Select an employee with personal_codeÂ = "AA-751492"Â and check in execution plan which index was used. Try to use another index to verify the select would be slower or faster.

Finally, compare the size of the 2 indexes:

The original ak_employeeÂ index
Your newly created index

*/


ALTER TABLE 
	`sample_staff`.`employee`
	ADD INDEX (personal_code(2))


EXPLAIN SELECT 
	*
	FROM `employee` USE INDEX (`personal_code`)
	WHERE `personal_code` = "AA-751492" 
	-- takes 0.6 ms

EXPLAIN SELECT 
	*
	FROM `employee` 
	IGNORE INDEX (`personal_code`)
	IGNORE INDEX (`ak_employee`)
	IGNORE INDEX (`idx_email`)
	IGNORE INDEX (`PRIMARY`)
	WHERE `personal_code` = "AA-751492" 
	--takes 0.4ms
	
EXPLAIN SELECT 
	*
	FROM `employee` 
	USE INDEX (`ak_employee`)
	WHERE `personal_code` = "AA-751492" 
	--takes 0.6 ms


ANALYZE TABLE `sample_staff`.`employee`;


--compare the size of the 2 indexes
SELECT 	/* select all indices from table `employee` and their size */
	sum(`stat_value`) AS pages,
	`index_name` AS index_name,
	sum(`stat_value`) *@@innodb_page_size / 1024 / 1024 AS size_mb
FROM `mysql`.`innodb_index_stats`
WHERE 1 = 1
	AND `table_name` = 'employee'
	AND `database_name` = 'sample_staff'
	AND `stat_description` = 'Number of pages in the index'
GROUP BY 
	`index_name`
;

/* 
It takes nearly equal amount of time to search for 
a personal code, using either `ak_employee` or `personal_code` index search.
However, the size of ak_employee's size is nearly twice 
as much as personal code index.
*/





