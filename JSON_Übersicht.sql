/*
ISJSON (Transact-SQL) testet, ob eine Zeichenfolge gültige JSON-Zeichenfolgen enthält.
JSON_VALUE (Transact-SQL) extrahiert einen Skalarwert aus einer JSON-Zeichenfolge.
JSON_QUERY (Transact-SQL) extrahiert ein Objekt oder ein Array aus einer JSON-Zeichenfolge.
JSON_MODIFY (Transact-SQL) ändert einen Wert in der JSON-Zeichenfolge.
*/

use northwind

DECLARE @json NVARCHAR(MAX);
SET @json = '{"info": {"address": [{"town": "Belgrade"}, {"town": "Paris"}, {"town":"Madrid"}]}}';

select JSON_VALUE(@json,'$.info.address[0].town'); --beginnt bei 0
select JSON_VALUE(@json,'$.info.address[1].town');
select JSON_VALUE(@json,'$.info.address[3].town');


--auch berechnet Spalten möglich
CREATE TABLE dbo.Store
 (
  StoreID INT IDENTITY(1,1) NOT NULL,
  Address VARCHAR(500),
  jsonContent NVARCHAR(4000),
  Longitude AS JSON_VALUE(jsonContent, '$.address[0].longitude'),
  Latitude AS JSON_VALUE(jsonContent, '$.address[0].latitude')
 )


 --JSON_QUERY

DECLARE @jsonQuery NVARCHAR(MAX);
SET @jsonQuery = '{"info": {"address": [{"town": "Belgrade"}, {"town": "Paris"}, {"town":"Madrid"}]}}';
select JSON_QUERY(@jsonQuery,'$.info.address[0]')


SELECT Name, Surname,
  JSON_VALUE(jsonCol, '$.info.address.PostCode') AS PostCode,
  JSON_VALUE(jsonCol, '$.info.address."Address Line 1"') + ' '
  + JSON_VALUE(jsonCol, '$.info.address."Address Line 2"') AS Address,
  JSON_QUERY(jsonCol, '$.info.skills') AS Skills
FROM People
WHERE ISJSON(jsonCol) > 0
  AND JSON_VALUE(jsonCol, '$.info.address.Town') = 'Belgrade'
  AND Status = 'Active'
ORDER BY JSON_VALUE(jsonCol, '$.info.address.PostCode')




SET @json = JSON_MODIFY(@json, '$.info.address[1].town', 'London');
SELECT modifiedJson = @json;


--JSON_MODIFY

declare @jsonCust as nvarchar(max)
Set   @jsonCust = (select top 5 
					Customerid, --as 'KdNr' ,
					Companyname,-- as 'Firma',
					Country,-- as 'Kunde.Land',
					City --as 'Kunde.Stadt'
from northwind.dbo.customers for json path, root('CUSTS'))
select @jsonCust

select JSON_QUERY(@jsonCust,'$.CUSTS[1]')
select JSON_VALUE(@jsonCust,'$.CUSTS[1].Customerid')
select JSON_VALUE(@jsonCust,'$.CUSTS[2].Companyname')


declare @Kunde as nvarchar(max) 
set @Kunde=(select JSON_QUERY(@jsonCust,'$.CUSTS[1]'))
select @Kunde
--JSON_MODIFY

SET @Kunde=JSON_MODIFY(@Kunde,'$.City','Burghausen')
select @kunde

 
 select * from openjson(@jsonCust)

 
 select * from openjson(@Kunde)
 WITH (
		ID nchar(5) '$.Customerid',
		Firma nvarchar(50) '$.Companyname',
		Land nvarchar(50)  '$.Country',
		Stadt nvarchar(50) '$.City'
		)

--JSON als Tabelle wiedergeben

declare @jsonCust as Nvarchar(max)
Set   @jsonCust = (select top 5 
					Customerid, --as 'KdNr' ,
					Companyname,-- as 'Firma',
					Country,-- as 'Kunde.Land',
					City --as 'Kunde.Stadt'
from northwind.dbo.customers for json path)

select * from openjson(@jsonCust)
 WITH (
		ID nchar(5) '$.Customerid',
		Firma nvarchar(50) '$.Companyname',
		Land nvarchar(50)  '$.Country',
		Stadt nvarchar(50) '$.City'
		)



--JSON INDEX
CREATE TABLE JsonCollection
 (
  id INT IDENTITY CONSTRAINT PK_JSON_ID PRIMARY KEY,
  json NVARCHAR(MAX) COLLATE SERBIAN_CYRILLIC_100_CI_AI
  CONSTRAINT [Content should be formatted as JSON]
  CHECK(ISJSON(json)>0)
 )


 INSERT INTO JsonCollection
VALUES
(N'{"name":"Иво","surname":"Андрић"}'),
(N'{"name":"Андрија","surname":"Герић"}'),
(N'{"name":"Владе","surname":"Дивац"}'),
(N'{"name":"Новак","surname":"Ђоковић"}'),
(N'{"name":"Предраг","surname":"Стојаковић"}'),
(N'{"name":"Михајло","surname":"Пупин"}'),
(N'{"name":"Борислав","surname":"Станковић"}'),
(N'{"name":"Владимир","surname":"Грбић"}'),
(N'{"name":"Жарко","surname":"Паспаљ"}'),
(N'{"name":"Дејан","surname":"Бодирога"}'),
(N'{"name":"Ђорђе","surname":"Вајферт"}'),
(N'{"name":"Горан","surname":"Бреговић"}'),
(N'{"name":"Милутин","surname":"Миланковић"}'),
(N'{"name":"Никола","surname":"Тесла"}')
GO
  
ALTER TABLE JsonCollection
ADD vName AS JSON_VALUE(json,'$.name')

CREATE INDEX idx_name
ON JsonCollection(vName)



SELECT JSON_VALUE(json,'$.name'),*
FROM JsonCollection
ORDER BY JSON_VALUE(json,'$.name')


Select ID,vName from JsonCollection where json_value(json,'$.name')='Иво'

Select ID,vName from JsonCollection where id=1