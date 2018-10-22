if object_id('tempdb..#temp100') is not null 
Begin
     drop table #temp100
End

declare @Beg date
declare @End date
set @Beg='2017-01-01'
set @End='2017-09-01'
--PO
--- 所有采购过商品的价格变动情况，需要时间节点，各个商品的实际出货时长，各个产品采购总金额，时间节点，
--各个供应商采购过的产品和采购金额，需要时间节点
SELECT 
      [SOOrderNumber]
      ,[POOrderNumber]
      ,[SupplierId]
      ,PO.[StatusId]
      ,PO.[CreatedOnUTC]
      ,[CreatedBy]
      ,[PaidOnUTC]
      ,[ApprovedOnUTC]
      ,[ApprovedBy]
      ,[ExpectedDeliveryOnUTC]
      ,PO.[Notes]
	  ,POI.[ProductName]
	  ,POI.[ProductCode]
      ,POI.[UnitCost]
      ,POI.[PurchaseQuantity]
      ,POI.[ReceivedQuantity]
      ,POI.[DamageCount]
      ,POI.[IsOrderPerCase]
      ,POI.[PurchaseCaseNumber]
	  ,isnull(V.VendorName,M.[MerchantName]) as Vendor
	  ,B.Name as Brand
	  --,P.ProductCost 
	  ,case when POI.[IsOrderPerCase]=1 then POI.[UnitCost]/(POI.[PurchaseQuantity]/POI.[PurchaseCaseNumber])*POI.[PurchaseQuantity] 
	        else POI.[UnitCost]*POI.[PurchaseQuantity] end
			as Subtotal
  into #temp100
  FROM [Tradewise].[dbo].[POOrder]  PO
  LEFT JOIN [Tradewise].[dbo].[POOrderItem] AS POI ON POI.[POOrderId]=PO.ID
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.ProductNumber=POI.[ProductCode]  AND P.ProductTypeId=3 AND P.STOREID=6
  LEFT JOIN [Tradewise].[dbo].[Brand] B on B.id=P.BrandId
  left join [Tradewise].[dbo].[Vendor] V on V.Id=PO.SupplierId
  left join [Tradewise].[dbo].[Merchant] M on M.Id+100000=PO.SupplierId
  where PO.POOrderNumber like '%PO%'
        and PO.[StatusId]<>-1
		and PO.[CreatedOnUTC]>=@Beg
		and PO.[CreatedOnUTC]<@End
		and SOOrderNumber =''

select * from  #temp100 where 
--------------------------------------------------
