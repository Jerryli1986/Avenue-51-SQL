

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
set @EndDate='2017-10-02'
set @BegDate=dateadd(week,-6,@enddate)
set @Exchange=9

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
		and [buyerId] not in ('51parcel-linda','51parcel-buddy','51parcel-Queenie')
		and [buyerId] not like N'测试%'
		and mallcode<>'TmallDYBWG'
		--and mallcode='WebAPI_51taouk.com'
		--and mallcode='WebAPI_Daifa.51Parcel.com'
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
--	if exists (select @TrackingNumber)
--	begin
--	     select top 1 @StatusId=-1 from [Tmall51Parcel].[dbo].[PackageLog] PL where PL.[TrackingNumber]=@TrackingNumber and  PL.[StatusId]=40 order by PL.[UpdatedOn] desc
--	end
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
--select * from #revenue_temp1 where MallCode='Meilishuo' order by Paymenttime


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
  --select * from #revenue_temp1  where [Brand] in ('MARK/GIUSTI','DOWER&HALL','C·NICOL')
  
  -----------------------------------------------shippping cost

  if object_id('tempdb..#ShippingCharge') is not null Begin
     drop table #ShippingCharge
 End
  if object_id('tempdb..#temp100') is not null Begin
     drop table #temp100
 End
  BEGIN
    CREATE TABLE #ShippingCharge( Id varchar(10), Weight2 DECIMAL(18,2), Rates DECIMAL(18,2))
	INSERT INTO #ShippingCharge(Id,Weight2,Rates)
	VALUES ('BEUK', 0.50,	2.90),
		('BEUK',1.00,	3.42),
		('BEUK',1.50,  4.05),
		('BEUK',2.00,	4.78),
		('BEUK',2.50,	5.44),
		('BEUK',3.00,	6.15),
		('BEUK',3.50,	6.85),
		('BEUK',4.00,	7.57),
		('BEUK',4.50,	8.29),
		('BEUK',5.00,	9.01),
		('BEUK',5.50,  9.73),
		('BEUK',6.00,	10.45),
		('BEUK',6.50,	11.16),
		('BEUK',7.00,	11.88),
		('BEUK',7.50,	12.60),
		('BEUK',8.00,  13.32),
		('BEUK',8.50,	14.04),
		('BEUK',9.00,	14.76),
		('BEUK',9.50,	15.47),
		('BEUK',10.00, 16.19),
		 ('BEUK', 10.5, 16.91),
		 ('BEUK', 10.5, 16.91), 
		 ('BEUK', 11, 17.63), 
		 ('BEUK', 11.5, 18.35), 
		 ('BEUK', 12, 19.07), 
		 ('BEUK', 12.5, 19.79), 
		 ('BEUK', 13, 20.5), 
		 ('BEUK', 13.5, 21.22), 
		 ('BEUK', 14, 21.94), 
		 ('BEUK', 14.5, 22.66), 
		 ('BEUK', 15, 23.38), 
		 ('BEUK', 15.5, 24.1), 
		 ('BEUK', 16, 24.81), 
		 ('BEUK', 16.5, 25.53), 
		 ('BEUK', 17, 26.25), 
		 ('BEUK', 17.5, 26.97), 
		 ('BEUK', 18, 27.69), 
		 ('BEUK', 18.5, 28.41), 
		 ('BEUK', 19, 29.13), 
		 ('BEUK', 19.5, 29.84), 
		 ('BEUK', 20, 30.56), 
		 ('BEUK', 20.5, 31.28), 
		 ('BEUK', 21, 32), 
		 ('BEUK', 21.5, 32.72), 
		 ('BEUK', 22, 33.44), 
		 ('BEUK', 22.5, 34.16), 
		 ('BEUK', 23, 34.87), 
		 ('BEUK', 23.5, 35.59), 
		 ('BEUK', 24, 36.31), 
		 ('BEUK', 24.5, 37.03), 
		 ('BEUK', 25, 37.75), 
		 ('BEUK', 25.5, 38.47), 
		 ('BEUK', 26, 39.18), 
		 ('BEUK', 26.5, 39.9), 
		 ('BEUK', 27, 40.62), 
		 ('BEUK', 27.5, 41.34), 
		 ('BEUK', 28, 42.06), 
		 ('BEUK', 28.5, 42.78), 
		 ('BEUK', 29, 43.5), 
		 ('BEUK', 29.5, 44.21), 
		 ('BEUK', 30, 44.93),
		 ('EABE', 0.5, 7.78), 
		 ('EABE', 1, 8.45), 
		 ('EABE', 1.5, 9.49), 
		 ('EABE', 2, 11.12), 
		 ('EABE', 2.5, 12.76), 
		 ('EABE', 3, 14.39), 
		 ('EABE', 3.5, 16.05), 
		 ('EABE', 4, 17.66), 
		 ('EABE', 4.5, 19.27), 
		 ('EABE', 5, 20.88), 
		 ('EABE', 5.5, 22.5), 
		 ('EABE', 6, 24.11), 
		 ('EABE', 6.5, 25.72), 
		 ('EABE', 7, 27.33), 
		 ('EABE', 7.5, 28.94), 
		 ('EABE', 8, 30.35), 
		 ('EABE', 8.5, 31.76), 
		 ('EABE', 9, 33.18), 
		 ('EABE', 9.5, 34.59), 
		 ('EABE', 10, 36), 
		 ('EABE', 10.5, 37.41), 
		 ('EABE', 11, 38.82), 
		 ('EABE', 11.5, 40.23), 
		 ('EABE', 12, 41.64), 
		 ('EABE', 12.5, 43.06), 
		 ('EABE', 13, 44.47), 
		 ('EABE', 13.5, 45.88), 
		 ('EABE', 14, 47.29), 
		 ('EABE', 14.5, 48.7), 
		 ('EABE', 15, 50.11), 
		 ('EABE', 15.5, 51.53), 
		 ('EABE', 16, 52.94), 
		 ('EABE', 16.5, 54.35), 
		 ('EABE', 17, 55.76), 
		 ('EABE', 17.5, 57.17), 
		 ('EABE', 18, 58.58), 
		 ('EABE', 18.5, 59.99), 
		 ('EABE', 19, 61.41), 
		 ('EABE', 19.5, 62.82), 
		 ('EABE', 20, 64.23), 
		 ('EABE', 20.5, 65.64), 
		 ('EABE', 21, 67.05), 
		 ('EABE', 21.5, 68.46), 
		 ('EABE', 22, 69.87), 
		 ('EABE', 22.5, 71.29), 
		 ('EABE', 23, 72.7), 
		 ('EABE', 23.5, 74.11), 
		 ('EABE', 24, 75.52), 
		 ('EABE', 24.5, 76.93), 
		 ('EABE', 25, 78.34), 
		 ('EABE', 25.5, 79.76), 
		 ('EABE', 26, 81.17), 
		 ('EABE', 26.5, 82.58), 
		 ('EABE', 27, 83.99), 
		 ('EABE', 27.5, 85.4), 
		 ('EABE', 28, 86.81), 
		 ('EABE', 28.5, 88.22), 
		 ('EABE', 29, 89.64), 
		 ('EABE', 29.5, 91.05), 
		 ('EABE', 30, 92.46), 
		  ('EKGB', 0.5, 10.65), 
		 ('EKGB', 1, 10.65), 
		 ('EKGB', 1.5, 12.7), 
		 ('EKGB', 2, 12.7), 
		 ('EKGB', 2.5, 14.75), 
		 ('EKGB', 3, 14.75), 
		 ('EKGB', 3.5, 16.8), 
		 ('EKGB', 4, 16.8), 
		 ('EKGB', 4.5, 18.85), 
		 ('EKGB', 5, 18.85), 
		 ('EKGB', 5.5, 20.9), 
		 ('EKGB', 6, 20.9), 
		 ('EKGB', 6.5, 22.95), 
		 ('EKGB', 7, 22.95), 
		 ('EKGB', 7.5, 25), 
		 ('EKGB', 8, 25), 
		 ('EKGB', 8.5, 27.05), 
		 ('EKGB', 9, 27.05), 
		 ('EKGB', 9.5, 29.1), 
		 ('EKGB', 10, 29.1), 
		 ('EKGB', 10.5, 31.15), 
		 ('EKGB', 11, 31.15), 
		 ('EKGB', 11.5, 33.2), 
		 ('EKGB', 12, 33.2), 
		 ('EKGB', 12.5, 35.25), 
		 ('EKGB', 13, 35.25), 
		 ('EKGB', 13.5, 37.3), 
		 ('EKGB', 14, 37.3), 
		 ('EKGB', 14.5, 39.35), 
		 ('EKGB', 15, 39.35), 
		 ('EKGB', 15.5, 41.4), 
		 ('EKGB', 16, 41.4), 
		 ('EKGB', 16.5, 43.45), 
		 ('EKGB', 17, 43.45), 
		 ('EKGB', 17.5, 45.5), 
		 ('EKGB', 18, 45.5), 
		 ('EKGB', 18.5, 47.55), 
		 ('EKGB', 19, 47.55), 
		 ('EKGB', 19.5, 49.6), 
		 ('EKGB', 20, 49.6), 
		 ('EKGB', 20.5, 51.65), 
		 ('EKGB', 21, 51.65), 
		 ('EKGB', 21.5, 53.7), 
		 ('EKGB', 22, 53.7), 
		 ('EKGB', 22.5, 55.75), 
		 ('EKGB', 23, 55.75), 
		 ('EKGB', 23.5, 57.8), 
		 ('EKGB', 24, 57.8), 
		 ('EKGB', 24.5, 59.85), 
		 ('EKGB', 25, 59.85), 
		 ('EKGB', 25.5, 61.9), 
		 ('EKGB', 26, 61.9), 
		 ('EKGB', 26.5, 63.95), 
		 ('EKGB', 27, 63.95), 
		 ('EKGB', 27.5, 66), 
		 ('EKGB', 28, 66), 
		 ('EKGB', 28.5, 68.05), 
		 ('EKGB', 29, 68.05), 
		 ('EKGB', 29.5, 70.1), 
		 ('EKGB', 30, 70.1),
		 ('EKHK',0.5,6.23),
		('EKHK',1,6.56),
		('EKHK',1.5,7.2),
		('EKHK',2,8.36),
		('EKHK',2.5,9.52),
		('EKHK',3,10.68),
		('EKHK',3.5,11.87),
		('EKHK',4,13.05),
		('EKHK',4.5,14.24),
		('EKHK',5,15.42),
		('EKHK',5.5,16.61),
		('EKHK',6,17.8),
		('EKHK',6.5,18.98),
		('EKHK',7,20.17),
		('EKHK',7.5,21.35),
		('EKHK',8,22.54),
		('EKHK',8.5,23.72),
		('EKHK',9,24.91),
		('EKHK',9.5,26.1),
		('EKHK',10,27.28)
    END



SELECT
		 Tb.[ReferenceOrderId],
	     PI.[MallCode],
		 Tb.ShipmentOrderId,
		 Tb.[PurchaseOrderNumber],
		 Tb.OrderChargableWeight,
		 Tb.weight1 AS Weight,
		 Tb.OrderTotalPrice,
		 sc.rates AS ShippingCost,
		 Tb.OrderTotalValue,
		 Tb.OrderTotalPaid,
		 Tb.ExchangeRate
	     ,Tb.[ShippingStatusId]
		,Tb.[PaidDateUtc]
		,Tb.TrackingNumber
		,Tb.Suppliers
		,PI.buyerId

into #temp100
FROM (SELECT  s.[ReferenceOrderId],
          s.ShipmentOrderId,
		 s.[PurchaseOrderNumber],
		 s.OrderChargableWeight,
		   ceiling(CAST(s.OrderChargableWeight AS DECIMAL(18,2))*2)/2 AS Weight1
		 ,s.OrderTotalPrice,
		  s.OrderTotalValue,
		 s.OrderTotalPaid,
		 s.ExchangeRate
	     ,s.[ShippingStatusId]
		,s.[PaidDateUtc]
		 ,s.TrackingNumber 
		 ,CASE WHEN s.[TrackingNumber]=''  THEN 'BEUK' 
		       ElSE substring(s.TrackingNumber,1,2)+reverse(substring(reverse(s.TrackingNumber),1,2))  
			   END as Suppliers
		 
		FROM [Tradewise].[dbo].[Shipment] S) AS Tb
  LEFT JOIN (SELECT DISTINCT [PurchaseOrderNumber],Mallcode,buyerid FROM [Tmall51Parcel].[dbo].[ProductImport]) AS PI ON PI.[PurchaseOrderNumber]=Tb.[PurchaseOrderNumber]
  lEFT JOIN #ShippingCharge sc on (sc.Id= Tb.Suppliers collate Latin1_General_CI_AI and sc.weight2=Tb.weight1)
  
  WHERE Tb.[PaidDateUtc]>=@BegDate and Tb.[PaidDateUtc]<@EndDate
       AND Tb.[PurchaseOrderNumber] NOT LIKE 'HTO%' 
	   AND   Tb.[ShippingStatusId]<>-1 --AND MallCode IS NULL--And TrackingNum ='BE'
	   
	   order by Tb.[PurchaseOrderNumber] desc

update #temp100
  set MallCode='Meilishuo' 
  where buyerId='HXTMLS'

update #temp100
  set MallCode='WebAPI_51taouk.com' 
  where PurchaseOrderNumber like '%MPD%'

/*
  SET DATEFIRST 1
  select  
        [ReferenceOrderId],
	     [MallCode],
		 ShipmentOrderId,
		 [PurchaseOrderNumber],
		 OrderChargableWeight,
		 Weight,
		 OrderTotalPrice,
		 ShippingCost,
		 OrderTotalValue,
		 OrderTotalPaid,
		 ExchangeRate,
	     [ShippingStatusId],
		[PaidDateUtc],
		TrackingNumber,
		Suppliers,
		buyerId,
         DATEADD(week, DATEDIFF(week,DATEADD(dd,-@@datefirst,'1900-01-01'),DATEADD(dd,-@@datefirst,convert(varchar(10), [PaidDateUtc], 120))), '1900-01-01') 
	    as weekmark
  from #temp100  
 -- where buyerId='HXTMLS'

*/
 ------------------------------------------------------------------------


 select
        DATEADD(week, DATEDIFF(week,DATEADD(dd,-@@datefirst,'1900-01-01'),DATEADD(dd,-@@datefirst,convert(varchar(10), Temp1.[Paymenttime], 120))), '1900-01-01') 
	    as weekmark 
       ,Temp1.[Paymenttime]
      ,Temp1.[PurchaseOrderNumber]
      ,Temp1.[ProductCode]
      ,Temp1.[Brand]
      ,Temp1.[ProductName]
      ,Temp1.[Payment]
      ,Temp1.[DiscountFee]
      ,Temp1.[OrderPayment]
      ,Temp1.[Quantity]
      ,Temp1.[StatusId]
      ,Temp1.[MallCode]
      ,Temp1.[buyerId]
      ,Temp1.[Cost]
      ,Temp1.[TrackingNumber]
      ,Temp1.[TotalCost]
	  ,Temp1.[Revenue]
	  ,isnull(Temp1.[Revenue]*Temp1.[Commissionrate],0) as [Commission]
	  ,Temp1.Exchangerate
	  ,ShippingCost
	  ,Suppliers
	  ,(Temp1.[Revenue]-Temp1.[TotalCost]-isnull(Temp1.[Revenue]*Temp1.[Commissionrate],0)-ShippingCost) as Netincome
	  
	  from #revenue_temp1   Temp1
	  left join #temp100  on #temp100.[TrackingNumber]=Temp1.[TrackingNumber] collate Latin1_General_CI_AI 
	  where [Brand] in ('MARK/GIUSTI','DOWER&HALL','C·NICOL')
	  order by weekmark 
	--  --where MallCode='Meilishuo' 

	