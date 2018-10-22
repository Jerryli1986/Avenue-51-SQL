/****** Script for SelectTopNRows command from SSMS  ******/

if object_id('tempdb..#temp100') is not null 
Begin
     drop table #temp100
End

declare @Beg date
declare @End date
set @Beg='2017-06-01'
set @End='2017-07-01'
--PO 月报
--created, received,finished
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
	  ,P.ProductCost 
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

--PO created
select count(distinct [POOrderNumber])as CreatedPO,
       sum(PurchaseQuantity) as CreatedSumquantity,
       sum(case when PurchaseCaseNumber=0 then [UnitCost]*PurchaseQuantity
	                                  else [UnitCost]*[PurchaseCaseNumber] end) as CreatedSum from  #temp100
--------------------------------------------------

--PO received
select count(distinct [POOrderNumber])as ReceivedPO,
       sum(ReceivedQuantity) as ReceivedSumquantity,
       sum(case when PurchaseCaseNumber=0 then [UnitCost]*ReceivedQuantity  
	                                  else [UnitCost]*(ReceivedQuantity /(PurchaseQuantity/[PurchaseCaseNumber])) end) as ReceivedSum from  #temp100
									  where ReceivedQuantity<>0

--PO finished
select count(distinct [POOrderNumber])as FinishedPO,
       sum(ReceivedQuantity) as ReceivedSumquantity,
       sum(case when PurchaseCaseNumber=0 then [UnitCost]*ReceivedQuantity  
	                                  else [UnitCost]*(ReceivedQuantity /(PurchaseQuantity/[PurchaseCaseNumber])) end) as FinishedSum from  #temp100
									  where StatusId=41
