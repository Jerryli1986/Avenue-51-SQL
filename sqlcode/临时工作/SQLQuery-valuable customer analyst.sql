
if object_id('tempdb..#temp800') is not null Begin
     drop table #temp800
 End
if object_id('tempdb..#temp700') is not null Begin
     drop table #temp700
 End

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
set @BegDate='2017-01-01'
set @EndDate='2017-09-01'
set @Exchange=8.8

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
  WHERE [Paymenttime]>=@BegDate and [Paymenttime]<@EndDate 
        AND P.STOREID=6 --AND p.name LIKE N'%???????%' --AND buyerid='HXTMLS' 
        AND StatusId<>-1
		and [buyerId] not in ('51parcel-linda','51parcel-buddy')
		and [buyerId] not like N'测试%'
		and mallcode<>'TmallDYBWG'
		--and b.name in ('Zatchels','thisworks','Lily charmed','MARVEL')
		--and PI.ProductCode='APT-AP2'
		--and mallcode='WebAPI_51taouk.com'
		and mallcode='TMall'
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
where WRJ.PurchaseOrderNumber not like '%MPD%'
--------No----MPD from Order---------

---------------------------------------------------------------------------------------------

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
			when MallCode='Meilishuo' then [Payment]
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
			when MallCode='Meilishuo' then  [DiscountFee] 
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
			when MallCode='Meilishuo' then  [OrderPayment] 
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
			when MallCode='Meilishuo' then 1
			when MallCode='NetEase' then @Exchange 
			when MallCode='AVE_WWW' then @Exchange 
			when MallCode='AVE_JIV' then @Exchange 
			when MallCode='AVE_LWS' then @Exchange 
			when MallCode='AVE_NUT' then @Exchange 
			else 1
	     end as Exchangerate
	  ,case when MallCode='JD' then 0.03
	        when MallCode='TMall' then 0.116
			when MallCode='Amazon' then 0.08
			when MallCode='Meilishuo' then 0.03 
			when MallCode='NetEase' then 0.05
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
  
  
















/*
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

*/
	 select 
	   [buyerId]
	   ,sum([Revenue]) as Totalrevenue
	   ,sum([Quantity]) as TotalQuantity
	   ,count(distinct [PurchaseOrderNumber]) as Frequency
	   ,count(distinct [ProductCode]) as SKUs
	   ,min([Paymenttime])    as Firsttime
	   ,max([Paymenttime])    as Lasttime
	  into #temp700
	  from #revenue_temp1
	  where [Brand] like '%Waitrose%'
	  group by [buyerId]
	  order by totalrevenue desc

      select 
	   [buyerId]
	   ,Totalrevenue
	   ,TotalQuantity
	   ,Frequency
	   ,SKUs
	   ,Firsttime
	   ,Lasttime
	   ,case when Totalrevenue>0 and Totalrevenue<=10 then 1 
	         when Totalrevenue>10 and Totalrevenue<=20 then 2 
			 when Totalrevenue>20 and Totalrevenue<=30 then 3 
			 when Totalrevenue>30 and Totalrevenue<=40 then 4 
			 when Totalrevenue>40 and Totalrevenue<=50 then 5 
			 when Totalrevenue>50 and Totalrevenue<=60 then 6 
			 when Totalrevenue>60 and Totalrevenue<=70 then 7 
			 when Totalrevenue>70 and Totalrevenue<=80 then 8 
			 when Totalrevenue>80 and Totalrevenue<=90 then 9 
			 when Totalrevenue>90 and Totalrevenue<=100 then 10 
			 when Totalrevenue>100 and Totalrevenue<=120 then 11 
			 when Totalrevenue>120 and Totalrevenue<=140 then 12 
			 when Totalrevenue>140 and Totalrevenue<=160 then 13 
			 when Totalrevenue>160 and Totalrevenue<=180 then 14 
			 when Totalrevenue>180 and Totalrevenue<=200 then 15 
			 when Totalrevenue>200 and Totalrevenue<=230 then 16 
			 when Totalrevenue>230 and Totalrevenue<=260 then 17 
			 when Totalrevenue>260 and Totalrevenue<=290 then 18
			 when Totalrevenue>290 and Totalrevenue<=330 then 19
			 when Totalrevenue>330  then 20 
			 end as Revenuescore
	   ,case when TotalQuantity>0 and TotalQuantity<=2  then  2
	         when TotalQuantity>2 and TotalQuantity<=4  then  4
	         when TotalQuantity>4 and TotalQuantity<=6  then  6
	         when TotalQuantity>6 and TotalQuantity<=8  then  8
			 when TotalQuantity>8 and TotalQuantity<=10  then  10
			 when TotalQuantity>10 and TotalQuantity<=14  then  12
			 when TotalQuantity>14 and TotalQuantity<=18  then  14
			 when TotalQuantity>18 and TotalQuantity<=25  then  16
			 when TotalQuantity>25 and TotalQuantity<=35  then  18
			 when TotalQuantity>35   then  20
			 end as Quantityscore

	   ,case when Frequency>0 and Frequency<=1  then 4
	         when Frequency>1 and Frequency<=2  then 8
			 when Frequency>2 and Frequency<=3  then 12
			 when Frequency>3 and Frequency<=4  then 14
			 when Frequency>4 and Frequency<=5  then 16
			 when Frequency>5 and Frequency<=6  then 17
			 when Frequency>6 and Frequency<=7  then 18
			 when Frequency>7 and Frequency<=8  then 19
			 when Frequency>8 then 20
			 end as Frequencyscore
	   ,case when  SKUs>0 and  SKUs<=2  then 4
	         when  SKUs>2 and  SKUs<=4  then 8
			 when  SKUs>4 and  SKUs<=6  then 12
			 when  SKUs>6 and  SKUs<=8  then 14
			 when  SKUs>8 and  SKUs<=10  then 16
			 when  SKUs>10 and  SKUs<=12  then 17
			 when  SKUs>12 and  SKUs<=14  then 18
			 when  SKUs>14 and  SKUs<=18  then 19
			 when  SKUs>18   then 20
			 end as SKUscore
       ,case when (Lasttime-Firsttime)>=0 and (Lasttime-Firsttime)<=10 then 4
	         when (Lasttime-Firsttime)>10 and (Lasttime-Firsttime)<=20 then 6
			 when (Lasttime-Firsttime)>20 and (Lasttime-Firsttime)<=30 then 8
			 when (Lasttime-Firsttime)>30 and (Lasttime-Firsttime)<=40 then 10
			 when (Lasttime-Firsttime)>40 and (Lasttime-Firsttime)<=60 then 12
			 when (Lasttime-Firsttime)>60 and (Lasttime-Firsttime)<=90 then 14
			 when (Lasttime-Firsttime)>90 and (Lasttime-Firsttime)<=120 then 16
			 when (Lasttime-Firsttime)>120 and (Lasttime-Firsttime)<=150 then 17
			 when (Lasttime-Firsttime)>150 and (Lasttime-Firsttime)<=180 then 18
			 when (Lasttime-Firsttime)>180 and (Lasttime-Firsttime)<=210 then 19
			 when (Lasttime-Firsttime)>210  then 20
			 end as Periodscore
	  into #temp800
	  from #temp700

	  select [buyerId]
	         ,Totalrevenue
	         ,TotalQuantity
	         ,Frequency
	         ,SKUs
	         ,Firsttime
	        ,Lasttime,
	        Revenuescore ,
			Quantityscore,
			Frequencyscore,
			SKUscore,
			Periodscore,
			(Revenuescore*0.5+Quantityscore*0.05+Frequencyscore*0.25+SKUscore*0.05+Periodscore*0.15)*5 as Loyaltyscore
	from #temp800
