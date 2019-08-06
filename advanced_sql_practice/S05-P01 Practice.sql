/*
Create a query to return average salary on 2000-01-01
per department and indication if it's above or below 
company average at the same date. 

Store the company average in a session variable for easier & faster comparison.
*/

-- set a session variable
SET @focus_date = '2000-01-01';

SET @company_average_salary := (
	SELECT 
		ROUND(AVG(`salary`.`salary_amount`),2) AS `company_average_salary`
	FROM `sample_staff`.`salary`
	WHERE 1=1
		AND @focus_date BETWEEN `salary`.`from_date` 
			AND IFNULL(`salary`.`to_date`,'2002-08-01')
);


-- calculate department_average_salary and compared to company_average
SELECT
	`department_avg_salary`.`department_id` AS `department_id`,
	`department_avg_salary`.`department_name` AS `department_name`,
	`department_avg_salary`.`department_average_salary` AS `department_average_salary`,
	@company_average_salary AS `company_average_salary`,
	CASE 
		WHEN `department_average_salary` > @company_average_salary
			THEN 'higher'
		WHEN `department_average_salary` = @company_average_salary
			THEN 'same'
		ELSE "lower"
	END AS `department_vs_company`
FROM (
SELECT
	`department`.`id` AS `department_id`,
	`department`.`name` AS `department_name`,
	ROUND(AVG(`salary`.`salary_amount`),2) `department_average_salary`
FROM `salary`
INNER JOIN `department_employee_rel` 
	ON `salary`.`employee_id` = `department_employee_rel`.`employee_id`
INNER JOIN `department`
	ON `department`.`id` = `department_employee_rel`.`department_id`
WHERE 1=1
	AND @focus_date BETWEEN `salary`.`from_date` 
	  AND IFNULL(`salary`.`to_date`, '2002-08-01')
GROUP BY `department`.`name`
) `department_avg_salary`
;
