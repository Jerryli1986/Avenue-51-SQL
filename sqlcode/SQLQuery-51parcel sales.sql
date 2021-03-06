/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      [ReferenceOrderId]
      ,[OrderTypeId]
      ,[TrackingNumber]
      ,O.[StoreId]
      ,[OrderStatusId]
      ,[ShippingStatusId]
      ,[CurrencyRate]
      ,[OrderSubtotal]
      ,[OrderDiscount]
      ,[OrderTotal]
      ,[RefundedAmount]
      ,[OrderReceivable]
      ,[PurchaseOrderNumber]
      ,[PaidDateUtc]
      ,O.[Deleted]
      ,O.[CreatedOnUtc]
	  ,OI.[ProductName]
      ,OI.[UnitPrice]
      ,OI.[Quantity]
      ,OI.[DiscountAmount]
      ,OI.[SubTotal]
      ,B.Name as Brand
	  ,S.Name
  FROM [Tradewise].[dbo].[Order] O
  left join [Tradewise].[dbo].[OrderItem] OI on OI.OrderId=O.Id
  left join Tradewise.[dbo].[Product] P on P.Id=OI.ProductId
  left join [Tradewise].[dbo].[Brand] B on B.Id=P.BrandId
  left join [Tradewise].[dbo].Store S  on O.[StoreId]=S.Id
  where O.Deleted=0 and [OrderStatusId]<>-1
  and O.[CreatedOnUtc]>'2015-07-15'
  and O.[StoreId]=7
