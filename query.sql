-- 176. Second Highest Salary
WITH temp(salary) AS
(   
    SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC 
    LIMIT 1 OFFSET 1
)
SELECT IFNULL((SELECT salary AS SecondHighestSalary FROM temp), NULL) AS SecondHighestSalary

-- 177. Nth Highest Salary
-- FUNCTION
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




-- 184. Highest Salary For each Department
-- WHERE xx IN (SELECT xx)
WITH Temp(DepartmentId, MaxSalary) AS
(
    SELECT DepartmentId, MAX(Salary)
    FROM Employee
    GROUP BY DepartmentId
)
SELECT Department.Name AS Department, Employee.Name AS Employee, Salary 
FROM Employee
JOIN Department 
ON Employee.DepartmentId = Department.Id
WHERE (Employee.DepartmentId, Salary) IN (SELECT Temp.DepartmentId, Temp.MaxSalary FROM Temp)

-- 185. Top Three Salaries For each Department
-- DENSE_RANK() OVER(PARTITION BY xx ORDER BY xx DESC)
WITH Temp AS
(
    SELECT *, DENSE_RANK() OVER(PARTITION BY DepartmentId ORDER BY Salary DESC) AS 'Rank'  
    FROM Employee  
)
SELECT Department.Name AS Department, Temp.Name AS Employee, Temp.Salary 
FROM Temp
JOIN Department 
ON Temp.DepartmentId = Department.Id
WHERE Temp.Rank <= 3




-- 615. Average Salary for each Month: Departments vs Company
-- CASE WHEN THEN END
WITH 
department_salary AS (
    SELECT DATE_FORMAT(s.pay_date, '%Y-%m') AS pay_month, e.department_id, AVG(s.amount) AS department_average
    FROM salary s
    JOIN employee e
    ON s.employee_id = e.employee_id
    GROUP BY DATE_FORMAT(s.pay_date, '%Y-%m'), e.department_id
), 
company_salary AS (
    SELECT DATE_FORMAT(s.pay_date, '%Y-%m') AS pay_month, AVG(amount) AS company_average
    FROM salary s
    GROUP BY DATE_FORMAT(s.pay_date, '%Y-%m')
)
SELECT department_salary.pay_month, department_salary.department_id, 
    CASE 
        WHEN department_salary.department_average > company_salary.company_average THEN 'higher'
        WHEN department_salary.department_average < company_salary.company_average THEN 'lower'
        ELSE 'same'
    END AS 'comparison'
FROM department_salary
JOIN company_salary
ON department_salary.pay_month = company_salary.pay_month

-- Departments where the average salary of this department is higher than the average salary of the company.
-- WHERE xx > (SELECT xx)
WITH 
department_salary(department, average_salary) AS
(
  SELECT department, avg(salary)
  FROM salaries
  GROUP BY department
)
SELECT Department
FROM department_salary
WHERE department_salary.average_salary > (SELECT avg(salary) FROM salaries);




-- 1398. Customers Who Bought Products A and B but Not C
-- HAVING SUM(product_name = 'A') > 0 AND SUM(product_name = 'B') > 0 AND SUM(product_name = 'C') = 0
WITH Temp AS
(
	SELECT customer_id
    From Orders
    GROUP BY customer_id
    HAVING SUM(product_name = 'A') > 0 AND SUM(product_name = 'B') > 0 AND SUM(product_name = 'C') = 0
)
SELECT customer_id, customer_name
FROM Customers
WHERE customer_id in (SELECT customer_id FROM Temp);




-- 1555. Bank Account Summary
-- (paid_by, paid_to, amount) -> (user_id, transaction)
WITH 
Temp AS
(   
    SELECT paid_by AS user_id, -amount AS transaction
    FROM Transaction
    UNION
    SELECT paid_to AS user_id, amount AS transaction
    FROM Transaction
),
User_transaction AS
(
    SELECT user_id, SUM(transaction) AS transaction
    FROM Temp
    GROUP BY user_id
)
SELECT Users.user_id, Users.user_name, User_transaction.transaction,
     CASE 
          WHEN Users.credit + User_transaction.transactions > 0 THEN 'No'
          ELSE 'Yes'
      END AS 'credit_limit_breached'
FROM Users
JOIN User_transaction
ON Users.user_id = User_transaction.user_id




--

























