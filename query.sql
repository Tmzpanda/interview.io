-- WITH AS
/*
A replacement to sub-query.


*/
-- Departments where the average salary of this department is higher than the average salary of the company.
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



-- Second Highest Salary
WITH temp(salary) AS
(   
    SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC 
    LIMIT 1 OFFSET 1
)
SELECT IFNULL((SELECT salary AS SecondHighestSalary FROM temp), NULL) AS SecondHighestSalary


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

SELECT db.getNthHighestSalary(10)



-- Window Funtion
-- Highest Salary For each Department

WITH temp(department_id, max_salary) AS
(
  SELECT DepartmentId, MAX(Salary)
  FROM Employee
  GROUP BY DepartmentId
)
SELECT
    Department.name AS 'Department',
    Employee.name AS 'Employee',
    Salary
FROM Employee
JOIN temp
ON temp.DepartmentId = Department.Id







普通quuery
with
nth highest salary for eacch deparmenet
















