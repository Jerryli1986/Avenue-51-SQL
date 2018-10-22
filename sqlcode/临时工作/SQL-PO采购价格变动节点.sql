/****** Script for SelectTopNRows command from SSMS  ******/

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
select * from  #temp100
--------------------------------------------------

DECLARE @Pricechange table(CreatedOnUTC datetime, POOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  PurchaseQuantity int,  UnitCost decimal(18,2),Vendor nvarchar(max))
declare @CreatedOnUTC datetime
declare @POOrderNumber varchar(max)
declare @ProductCode varchar(max)
declare @Brand nvarchar(max)
declare @ProductName nvarchar(max)
declare @PurchaseQuantity int
declare @UnitCost decimal(18,2)
declare @Vendor nvarchar(max)

declare db_cursor CURSOR FOR
select [CreatedOnUTC],POOrderNumber,ProductCode,Brand,ProductName,PurchaseQuantity, UnitCost,Vendor from #temp100  
--where ProductCode='CAG-C3'--'AAA16010'
order by  ProductCode,CreatedOnUTC

OPEN db_cursor
FETCH NEXT FROM db_cursor
INTO @CreatedOnUTC,@POOrderNumber,@ProductCode ,@Brand,@ProductName,@PurchaseQuantity,@UnitCost,@Vendor
insert into @Pricechange values(@CreatedOnUTC,@POOrderNumber ,@ProductCode ,@Brand,@ProductName,@PurchaseQuantity,@UnitCost,@Vendor)
		
WHILE @@FETCH_STATUS = 0
BEGIN
    if object_id('tempdb..#temp200') is not null 
        Begin
           drop table #temp200
        End
    if exists (select  [CreatedOnUTC],[POOrderNumber],ProductCode,Brand,[ProductName],[PurchaseQuantity],[UnitCost],Vendor 
			  from #temp100
	          where ProductCode=@ProductCode 
					and  [CreatedOnUTC]<@CreatedOnUTC 
					and [UnitCost]<>@UnitCost
					and  [CreatedOnUTC]=(select max([CreatedOnUTC]) from #temp100 
					                         where ProductCode=@ProductCode 
					                                and  [CreatedOnUTC]<@CreatedOnUTC 
										 )
				)
       begin
	          
			  insert into @Pricechange  values(@CreatedOnUTC,@POOrderNumber,@ProductCode ,@Brand,@ProductName,@PurchaseQuantity,@UnitCost,@Vendor)
			 
	   end
    FETCH NEXT FROM db_cursor
    INTO @CreatedOnUTC,@POOrderNumber ,@ProductCode ,@Brand,@ProductName,@PurchaseQuantity,@UnitCost,@Vendor
END

CLOSE db_cursor
DEALLOCATE db_cursor

select   CreatedOnUTC,POOrderNumber,ProductCode,Brand,ProductName,PurchaseQuantity,UnitCost,Vendor  from @Pricechange  --order by CreatedOnUTC
