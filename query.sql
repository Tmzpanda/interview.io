-- WITH AS
/*
A replacement to sub-query.


*/
-- Find departments where average salary of employees in that department is higher than the average salary of all employees in the company.
WITH 
department_salary(department, average_salary) AS
(
  SELECT department, avg(salary)
  FROM salaries
  GROUP BY department
),
company_salary(average_salary) AS
(
  SELECT avg(salary)
  FROM salaries 
)
SELECT department
FROM department_salary, company_salary
WHERE department_salary.average_salary > company_salary.average_salary;





-- Function
-- Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE K INT;
    SET K = N - 1;
    RETURN (       
        SELECT DISTINCT Salary
        FROM Employee
        ORDER BY Salary DESC 
        LIMIT 1 OFFSET K
    );
END
