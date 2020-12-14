--Window Function

----F() OVER(PARTITION BY Col1 ORDER BY Col2 DESC)

--ROW_NUMBER------------
--fortlaufende Zahl--

SELECT
		orderid,
		employeeid,
		customerid,
		freight,
		row_number () OVER ( 
			PARTITION BY employeeid
			ORDER BY freight DESC
		) Rang
	FROM orders





-------------RANK-----------------
--RANK überspringt gleichen Rang----
	SELECT
		orderid,
		employeeid,
		customerid,
		freight,
		RANK () OVER ( 
			PARTITION BY employeeid
			ORDER BY freight DESC
		) Rang
	FROM orders


---------dense_rank----------
--vergibt gleichen Rang mehrmals---


select freight , rank() over (order by freight),
				dense_Rank() over (order by freight) from orders
order by freight asc


----NTILE----
--aufteilen in gleiche Anzahl ---

select ntile(10) over (order by freight)
, freight from orders


---auch mit AGG---
--Prozentanteil

select 
	orderid,productid, 
	sum(unitprice*quantity) over (partition by orderid),
	 cast(1 *  (unitprice*quantity)/sum(unitprice*quantity) over (partition by orderid) 
		* 100 as Decimal(5,2))
	 from [Order Details]
	 order by 1,4

---,SUM(Col1) OVER (PARTITION BY Col2)
---ORDER BY Col3   ROWS UNBOUNDED PRECEDING)--aufsummieren


select orderid, sum(unitprice*quantity)
over ( order by orderid ROWS UNBOUNDED PRECEDING) 
from [order details]

select orderid, 
	sum(unitprice*quantity)
		over ( order by orderid ROWS UNBOUNDED PRECEDING) ,
	sum(unitprice*quantity)
		over ( order by orderid RANGE UNBOUNDED PRECEDING),
	sum(unitprice*quantity)
		OVER(ORDER BY orderid ROWS Between CURRENT ROW and 2 Following )    	
  ,sum(unitprice*quantity)
		OVER(ORDER BY orderid ROWS Between 2 FOLLOWING and 3 Following )    
  ,sum(unitprice*quantity)
		OVER(ORDER BY orderid ROWS Between 2 Preceding and 2 Following ) 
from [order details]




  ,SUM(Col2) OVER(ORDER BY Col1 RANGE UNBOUNDED PRECEDING) "Range" 
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS UNBOUNDED PRECEDING) "Rows"   
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between CURRENT ROW and 2 Following )     
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between 2 FOLLOWING and 3 Following )    
  ,SUM(Col2) OVER(ORDER BY Col1 ROWS Between 2 Preceding    and 2 Following ) 


select orderid, sum(unitprice*quantity)
over (partition by orderid order by productid ROWS UNBOUNDED PRECEDING) 
from [order details]


