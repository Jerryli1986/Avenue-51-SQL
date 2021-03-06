/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
    
      [StoreId]
      ,[StoreCustomerId]
      ,[PurchaseOrderNumber]
     
      ,[ExchangeRate]
      ,[PackageType]
      ,[ServiceProviderId]
      ,[UKServiceProviderId]
      ,[ShipFromName]


    
    
  FROM [TradewiseFromCN].[dbo].[Shipment] 
	  where ShipFromName in 
	       (select top  3 ShipFromName from [TradewiseFromCN].[dbo].[Shipment] 
	        where ShipFromName in  (select ShipFromName from [TradewiseFromCN].[dbo].[Shipment] 
	                                group by StoreCustomerId 
			                         having count(StoreCustomerId)>100 )
			group by ShipFromName
			)
  order by StoreCustomerId  asc