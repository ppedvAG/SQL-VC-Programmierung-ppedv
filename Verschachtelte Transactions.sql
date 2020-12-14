--################# TRANSACTIONS
--Transactions werden mit einem Begin Tran /Transaction eingeleitet
--Transactionen können am Ende entweder
--bestätigt ( commited )werden 
--oder alle Änderungen zurückgesetzt werden (rollback)

--Verschachtelte Transactions
--Transactions können verschachtelt werden
--Grundsätzlich gilt:
-- dass ein rollback alle Tranactions innerhalb der umfassenden Transaction 
--zurückgesetzt werden
--Ein Commit ohne Angabe schreibt nur die letzte Transaction fest, 
--kann aber durch ein Rollacbk zurückgesetzt werden

--Mit Hilfe von savepoints können allerdings Transactions bis einem 
--bestimmte gespeicherte Transactionspunkt zurückgeführt werden, ohne dass die Transaction komplett zurückgesetzt wird


--erst wenn alle Transactions committed wurden ist die Transacation endgültig fix



--Transactions können  auch markiert werden und oder gespeichert
--Markierte Transactions können bei restore Verfahren behilflich sein, da diese Punkte im 
--Restore Log gefunden werden können
--SavePoint (s.o.) dienen zum rollback für best Transactions innerhalb verschalchtelter Tranactions


--#################





--DemoDaten
use northwind;
GO
drop table Customers2
select * into Customers2 from customers;
GO
select * from customers2


--Beginn der TX
Begin transaction T1 --aüssere TX
update customers2 set city = 'X'
select * from customers2


begin transaction M1 with MARK --innere merkierte TX.. T! ist immer noch offen
update customers2 set city = 'Y'
select * from customers2
save transaction InnerSave --Speichern des Zustands. Ein Rollback kann bis hierhin zurückgeführt werden
select * from customers2
--rollback Tran M1 --würde einen kompletten TX Reset bedeuten

begin transaction M2 with MARK
update customers2 set city = 'Z'
select * from customers2
commit
rollback tran Innersave --Führt TX zum Zeitpunkt des SavePoint InnerSave zurück
rollback 

select * from customers2