--Evtl möchte man wissen, ob innerhalb der Prozedur ein 
--gewisser Zustand eingetreten ist
--das wäre als OUTPUT, aber noch einfacher per STATUSCODE 
--realisierbar

use tempdb;

create table tbltest3 (id int, wert varchar(50));
GO

insert into tbltest3 values (1,'xy'),(2,'xy'),(3,'xy');
GO

Alter proc gptbltest3 @par1 int
as
If (select count(*) from tbltest3) > @par1
	Begin
		update tbltest3 set wert = 'XYZ' where id = @par1
		Return 1
	END
else
	begin
		RETURN 0
	end

--statusCode per Übergabe als exec @Statusvariable= Proc mit Parameter
declare @myStatus as int
exec @myStatus=gptbltest3 5
select @mystatus