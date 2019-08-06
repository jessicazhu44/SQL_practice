/*
Create a new table sample_staff.invoice_partitioned
based on sample_staff.invoice, but change the following:

a.  add one more column: department_code
b. remove the current partitions & sub-partitions

Then, copy data from invoice to the new table and also fill in 
the new column based on the department which the user was a part 
at the time of invoiced_date.

Add new LIST partitioning to table invoice based on the department_code.
*/

ALTER TABLE `invoice_partitioned` REMOVE PARTITIONING;


-- copy all the data and insert into `invoice`
INSERT INTO `invoice_partitioned`
SELECT *
FROM `invoice`
;

--fill in the new column based on the department which the user was
UPDATE `invoice_partitioned`     -- INSERT a new row, UPDATE the existing column
INNER JOIN
`department_employee_rel` 
ON 1=1
	AND `department_employee_rel`.`employee_id` = `invoice_partitioned`.`employee_id`
	AND `invoice_partitioned`.`invoiced_date` BETWEEN `department_employee_rel`.`from_date` 
	AND IFNULL(`department_employee_rel`.`to_date`,'2003-01-01')
	AND `department_employee_rel`.`deleted_flag` = 0
INNER JOIN 
`sample_staff`.`department` ON
`sample_staff`.`department_employee_rel`.`department_id` = `sample_staff`.`department`.`id`
SET `invoice_partitioned`.`department_code`= `department`.`id`
;


ALTER TABLE
	`invoice_partitioned`
PARTITION BY LIST( `department_code` )
  ( PARTITION p1 VALUES IN (1),
 	PARTITION p2 VALUES IN (2),
	PARTITION p3 VALUES  IN(3),
	PARTITION p4 VALUES  IN (4),
	PARTITION p5 VALUES  IN (5),
	PARTITION p6 VALUES  IN (6),
	PARTITION p7 VALUES  IN (7),
	PARTITION p8 VALUES  IN (8),
	PARTITION p9 VALUES  IN (9) 	
 	)
 ;

