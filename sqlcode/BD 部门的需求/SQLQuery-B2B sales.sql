/****** Script for SelectTopNRows command from SSMS  ******/
declare @Beg date
declare @End date
set @Beg='2017-01-01'
set @End='2017-09-01'

-- 在5月份之前可能没有分状态


 if object_id('tempdb..#temp100') is not null Begin
     drop table #temp100
 End
SELECT  
     --OL.[Id]
     --  OL.[OrderId]
      OL.[ReferenceOrderId]
    --  ,OL.[OrderTypeId]
    --  ,OL.[TrackingNumber]
    --  ,OL.[StoreId]
    --  ,OL.[WarehouseId]
    -- ,OL.[StoreCustomerId]
      ,OL.[OrderStatusId]
    -- ,OL.[ShippingStatusId]

    --  ,OL.[CurrencyRate]
      ,OL.[OrderSubtotal]
      ,OL.[OrderSubTotalDiscount]
      ,OL.[OrderDiscount]
    --  ,OL.[OrderCouponDiscount]
     -- ,OL.[OrderCouponCode]
     -- ,OL.[OrderShipping]
     -- ,OL.[OrderShippingDiscount]
      ,OL.[OrderTotal]
      ,OL.[RefundedAmount]
      ,OL.[OrderReceivable]
    --  ,OL.[PurchaseOrderNumber]
    -- ,OL.[PaidDateUtc]
      ,OL.[Deleted]
      --,OL.[UpdatedBy]
      ,OL.[UpdatedOnUtc]
     -- ,OL.[CreatedOnUtc]
	--  ,OI.[ProductId]
	  ,OI.[Quantity]
	  ,OI.[UnitPrice]
	  ,OI.[ProductCost]
	  ,OI.[ProductUnitTax]
      ,OI.[ProductAddon]
      ,OI.[ProductNumber]
	  ,OI.[DiscountAmount]
      ,OI.[SubTotal]
	  ,B.Name  as Brand
  into #temp100
  FROM [Tradewise].[dbo].[OrderLog] OL
  left join [Tradewise].[dbo].[Order]  O  ON O.Id=OL.OrderId
  LEFT JOIN [Tradewise].[dbo].[OrderItem] AS OI ON OI.[OrderId]=O.ID
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.Id=OI.[ProductId]  AND P.ProductTypeId=3 --AND P.STOREID=12,4
  LEFT JOIN [Tradewise].[dbo].[Brand] B on B.id=P.BrandId
  where OL.ReferenceOrderId like '%SOD%'
        and OL.[Deleted]=0
        and OL.[OrderStatusId] in (360)
		and OL.[UpdatedOnUtc]>=@Beg
		and OL.[UpdatedOnUtc]<@End
		and B.Name in ('Zatchels')
		--,'thisworks','Lily charmed','MARVEL')
	 


select * from #temp100
--select Brand, sum([SubTotal]) from #temp100 group by Brand