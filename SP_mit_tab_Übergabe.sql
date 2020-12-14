use northwind;
GO

create type udtTabKunden as Table
	(
		KDID char(5) primary key,
		Firma varchar(50)
	);
GO


alter proc gp_kundenTab @Tab udtTabKunden READONLY,@par1 varchar(50) 
AS
select * from @tab where Firma like @par1 + '%';
go


declare @interimtab udtTabKunden;

Insert into @interimtab 
select customerid, companyname from customers where country like '%a%'

exec gp_kundenTab @interimtab, 'a'