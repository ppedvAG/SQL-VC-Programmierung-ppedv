USE AdventureWorks 
GO

-- Variable mit XML erstellen
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

-- Daten l�schen mit der delete-Methode
SET @OrderDetails.modify('
delete /Root/OrderDetail[@OrderDetailID = 1]')



-- Daten einf�gen mit der insert-Methode
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

SET @OrderDetails.modify('
insert <OrderDetail OrderDetailID="3"/>
into (/Root)[1]') 

select @OrderDetails


-- Daten am Anfang einf�gen mit insert/first
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

SET @OrderDetails.modify('
insert <OrderDetail OrderDetailID="2"/>
as first
into (/Root)[1]') 

-- Daten l�schen mit der delete-Methode
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

SET @OrderDetails.modify('
delete /Root/OrderDetail[@OrderDetailID = 1]')
select @OrderDetails


-- Daten �ndern mit der replace value of-Methode
DECLARE @OrderDetails xml
SET @OrderDetails = 
'<Root>
	<OrderDetail OrderDetailID="1"/>
	<OrderDetail OrderDetailID="2"/>
</Root>'

SET @OrderDetails.modify('
replace value of (/Root/OrderDetail/@OrderDetailID)[1]
with 100')

select @OrderDetails