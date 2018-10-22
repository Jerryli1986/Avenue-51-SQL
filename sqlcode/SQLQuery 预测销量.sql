

if object_id('tempdb..#temp600') is not null Begin
     drop table #temp600
 End
if object_id('tempdb..#temp500') is not null Begin
     drop table #temp500
 End
 if object_id('tempdb..#temp400') is not null Begin
     drop table #temp400
 End

 if object_id('tempdb..#revenue_temp4') is not null Begin
     drop table #revenue_temp4
 End
 if object_id('tempdb..#revenue_temp1') is not null Begin
     drop table #revenue_temp1
 End
 --------
  if object_id('tempdb..#Report_0') is not null Begin
     drop table #Report_0
 End
 if object_id('tempdb..#Report_1') is not null Begin
     drop table #Report_1
 End
 --------------------------------add MPD from Order-----------
Declare @BegDate date
declare @EndDate date
declare @Exchange as float
set @BegDate='2015-08-07'
set @EndDate='2017-08-14'
set @Exchange=8.9

-------------------------------------
DECLARE @WeeklyReport_0 table(ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max))
DECLARE @WeeklyReport_1 table(ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max),Totalcost decimal(18,2) ,Revenue   decimal(18,2) ,Commission float(2),Exchangerate decimal(18,2),commissionrate decimal(18,2))
--DECLARE @#temp600       table(Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max))

Declare @ProductId int
DECLARE @Paymenttime datetime
DECLARE @PurchaseOrderNumber varchar(max)
DECLARE @ProductCode nvarchar(max)
DECLARE @Brand nvarchar(max)
DECLARE @ProductName nvarchar(max)
DECLARE @Payment decimal(18,2)
DECLARE @DiscountFee decimal(18,2)
DECLARE @OrderPayment decimal(18,2)
DECLARE @Quantity int
DECLARE @StatusId int
DECLARE @MallCode varchar(max)
DECLARE @buyerId nvarchar(max)
DECLARE @Cost decimal(18,2)
DECLARE @TrackingNumber varchar(max)
declare @Totalcost decimal(18,2) 
declare @Revenue   decimal(18,2)
declare	@Commission decimal(18,2)
declare	@Exchangerate decimal(18,2)
declare @commissionrate decimal(18,2)

DECLARE db_cursor CURSOR FOR

SELECT P.id
      ,PaymentTime
      ,PI.[PurchaseOrderNumber]
      ,ISNULL(P1.ProductNumber, PI.ProductCode) AS ProductCode
      ,b.name
	  ,P.name
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,PI.[Quantity]
      ,[StatusId]
      ,[MallCode]
      ,[buyerId]   
	  ,P.ProductCost
	  ,pi.trackingnumber
  FROM [Tmall51Parcel].[dbo].[ProductImport]  PI WITH(NOLOCK)
  LEFT JOIN [Tradewise].[dbo].[Product] P WITH(NOLOCK) ON P.ProductNumber=pi.ProductCode AND (P.STOREID=6) 
  lEFT JOIN [Tradewise].[dbo].[ProductGroup] PG WITH(NOLOCK) ON PG.[ProductGroupNumber]=PI.ProductCode     --组合商品中其实有些为了修改代码，而不是真正的组合，原子商品中老sku 变新sku，是在组合中改
  LEFT JOIN [Tradewise].[dbo].[Product] P1 WITH(NOLOCK) ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
  LEFT JOIN [Tradewise].[dbo].[Brand] b WITH(NOLOCK) on b.id=p.BrandId
  --Join [Tradewise].[dbo].[shipment] s WITH(NOLOCK) on s.PurchaseOrderNumber=pi.PurchaseOrderNumber
  WHERE [Paymenttime]>=@BegDate and [Paymenttime]<@EndDate AND P.STOREID=6 --AND p.name LIKE N'%???????%' --AND buyerid='HXTMLS' 
         AND StatusId<>-1
		and [buyerId] not in ('51parcel-linda','51parcel-buddy')
		and [buyerId] not like N'测试%'
		and mallcode<>'TmallDYBWG'
		--and mallcode='WebAPI_51taouk.com'
		--and mallcode='WebAPI_Daifa.51Parcel.com'
		and P1.ProductNumber in ('NNC-N1','NNC-N3','HIP-H1','HIP-H2','HIP-H3') or  PI.ProductCode in ('NNC-N1','NNC-N3','HIP-H1','HIP-H2','HIP-H3')
  ORDER BY [Paymenttime] ASC

OPEN db_cursor
FETCH NEXT FROM db_cursor
INTO @ProductId, @Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand, @ProductName, @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId, @Cost, @TrackingNumber
WHILE @@FETCH_STATUS = 0
BEGIN

    if exists (select * from [Tradewise].[dbo].[ProductLog] where ProductId=@ProductId and [UpdatedColumn]=N'ProductCost(??)' and [LoggedOnUtc]<=@Paymenttime)
    begin
        select top 1 @Cost = cast([OriginalValue] as decimal(18,2)) from [Tradewise].[dbo].[ProductLog] where ProductId=@ProductId and [UpdatedColumn]=N'ProductCost(??)' and [LoggedOnUtc]<=@Paymenttime order by Id desc
        
    end
	if @ProductCode='YMZA1'
	   set @ProductCode='APT-A1'
    else if @ProductCode='YMZA2'
	   set @ProductCode='APT-A2'
	else if @ProductCode='YMZA3'
	   set @ProductCode='APT-A3'
	else if @ProductCode='YMZA4'
	   set @ProductCode='APT-A4'
	else if @ProductCode='YMZC1'
	   set @ProductCode='CAG-C1'
	else if @ProductCode='YMZC2'
	   set @ProductCode='CAG-C2'
	else if @ProductCode='YMZC3'
	   set @ProductCode='CAG-C3'
	 else if @ProductCode='YMZC4'
	   set @ProductCode='CAG-C4'

	IF @BuyerId='HXTMLS' 
	Begin
	 set @Mallcode='Meilishuo'
	End

    insert into @WeeklyReport_0 values(@ProductId,@Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand,@ProductName, @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId, @Cost, @TrackingNumber)

FETCH NEXT FROM db_cursor
INTO @ProductId, @Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand, @ProductName,  @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId,  @Cost, @TrackingNumber
END

CLOSE db_cursor
DEALLOCATE db_cursor

select *
  
into #Report_0 from @WeeklyReport_0

SELECT WRJ.Paymenttime,  WRJ.PurchaseOrderNumber, WRJ.ProductCode, WRJ.Brand, WRJ.ProductName, WRJ.Payment, WRJ.DiscountFee, WRJ.OrderPayment, WRJ.Quantity, WRJ.StatusId, WRJ.MallCode, PI.buyerId, WRJ.Cost, WRJ.TrackingNumber
into #temp500
FROM #Report_0  WRJ
LEFT JOIN (SELECT DISTINCT PurchaseOrderNumber, Buyerid FROM [Tmall51Parcel].[dbo].[ProductImport] ) AS pi ON (PI.PurchaseOrderNumber=WRJ.PurchaseOrderNumber collate Latin1_General_CI_AS)
where WRJ.PurchaseOrderNumber not like '%MPD%'
--select * from #revenue_temp1 where MallCode='Meilishuo' order by Paymenttime

SET DATEFIRST 1
select 
Paymenttime,  
PurchaseOrderNumber, 
ProductCode, 
Brand, 
ProductName, 
--Payment, 
--DiscountFee, 
--OrderPayment, 
Quantity, 
StatusId, 
MallCode, 
--buyerId, 
--Cost, 
TrackingNumber ,
DATEADD(week, DATEDIFF(week,DATEADD(dd,-@@datefirst,'1900-01-01'),DATEADD(dd,-@@datefirst,convert(varchar(10), Paymenttime, 120))), '1900-01-01') as weeks
from #temp500
	