/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      ShipToCellPhone
      
  FROM [Jerry_DB].[dbo].shipping where  ShipToCellPhone is not null
   
   use Jerry_DB
   update shipping
   set ShipToCellPhone=( select  cast( convert( float,ShipToCellPhone ) as decimal(30,0)) )