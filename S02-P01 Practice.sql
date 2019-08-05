/* 
Assignment: Rewrite and beautify the query below 
	1. Capitalized all the statement;
	2. Separated attributes (columns) to rows
	3. Removed all the shortened acronyms, and used more descriptive alias
	4. Added 'where 1=1 and'
	5. Added space between lines

Function: Find all the selected employees, their names and the most recent department.
*/

SELECT  
	`employee`.`id` AS `employee_id`, 
	concat(`employee`.`first_name`, ' ', `employee`.`last_name`) AS `employee_full_name`, 
	`department`.`id` AS `department_id`, `department`.`name` AS `last_department_name`
FROM `employee`
INNER JOIN
	(SELECT 	-- selects the max id of each employee
		`department_employee_rel`.`employee_id`, 
		max(`department_employee_rel`.`id`) AS `max_id` 
	FROM `department_employee_rel` 
	WHERE 1=1
		AND `department_employee_rel` .`deleted_flag` = 0 
	GROUP BY `department_employee_rel` .`employee_id` 
	) `employee_max_id` 
ON `employee_max_id`.`employee_id` = `employee`.`id`
INNER JOIN `department_employee_rel` ON 1=1 
	AND `department_employee_rel`.`id` = `employee_max_id`.`max_id`
	AND `department_employee_rel`.`deleted_flag` = 0 
INNER JOIN `department` ON 1=1
	AND `department`.`id` = `department_employee_rel`.`department_id`
	AND `department`.`deleted_flag` = 0 
WHERE 1=1
	AND `employee`.`id` IN (10010, 10040, 10050, 91050, 205357) 
	AND `employee`.`deleted_flag` = 0 
LIMIT 100; 


/* Original code:
select e.id AS employee_id, concat(e.first_name, ' ', e.last_name) AS employee_full_name, d.id AS department_id, d.name AS last_department_name 
from employee e inner join 
( select der.employee_id, max(der.id) AS max_id from department_employee_rel der where der.deleted_flag = 0 group by der.employee_id ) derm 
ON derm.employee_id = e.id inner join department_employee_rel der ON der.id = derm.max_id and der.deleted_flag = 0 inner join department d 
ON d.id = der.department_id and d.deleted_flag = 0 where e.id IN (10010, 10040, 10050, 91050, 205357) and e.deleted_flag = 0 limit 100; 
*/