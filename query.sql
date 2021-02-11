--  WITH AS
/*




*/
-- Find departments where average salary of employees in that department is higher than the average salary of all employees in the company.
WITH 
department_salary(department, average_salary) as
(
  SELECT department, avg(salary)
  FROM salaries
  GROUP BY department
),
company_salary(average_salary) as 
(
  SELECT avg(salary)
  FROM salaries 
)
SELECT department
FROM department_salary, company_salary
WHERE department_salary.average_salary > company_salary.average_salary;
