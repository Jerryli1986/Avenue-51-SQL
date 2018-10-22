﻿

 ------------------------参数--------------
Declare @BegDate date
declare @EndDate date
declare @Exchange as float
set @BegDate='2017-06-12'
set @EndDate='2017-06-19'
set @Exchange=8.80

declare @commission1 as decimal(18,2) 
declare @commission2 as decimal(18,2) 
declare @commission3 as decimal(18,2) 
declare @commission4 as decimal(18,2)
declare @commission5 as decimal(18,2)  
set @commission1=0.03
set @commission2=0.11
set @commission3=0.08
set @commission4=0.03
set @commission5=0.05



----------------------------------------------
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
-------------------------------------
DECLARE @WeeklyReport_0 table(ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max))
DECLARE @WeeklyReport_1 table(ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max),Totalcost decimal(18,2) ,Revenue   decimal(18,2) ,Commission float(2),Exchangerate decimal(18,2),commissionrate decimal(18,2))

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

    insert into @WeeklyReport_0 values(@ProductId,@Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand,@ProductName, @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId, @Cost, @TrackingNumber)

FETCH NEXT FROM db_cursor
INTO @ProductId, @Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand, @ProductName,  @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId,  @Cost, @TrackingNumber
END

CLOSE db_cursor
DEALLOCATE db_cursor

select * into #Report_0 from @WeeklyReport_0

SELECT WRJ.Paymenttime,  WRJ.PurchaseOrderNumber, WRJ.ProductCode, WRJ.Brand, WRJ.ProductName, WRJ.Payment, WRJ.DiscountFee, WRJ.OrderPayment, WRJ.Quantity, WRJ.StatusId, WRJ.MallCode, PI.buyerId, WRJ.Cost, WRJ.TrackingNumber
into #temp500
FROM #Report_0  WRJ
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
 add Totalcost decimal(18,2), 
     Revenue  decimal(18,2),
	 Commission decimal(18,2),
	 Exchangerate decimal(18,2), 
	 Commissionrate decimal(18,2)
 ------------------------------

select 
       [Paymenttime]
      ,[PurchaseOrderNumber]
      ,[ProductCode]
      ,[Brand]
      ,[ProductName]
      ,case when MallCode='JD' then [Payment]/@Exchange 
	        when MallCode='TMall' then [Payment]/@Exchange 
			when MallCode='Amazon' then [Payment]/@Exchange 
			when MallCode='Meilishuo' then [Payment]/@Exchange 
			when MallCode='NetEase' then [Payment]/@Exchange 
			when MallCode='AVE_WWW' then [Payment]/@Exchange 
			when MallCode='AVE_JIV' then [Payment]/@Exchange 
			when MallCode='AVE_LWS' then [Payment]/@Exchange 
			when MallCode='AVE_NUT' then [Payment]/@Exchange 
			else [Payment]
	  end as [Payment]
      ,case when MallCode='JD' then [DiscountFee]/@Exchange 
	        when MallCode='TMall' then [DiscountFee]/@Exchange 
			when MallCode='Amazon' then  [DiscountFee]/@Exchange 
			when MallCode='Meilishuo' then  [DiscountFee]/@Exchange 
			when MallCode='NetEase' then  [DiscountFee]/@Exchange 
			when MallCode='AVE_WWW' then  [DiscountFee]/@Exchange 
			when MallCode='AVE_JIV' then  [DiscountFee]/@Exchange 
			when MallCode='AVE_LWS' then  [DiscountFee]/@Exchange 
			when MallCode='AVE_NUT' then  [DiscountFee]/@Exchange 
			else  [DiscountFee]/1
	  end as [DiscountFee]
      ,case when MallCode='JD' then [OrderPayment]/@Exchange 
	        when MallCode='TMall' then [OrderPayment]/@Exchange 
			when MallCode='Amazon' then  [OrderPayment]/@Exchange 
			when MallCode='Meilishuo' then  [OrderPayment]/@Exchange 
			when MallCode='NetEase' then  [OrderPayment]/@Exchange 
			when MallCode='AVE_WWW' then  [OrderPayment]/@Exchange 
			when MallCode='AVE_JIV' then  [OrderPayment]/@Exchange 
			when MallCode='AVE_LWS' then  [OrderPayment]/@Exchange 
			when MallCode='AVE_NUT' then  [OrderPayment]/@Exchange 
			else  [OrderPayment]/1
	  end as [OrderPayment]
      ,[Quantity]
      ,[StatusId]
      ,[MallCode]
      ,[buyerId]
      ,[Cost]
      ,[TrackingNumber]
      ,isnull([Quantity],0)*isnull([Cost],0) as [TotalCost]
	  ,[Revenue]
	  ,[Commission]
	  ,case when MallCode='JD' then @Exchange 
	        when MallCode='TMall' then @Exchange 
			when MallCode='Amazon' then @Exchange 
			when MallCode='Meilishuo' then @Exchange 
			when MallCode='NetEase' then @Exchange 
			when MallCode='AVE_WWW' then @Exchange 
			when MallCode='AVE_JIV' then @Exchange 
			when MallCode='AVE_LWS' then @Exchange 
			when MallCode='AVE_NUT' then @Exchange 
			else 1
	     end as Exchangerate
	  ,case when MallCode='JD' then  @commission1
	        when MallCode='TMall' then  @commission2
			when MallCode='Amazon' then  @commission3
			when MallCode='Meilishuo' then  @commission4
			when MallCode='NetEase' then  @commission5
			else 0 end as Commissionrate
into #Report_1 from #temp500


  select     [PurchaseOrderNumber], 
             avg(OrderPayment)-avg(DiscountFee) as drafpayment,
             avg([Payment]) as payments, 
		     sum(TotalCost) as totalcosts,
			 sum(Quantity)  as totalquantity,
			 avg([Payment])/sum(Quantity) as avgbyquantity,
			 avg([Payment])/isnull(nullif(sum(TotalCost),0),1) as avgbycost

  into #revenue_temp4 
  from #Report_1
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
	   from #Report_1 R
  left join #revenue_temp4 on R.[PurchaseOrderNumber]=#revenue_temp4.PurchaseOrderNumber 
  
  SET DATEFIRST 1;
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
	  ,DATEADD(week, DATEDIFF(week,DATEADD(dd,-@@datefirst,'1900-01-01'),DATEADD(dd,-@@datefirst,convert(varchar(10), [Paymenttime], 120))), '1900-01-01') 
	    as weekmark
	  from #revenue_temp1
	  order by [Paymenttime]
	 
	

	 --SET DATEFIRST 1;
	 -- select  datediff(ww, DATEADD(dd,-@@datefirst,'2017-06-05'), DATEADD(dd,-@@datefirst,'2017-06-11'))
	 -- select  datediff(ww, DATEADD(dd,0,'2017-06-05'), DATEADD(dd,0,'2017-06-11') )
	 