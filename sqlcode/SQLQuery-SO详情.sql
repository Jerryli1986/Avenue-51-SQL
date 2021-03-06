/****** Script for SelectTopNRows command from SSMS  ******/
if object_id('tempdb..#temp5000') is not null Begin
     drop table #temp5000
 End

SELECT O.[Id]
      ,[ReferenceOrderId]
      ,[OrderTypeId]
      ,O.[StoreId]
      ,[StoreCustomerId]
      ,[OrderStatusId]
      ,[ShippingStatusId]
      ,[OrderSubtotal]
      ,[OrderTotal]
      ,[RefundedAmount]    
      ,[OrderReceivable]
      ,O.[CreatedOnUtc]
      ,OI.[ProductId]
      ,[UnitPrice]
      ,OI.[Quantity]
      ,[DiscountAmount]
      ,[SubTotal]
      ,[ItemWeight]
      ,[ProductName]
      ,OI.[ProductCost]
      ,OI.[ProductUnitTax]
      ,OI.[ProductAddon]
      ,OI.[ProductNumber]
	  ,B.Name
  FROM [Tradewise].[dbo].[Order]  O
  LEFT JOIN [Tradewise].[dbo].[OrderItem] AS OI ON OI.[OrderId]=O.ID
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.Id=OI.[ProductId]  AND P.ProductTypeId=3 --AND P.STOREID=12,4
  LEFT JOIN [Tradewise].[dbo].[Brand] B on B.id=P.BrandId
  WHERE [ReferenceOrderId] LIKE 'SOD%' AND [OrderStatusId] IN(330,340,350,360,361,380,390)
     -- and [ReferenceOrderId]='SOD20170419EBEEAC1'
  order by CreatedOnUtc

