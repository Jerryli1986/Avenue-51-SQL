/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [Username]
      ,[StatusId]
	  ,OS.[StatusName]
      ,[CreatedOn]
      ,[CreatedBy]
      ,[UpdatedOn]
      ,[UpdatedBy]
      ,[OrderReference]
      ,[TrackingNumber]
     -- ,[PackTime]
     -- ,[PackOperator]
  FROM [Tmall51Parcel].[dbo].[PackageLog] PL
  left join [Tradewise].[dbo].[OrderStatus]  OS on  PL.[StatusId]=OS.Id
  where [OrderReference]='ORDCN0904005950237'
 --where TrackingNumber like 'BE585512783UK'
  order by [UpdatedOn]