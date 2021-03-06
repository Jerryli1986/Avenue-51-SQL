/****** Script for SelectTopNRows command from SSMS  ******/
/*SELECT
       [ShipmentItemDetails].[ShipmentId]
      ,[ShipmentItemDetails].[ShipmentItemId]
      ,[ShipmentItemDetails].[ProductId]
      ,[ShipmentItemDetails].[ProductName]
      ,[ShipmentItemDetails].[ProductEnglishName]
      ,[ShipmentItemDetails].[UnitPrice]
      ,[ShipmentItemDetails].[Quantity]
      ,[ShipmentItemDetails].[UnitWeight] 
      ,[ShipmentItemDetails].[MallCode]
	  ,[Shipment].[TrackingNumber]
  FROM [TradewiseFromCN].[dbo].[ShipmentItemDetails]
 left join [TradewiseFromCN].[dbo].[Shipment] on [ShipmentItemDetails].[ShipmentId]=[Shipment].[Id]
 where [ShipmentItemDetails].[MallCode]='TMall' 
 and [Shipment].PaidDateUtc>='2016-04-01' 
 and [Shipment].PaidDateUtc<'2017-04-01'
 and  [ShipmentItemDetails].[ProductEnglishName] like '%Grow Gorgeous%'
 
 SELECT
       [ShipmentItemDetails].[ProductName]
      ,[ShipmentItemDetails].[ProductEnglishName]
      ,[ShipmentItemDetails].[UnitPrice]
      ,[ShipmentItemDetails].[Quantity]
      ,[ShipmentItemDetails].[UnitWeight] 
      ,[ShipmentItemDetails].[MallCode]
	  ,[Shipment].[TrackingNumber]
	  , case when  [Shipment].[TrackingNumber] like '%BE%' then  'BE' 
	         when  [Shipment].[TrackingNumber] like '%EK%' then  'EK' end as typeparcels
  FROM [TradewiseFromCN].[dbo].[ShipmentItemDetails]
 left join [TradewiseFromCN].[dbo].[Shipment] on [ShipmentItemDetails].[ShipmentId]=[Shipment].[Id]
 where [ShipmentItemDetails].[MallCode]='TMall' 
 and [Shipment].PaidDateUtc>='2016-04-01' 
 and [Shipment].PaidDateUtc<'2017-04-01'
 and  [ShipmentItemDetails].[ProductEnglishName] like '%Lily%'
 */
  SELECT
    
       [ShipmentItemDetails].[ProductName]
       ,[ShipmentItemDetails].[ProductEnglishName]
      ,[ShipmentItemDetails].[UnitPrice]
      ,[ShipmentItemDetails].[Quantity]
      ,[ShipmentItemDetails].[UnitWeight] 
      ,[ShipmentItemDetails].[MallCode]
	  ,[Shipment].[TrackingNumber]
	  
	  , case when  [Shipment].[TrackingNumber] like '%BE%' then  'BE' 
	         when  [Shipment].[TrackingNumber] like '%EK%' then  'EK' 
			 when  [Shipment].[TrackingNumber] like '%TX%' then  'TX' end as typeparcels
      ,cast(convert(varchar(15),[Shipment].[PaidDateUtc],110)  as date) as [PaidDateUtc]
  FROM [TradewiseFromCN].[dbo].[ShipmentItemDetails]
 left join [TradewiseFromCN].[dbo].[Shipment] on [ShipmentItemDetails].[ShipmentId]=[Shipment].[Id]
 where [ShipmentItemDetails].[MallCode]='TMall' 
 and [Shipment].PaidDateUtc>='2016-04-01' 
 and [Shipment].PaidDateUtc<'2017-04-01'
 and [Shipment].[TrackingNumber] is not null
 --and [ShipmentItemDetails].[ProductEnglishName] like '%Grow Gorgeous%'
 --and [ShipmentItemDetails].[ProductEnglishName] like '%waitrose%'
 --and [ShipmentItemDetails].[ProductEnglishName] like '%Lily%'
 --and [ShipmentItemDetails].[ProductEnglishName] like '%Nanny%'
 and [ShipmentItemDetails].[ProductEnglishName] like '%DIAMONDSTYLE%'
 
 