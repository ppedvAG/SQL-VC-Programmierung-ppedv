--einfache CTE 

with cte (AngID, Famname)
as
(
select employeeid as Angid, lastname as FamName from employees
)
select * from cte



Select employeeid, count(*) --avg?
from orders group by employeeid
GO

--Bestellungen im Schnitt pro Ang
;with cte(angId, Anzahl)
as
(Select employeeid, count(*) --avg?
from orders group by employeeid)
select avg(anzahl) from cte


--Liste Produkt , unitprice und Categoryname
;WITH MYcte
	(Prname, unitprice, categoryname)
AS
	(select p.productname as prname , p.unitprice, c.categoryname	
		from products p inner  join categories c
		on p.CategoryID=c.CategoryID)
select * from mycte order by categoryname, unitprice


--Wieviele Angestellte managed jeder ..
With myEmps (lastname, firstname, Knechte, Chef)
as
(select lastname,firstname, 
	(select count(1) from employees e2 where
		 e1.EmployeeID=e2.ReportsTo)
	,reportsto
from employees e1)
Select Lastname, firstname, knechte,  Chef from myEmps 


--Liste ergänzen um:
--zu jedem Ang den manager und die Anzahl der Knechte

;WITH EmployeeSubordinatesReport (EmployeeID, LastName, FirstName, NumberOfSubordinates, ReportsTo) AS
(
   SELECT
      EmployeeID,
      LastName,
      FirstName,
      (SELECT COUNT(1) FROM Employees e2
       WHERE e2.ReportsTo = e.EmployeeID) as NumberOfSubordinates,
      ReportsTo
   FROM Employees e
)

SELECT Employee.LastName, Employee.FirstName, Employee.NumberOfSubordinates,
   Manager.LastName as ManagerLastName, Manager.FirstName as ManagerFirstName, Manager.NumberOfSubordinates as ManagerNumberOfSubordinates
FROM EmployeeSubordinatesReport Employee
   LEFT JOIN EmployeeSubordinatesReport Manager ON
      Employee.ReportsTo = Manager.EmployeeID


with CTE (empid, reportsto)
as 
(
select employeeid as empid, reportsto from employees where reportsto is null
UNION ALL
select e.employeeid, e.reportsto from employees e inner join cte on cte.empid = e.reportsto
)
select * from cte


--CTE


