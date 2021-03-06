/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
       [OrderStatusId]
      ,[OrderTypeId]
      ,[Available2OrderStatusId]
      ,[DisplayOrder]
	  ,os.id as orderstatusid
	  ,os.[StatusName]
	  ,ot.[OrderTypeName]
  FROM [Tradewise].[dbo].[OrderStatus_OrderType_Mapping] oom
  left join [Tradewise].[dbo].[OrderType] ot on ot.Id=oom.OrdertypeId
  left join [Tradewise].[dbo].[OrderStatus] os on os.Id=oom.OrderStatusId 