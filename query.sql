/*
-- 176. Second Highest Salary
-- 177. Nth Highest Salary

-- 184. Highest Salary For each Department
-- 185. Top Three Salaries For each Department -- window function

-- 615. Average Salary for each Month: Departments vs Company -- add a column

-- 1398. Customers Who Bought Products A and B but Not C - frequency of records

-- 1555. User Transaction and Credit - row to column
-- 1479. Category Quantity by Weekday - PIVOT: column to row
-- 618. Student Continent - column to row



*/

-- 176. Second Highest Salary
WITH temp(salary) AS
(   
    SELECT DISTINCT Salary
    FROM Employee
    ORDER BY Salary DESC 
    LIMIT 1 OFFSET 1
)
SELECT IFNULL((SELECT salary AS SecondHighestSalary FROM temp), NULL) AS SecondHighestSalary		-- IFNULL

-- 177. Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    DECLARE K INT;
    SET K = N - 1;
    RETURN (       
        SELECT DISTINCT Salary
        FROM Employee
        ORDER BY Salary DESC 
        LIMIT 1 OFFSET K		-- OFFSET
    );
END
SELECT db.getNthHighestSalary(10)




-- 184. Highest Salary For each Department
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
WHERE (Employee.DepartmentId, Salary) IN (SELECT Temp.DepartmentId, Temp.MaxSalary FROM Temp)	-- WHERE xx IN xx

-- 185. Top Three Salaries For each Department
WITH Temp AS
(
    SELECT *, DENSE_RANK() OVER(PARTITION BY DepartmentId ORDER BY Salary DESC) AS 'Rank'  	-- DENSE_RANK() window function
    FROM Employee  
)
SELECT Department.Name AS Department, Temp.Name AS Employee, Temp.Salary 
FROM Temp
JOIN Department 
ON Temp.DepartmentId = Department.Id
WHERE Temp.Rank <= 3




-- 615. Average Salary for each Month: Departments vs Company
WITH 
department_salary AS (
    SELECT DATE_FORMAT(s.pay_date, '%Y-%m') AS pay_month, e.department_id, AVG(s.amount) AS department_average 	  -- DATE_FORMAT(s.pay_date, '%Y-%m')
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
    END AS comparison												  -- CASE WHEN ELSE END AS xx
FROM department_salary
JOIN company_salary
ON department_salary.pay_month = company_salary.pay_month

-- Departments where the average salary of this department is higher than the average salary of the company.
WITH 
department_salary(department, average_salary) AS
(
  SELECT department, avg(salary)
  FROM salaries
  GROUP BY department
)
SELECT Department
FROM department_salary
WHERE department_salary.average_salary > (SELECT avg(salary) FROM salaries); 	-- WHERE xx > xx




-- 1398. Customers Who Bought Products A and B but Not C
WITH Temp AS
(
    SELECT customer_id
    From Orders
    GROUP BY customer_id
    HAVING SUM(product_name = 'A') > 0 AND SUM(product_name = 'B') > 0 AND SUM(product_name = 'C') = 0		-- frequency of records
)
SELECT customer_id, customer_name
FROM Customers
WHERE customer_id in (SELECT customer_id FROM Temp);




-- 1555. User Transaction and Credit
WITH 
Temp AS
(   
    SELECT paid_by AS user_id, -amount AS transaction
    FROM Transaction
    UNION								-- row to column
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
     CASE WHEN Users.credit + User_transaction.transactions > 0 THEN 'No' ELSE 'Yes' END AS 'credit_limit_breached'
FROM Users
JOIN User_transaction
ON Users.user_id = User_transaction.user_id




-- 1479. Category Quantity by Weekday
-- SQL Server
WITH Temp AS
(
    SELECT Items.item_category AS Category, DATENAME(w, Orders.order_date) AS Weekday, SUM(Orders.quantity) AS Quantity		    	  -- DATENAME
    FROM Orders 
    RIGHT JOIN Items 
    ON Orders.item_id = Items.item_id
    GROUP BY Items.item_category, DATENAME(w, Orders.order_date)
)
SELECT Category, ISNULL([Monday], 0) Monday , ISNULL([Tuesday], 0) Tuesday, ISNULL([Wednesday], 0) Wednesday, ISNULL([Thursday], 0) Thursday, ISNULL([Friday], 0) Friday, ISNULL([Saturday], 0) Saturday, ISNULL([Sunday], 0) Sunday		
FROM Temp PIVOT(MAX(Quantity) FOR Weekday IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])) P;		  -- PIVOT
-- UNPIVOT(Quantity FOR Weekday IN ([Monday], [Tuesday], [Wednesday], [Thursday], [Friday], [Saturday], [Sunday])) P
														   														   
-- MySQL
WITH Temp AS
(
    SELECT Items.item_category AS Category, DATE_FORMAT(Orders.order_date, '%W') AS Weekday, SUM(Orders.quantity) AS Quantity 	-- DATE_FORMAT
    FROM Orders 
    RIGHT JOIN Items 
    ON Orders.item_id = Items.item_id
    GROUP BY Items.item_category, DATE_FORMAT(Orders.order_date, '%W')
)
SELECT Category,
MAX(CASE WHEN Weekday = 'Monday' THEN Quantity ELSE 0 END) AS Monday,								-- column to row								
MAX(CASE WHEN Weekday = 'Tuesday' THEN Quantity ELSE 0 END) AS Tuesday,
MAX(CASE WHEN Weekday = 'Wednesday' THEN Quantity ELSE 0 END) AS Wednesday,
MAX(CASE WHEN Weekday = 'Thursday' THEN Quantity ELSE 0 END) AS Thursday,
MAX(CASE WHEN Weekday = 'Friday' THEN Quantity ELSE 0 END) AS Friday,
MAX(CASE WHEN Weekday = 'Saturday' THEN Quantity ELSE 0 END) AS Saturday,
MAX(CASE WHEN Weekday = 'Sunday' THEN Quantity ELSE 0 END) AS Sunday
FROM Temp
GROUP BY Category
														   

														   
														   
-- 618. Student Continent
-- SQL Server
WITH temp1 AS
(
    SELECT *, ROW_NUMBER() OVER(PARTITION BY continent ORDER BY name) AS uid
    FROM student
)
SELECT America, Europe, Asia
FROM temp1 PIVOT (MAX(name) FOR continent in (America, Europe, Asia)) p

-- MySQL
WITH 
temp1 AS
(
    SELECT *, ROW_NUMBER() OVER(PARTITION BY continent ORDER BY name) AS uid	-- CASE WHEN 之后根据 ROW_NUMBER()聚合
    FROM student
),
temp2 AS
(
    SELECT uid,
    MAX(CASE WHEN continent = 'America' THEN name END )AS America,			
    MAX(CASE WHEN continent = 'Europe' THEN name END )AS Europe,
    MAX(CASE WHEN continent = 'Asia' THEN name END )AS Asia
    FROM temp1
    GROUP BY uid
)
SELECT America, Asia, Europe
FROM temp2
														   
														   
														   









