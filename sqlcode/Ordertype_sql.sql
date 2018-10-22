/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [OrderStatusId]
      ,[OrderTypeId]
      ,[Available2OrderStatusId]
	  ,[Tradewise].[dbo].[OrderStatus].[StatusName]
  FROM [Tradewise].[dbo].[OrderStatus_OrderType_Mapping]
  left join [Tradewise].[dbo].[OrderStatus] 
  on [OrderStatus_OrderType_Mapping].OrderStatusId=[OrderStatus].Id
  where [OrderTypeId]=188