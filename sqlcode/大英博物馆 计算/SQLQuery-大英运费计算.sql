  

  --参数---
Declare @BegDate date
declare @EndDate date
set @BegDate='2017-08-01'
set @EndDate='2017-09-20'
--------------------------------------------  
  if object_id('tempdb..#ShippingCharge') is not null Begin
     drop table #ShippingCharge
 End
  if object_id('tempdb..#temp100') is not null Begin
     drop table #temp100
 End
  BEGIN
    CREATE TABLE #ShippingCharge( Id varchar(10), Weight2 DECIMAL(18,2), Rates DECIMAL(18,2))
	INSERT INTO #ShippingCharge(Id,Weight2,Rates)
	VALUES ('BEUK',0.5,4.99),
('BEUK',1,5.99),
('BEUK',1.5,7.75),
('BEUK',2,9.32),
('BEUK',2.5,10.99),
('BEUK',3,12.7),
('BEUK',3.5,14.37),
('BEUK',4,15.83),
('BEUK',4.5,17.5),
('BEUK',5,18.86),
('BEUK',5.5,20.68),
('BEUK',6,22.05),
('BEUK',6.5,23.62),
('BEUK',7,24.98),
('BEUK',7.5,26.55),
('BEUK',8,27.94),
('BEUK',8.5,29.28),
('BEUK',9,30.42),
('BEUK',9.5,31.76),
('BEUK',10,32.9),
('BEUK',10.5,34.25),
('BEUK',11,35.38),
('BEUK',11.5,36.73),
('BEUK',12,37.87),
('BEUK',12.5,39.21),
('BEUK',13,40.35),
('BEUK',13.5,41.69),
('BEUK',14,42.83),
('BEUK',14.5,44.18),
('BEUK',15,45.31),
('BEUK',15.5,46.66),
('BEUK',16,47.8),
('BEUK',16.5,49.14),
('BEUK',17,50.28),
('BEUK',17.5,51.62),
('BEUK',18,52.76),
('BEUK',18.5,54.11),
('BEUK',19,55.24),
('BEUK',19.5,56.59),
('BEUK',20,57.73),
('BEUK',20.5,59.07),
('BEUK',21,60.21),
('BEUK',21.5,61.55),
('BEUK',22,62.69),
('BEUK',22.5,64.03),
('BEUK',23,65.17),
('BEUK',23.5,66.52),
('BEUK',24,67.66),
('BEUK',24.5,69),
('BEUK',25,70.14),
('BEUK',25.5,71.48),
('BEUK',26,72.62),
('BEUK',26.5,73.96),
('BEUK',27,75.1),
('BEUK',27.5,76.45),
('BEUK',28,77.59),
('BEUK',28.5,78.93),
('BEUK',29,80.07),
('BEUK',29.5,81.41),
('BEUK',30,82.55)
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
		,PI.[PaymentTime]

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
		 
		FROM [Tradewise].[dbo].[Shipment] S
		) AS Tb
  LEFT JOIN (SELECT DISTINCT [PurchaseOrderNumber],Mallcode,buyerid,TrackingNumber,[PaymentTime] FROM [Tmall51Parcel].[dbo].[ProductImport]) AS PI ON PI.[PurchaseOrderNumber]=Tb.[PurchaseOrderNumber] and PI.TrackingNumber=Tb.TrackingNumber
  lEFT JOIN #ShippingCharge sc on (sc.Id= Tb.Suppliers collate Latin1_General_CI_AI and sc.weight2=Tb.weight1)
  
  WHERE PI.[PaymentTime]>=@BegDate and PI.[PaymentTime]<@EndDate
       AND Tb.[PurchaseOrderNumber] NOT LIKE 'HTO%' 
	   AND   Tb.[ShippingStatusId]<>-1 --AND MallCode IS NULL--And TrackingNum ='BE'
	   and PI.[MallCode]='TmallDYBWG'
	   order by Tb.[PurchaseOrderNumber] desc



  SET DATEFIRST 1
  select  
        [ReferenceOrderId],
	     [MallCode],
		 ShipmentOrderId,
		 [PurchaseOrderNumber],
		 OrderChargableWeight,
		 Weight,
	--	 OrderTotalPrice,
		 ShippingCost,
	--	 OrderTotalValue,
	--	 OrderTotalPaid,
	--	 ExchangeRate,
	     [ShippingStatusId],
		[PaidDateUtc],
		TrackingNumber
	--	Suppliers,
	--	buyerId,
   --      DATEADD(month, DATEDIFF(month,DATEADD(dd,-@@datefirst,'1900-01-01'),DATEADD(dd,-@@datefirst,convert(varchar(10), [PaidDateUtc], 120))), '1900-01-01') 
	--    as monthmark
	,[PaymentTime]
  from #temp100  
  --where buyerId='HXTMLS'