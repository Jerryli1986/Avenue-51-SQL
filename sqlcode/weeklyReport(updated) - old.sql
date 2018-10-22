
if object_id('tempdb..#temp500') is not null Begin
     drop table #temp500
 End
 if object_id('tempdb..#temp400') is not null Begin
     drop table #temp400
 End
 -------------------------------------------
Declare @BegDate date
declare @EndDate date
declare @Exchange as float
set @BegDate='2017-05-22'
set @EndDate='2017-05-29'
set @Exchange=8.88

-------------------------------------

DECLARE @WeeklyReport_Jerry table(ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max))
DECLARE @WeeklyReport_1 table(ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max),Totalcost float(2) ,Revenue   float(2) ,Commission float(2),Exchangerate float(2),commissionrate float(2))
declare @ProductId int
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
declare @Totalcost float(2) 
declare @Revenue   float(2)
declare	@Commission float(2)
declare	@Exchangerate float(2)
declare @commissionrate float(2)

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
  FROM [Tmall51Parcel].[dbo].[ProductImport] PI
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.ProductNumber=pi.ProductCode AND (P.STOREID=6) 
  lEFT JOIN [Tradewise].[dbo].[ProductGroup] PG ON PG.[ProductGroupNumber]=PI.ProductCode     --组合商品中其实有些为了修改代码，而不是真正的组合，原子商品中老sku 变新sku，是在组合中改
  LEFT JOIN [Tradewise].[dbo].[Product] P1 ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=p.BrandId
  --Join [Tradewise].[dbo].[shipment] s on s.PurchaseOrderNumber=pi.PurchaseOrderNumber
  WHERE [Paymenttime]>=@BegDate and [Paymenttime]<@EndDate --AND P.STOREID=6 --AND p.name LIKE N'%???????%' --AND buyerid='HXTMLS' 
         AND StatusId<>-1
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

    insert into @WeeklyReport_Jerry values(@ProductId,@Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand,@ProductName, @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId, @Cost, @TrackingNumber)

FETCH NEXT FROM db_cursor
INTO @ProductId, @Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand, @ProductName,  @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId,  @Cost, @TrackingNumber
END

CLOSE db_cursor
DEALLOCATE db_cursor


SELECT WRJ.Paymenttime,  WRJ.PurchaseOrderNumber, WRJ.ProductCode, WRJ.Brand, WRJ.ProductName, WRJ.Payment, WRJ.DiscountFee, WRJ.OrderPayment, WRJ.Quantity, WRJ.StatusId, WRJ.MallCode, PI.buyerId, WRJ.Cost, WRJ.TrackingNumber
into #temp500
FROM @WeeklyReport_Jerry  WRJ
LEFT JOIN (SELECT DISTINCT PurchaseOrderNumber, Buyerid FROM [Tmall51Parcel].[dbo].[ProductImport] ) AS pi ON (PI.PurchaseOrderNumber=WRJ.PurchaseOrderNumber collate Latin1_General_CI_AS)



select P.ProductNumber as ProductCode,
       B.Name  as Brand,
	   P.name as ProductName,
	   P.ProductCost as Cost
 into #temp400
 from [Tradewise].[dbo].[Product] P 
  LEFT JOIN [Tradewise].[dbo].[Brand] B on B.id=P.BrandId



update #temp500
set #temp500.Brand=#temp400.Brand
from #temp500
inner join #temp400 on #temp500.ProductCode=#temp500.ProductCode collate Latin1_General_CI_AS
where #temp500.PurchaseOrderNumber like '%MPD%'

update #temp500
set #temp500.ProductName=#temp400.ProductName
from #temp500
inner join #temp400 on #temp500.ProductCode=#temp400.ProductCode collate Latin1_General_CI_AS
where #temp500.PurchaseOrderNumber like '%MPD%'

update #temp500
set #temp500.Cost=#temp400.Cost
from #temp500
inner join #temp400 on #temp500.ProductCode=#temp400.ProductCode collate Latin1_General_CI_AS
where #temp500.PurchaseOrderNumber like '%MPD%'
---------------------------------------------------------------------------------------------
 --select  * from #temp500  

 ------------------------------

 alter table #temp500
 add Totalcost float(2), 
     Revenue   float(2),
	 Commission float(2),
	 Exchangerate float(2), 
	 Commissionrate float(2)
 ------------------------------

 declare revenue_cursor cursor for
 select * from #temp500
 open reveune_cursor
 fetch next from revenue_cursor into
  @ProductId, 
  @Paymenttime,  
  @PurchaseOrderNumber, 
  @ProductCode, 
  @Brand, 
  @ProductName, 
  @Payment, 
  @DiscountFee, 
  @OrderPayment, 
  @Quantity, 
  @StatusId, 
  @MallCode, 
  @buyerId, 
  @Cost, 
  @TrackingNumber,
  @Totalcost ,
  @Revenue  ,
  @Commission ,
  @Exchangerate ,
  @Commissionrate
WHILE @@FETCH_STATUS = 0
BEGIN
  if @MallCode='JD'
     begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0.03  
	 end
  else if @MallCode='TMall'
    begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0.11  
	 end 
  else if @MallCode='Amazon'
    begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0.08  
	 end 
  else if @MallCode='Meilishuo'
    begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0.03  
	 end
  else if @MallCode='NetEase'
    begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0.05  
	 end
  else if @MallCode='AVE_WWW'
    begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0  
	 end
  else if @MallCode='AVE_JIV'
    begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0 
	 end
  else if @MallCode='AVE_LWS'
    begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0  
	 end
  else if @MallCode='AVE_NUT'
    begin
      set @Exchangerate=@Exchange
	  set @Commissionrate=0  
	 end
  else 
    begin
      set @Exchangerate=1
	  set @Commissionrate=0 
	 end
  
  if @Quantity<>0
    begin
    set @Totalcost=@Quantity*@Cost
    end
  
insert into @WeeklyReport_1 values(@ProductId,@Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand,@ProductName, @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId, @Cost, @TrackingNumber,  @Totalcost ,@Revenue  ,@Commission ,@Exchangerate,@Commissionrate)

FETCH NEXT FROM reveune_cursor
INTO @ProductId, @Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand, @ProductName,  @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId,  @Cost, @TrackingNumber, @Totalcost ,@Revenue  ,@Commission ,@Exchangerate,@Commissionrate
END

CLOSE reveune_cursor
DEALLOCATE reveune_cursor

-----------------------------------------
if object_id('tempdb..#revenue_temp4') is not null Begin
     drop table #revenue_temp4
 End
 if object_id('tempdb..#revenue_temp1') is not null Begin
     drop table #revenue_temp1
 End
  select     [PurchaseOrderNumber], 
             avg(OrderPayment)-avg(DiscountFee) as drafpayment,
             avg([Payment]) as payments, 
		     sum(TotalCost) as totalcosts,
			 sum(Quantity)  as totalquantity,
			 avg([Payment])/sum(Quantity) as avgbyquantity,
			 avg([Payment])/isnull(nullif(sum(TotalCost),0),1) as avgbycost

  into #revenue_temp4 
  from @WeeklyReport_1
  group by [PurchaseOrderNumber] 
  
  select [Paymenttime]
      ,R.[PurchaseOrderNumber]
      ,[ProductCode]
      ,R.[Brand]
      ,[ProductName]
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[Quantity]
      ,[StatusId]
      ,R.[MallCode]
      ,[buyerId]
      ,[Cost]
      ,[TrackingNumber]
      ,[TotalCost]
      ,case when totalcosts=0 then #revenue_temp4.avgbyquantity*R.Quantity
			else #revenue_temp4.avgbycost*R.TotalCost
	        end as  [Revenue]
		,R.Exchangerate
		,[Commissionrate]
	 into #revenue_temp1
	   from @WeeklyReport_1 R
  left join #revenue_temp4 on R.[PurchaseOrderNumber]=#revenue_temp4.PurchaseOrderNumber 

  
 select [Paymenttime]
      ,[PurchaseOrderNumber]
      ,[ProductCode]
      ,[Brand]
      ,[ProductName]
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[Quantity]
      ,[StatusId]
      ,[MallCode]
      ,[buyerId]
      ,[Cost]
      ,[TrackingNumber]
      ,[TotalCost]
	  ,[Revenue]
	  ,isnull([Revenue]*[Commissionrate],0) as [Commission]
	  ,Exchangerate
	  from #revenue_temp1