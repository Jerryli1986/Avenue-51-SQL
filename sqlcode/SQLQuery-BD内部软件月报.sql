if object_id('tempdb..#result') is not null Begin
				 drop table #result
			 End
create table #result (ProductId int,PurchaseDate datetime,ShippingDate datetime, PurchaseOrderNumber varchar(50), ReferenceOrderId varchar(50), TrackingNumber varchar(50), MallCode varchar(max), ProductCode varchar(max), VendorSKU varchar(max), ProductName nvarchar(max), EnglishName varchar(max), Quantity int, Cost decimal(18,2), Total decimal(18,2), ShipmentStatus nvarchar(max),OrderStatus varchar(max), Brand varchar(50))

declare @ProductId int
declare @PurchaseDate datetime
declare @ShippingDate datetime
declare @PurchaseOrderNumber varchar(50)
declare @ReferenceOrderId varchar(50)
declare @TrackingNumber varchar(50)
declare @MallCode varchar(50)
declare @ProductCode varchar(50)
declare @VendorSKU varchar(50)
declare @ProductName nvarchar(100)
declare @EnglishName varchar(255)
declare @Quantity int
declare @Cost decimal(18,2)
declare @Total decimal(18,2)
declare @ShipmentStatus varchar(50)
DECLARE @OrderStatus varchar(50)
DECLARE @Brand varchar(50)

DECLARE db_cursor CURSOR FOR

SELECT P.id
      ,pi.[Paymenttime]
	  ,PK.[UpdatedOn] as shippingdate
      ,pi.[PurchaseOrderNumber]
	  ,PK.[OrderReference] as referenceorderid
	  ,pi.trackingnumber
	  ,PI.[MallCode]
      ,Case pi.ProductCode when 'PAI-010-1' THEN 'PAI-010'  
	       ELSE CAST(ISNULL(P1.ProductNumber, PI.ProductCode)  AS varchar(max)) END AS ProductCode
      ,p.sku
	  ,P.name
      ,p.[ProductEnglishName]
      ,pi.[Quantity]
	  ,P.ProductCost
	  ,pi.quantity*p.productcost
	  ,PK.[StatusId] as shippingstatusid 
	  ,pi.StatusId
	  ,b.name AS Brand
  FROM [Tmall51Parcel].[dbo].[ProductImport] pi
  LEFT JOIN [Tradewise].[dbo].[Product] P WITH(NOLOCK) ON P.ProductNumber=pi.ProductCode AND (P.STOREID=6) 
  lEFT JOIN [Tradewise].[dbo].[ProductGroup] PG WITH(NOLOCK) ON PG.[ProductGroupNumber]=PI.ProductCode     --组合商品中其实有些为了修改代码，而不是真正的组合，原子商品中老sku 变新sku，是在组合中改
  LEFT JOIN [Tradewise].[dbo].[Product] P1 WITH(NOLOCK) ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=p.BrandId
  left join [Tmall51Parcel].[dbo].[PackageDetails] PD on PD.[ProductImportId]=PI.Id
  left join [Tmall51Parcel].[dbo].[Package] PK on PK.Id=PD.[PackageId]
  
  where b.Comment like '%BD%'
       -- and b.name like 'Billingham'
       --  (b.Comment='BD-PO' OR  b.Comment='BD-SO') /*and b.[BrandCode]='LLC' */
        and pi.[Paymenttime]>='2017-01-01' and pi.[Paymenttime]<'2017-10-01'  
  --WHERE s.referenceorderid='ORDCN0306004183675'
  order by PK.[UpdatedOn]
OPEN db_cursor
FETCH NEXT FROM db_cursor
INTO @ProductId,@PurchaseDate, @ShippingDate, @PurchaseOrderNumber, @ReferenceOrderId, @TrackingNumber, @MallCode, @ProductCode, @VendorSKU, @ProductName, @EnglishName, @Quantity, @Cost, @Total, @ShipmentStatus,@OrderStatus,@Brand

WHILE @@FETCH_STATUS = 0
BEGIN
    if exists (select * from [Tradewise].[dbo].[ProductLog] where ProductId=@ProductId and [UpdatedColumn]=N'ProductCost(??)' and [LoggedOnUtc]<=@PurchaseDate)
    begin
        select top 1 @Cost = cast([OriginalValue] as decimal(18,2)) from [Tradewise].[dbo].[ProductLog] where ProductId=@ProductId and [UpdatedColumn]=N'ProductCost(??)' and [LoggedOnUtc]<=@PurchaseDate order by Id desc
        if @Cost>0
            set @Total = @Cost * @Quantity
    end
	insert into #result values(@ProductId,@PurchaseDate, @ShippingDate, @PurchaseOrderNumber, @ReferenceOrderId, @TrackingNumber, @MallCode, @ProductCode, @VendorSKU, @ProductName, @EnglishName, @Quantity, @Cost, @Total, @ShipmentStatus,@OrderStatus,@Brand)

FETCH NEXT FROM db_cursor
INTO @ProductId,@PurchaseDate, @ShippingDate, @PurchaseOrderNumber, @ReferenceOrderId, @TrackingNumber, @MallCode, @ProductCode, @VendorSKU, @ProductName, @EnglishName, @Quantity, @Cost, @Total, @ShipmentStatus,@OrderStatus,@Brand
END

CLOSE db_cursor
DEALLOCATE db_cursor

SELECT PurchaseDate, 
       ShippingDate, 
	   PurchaseOrderNumber, 
	   ReferenceOrderId, 
	   TrackingNumber, 
	   MallCode, 
	   ProductCode, 
	   VendorSKU, 
	   ProductName, 
	   EnglishName, 
	   Quantity, 
	   Cost,
	   Total,
	   OS.[StatusName] as ShipmentStatus, 
	   OrderStatus,
	   Brand

FROM #result 
left join [Tradewise].[dbo].[OrderStatus]  OS on  #result.ShipmentStatus=OS.Id
WHERE OrderStatus<>-1 
      and ShipmentStatus<>40
ORDER BY PurchaseDate




