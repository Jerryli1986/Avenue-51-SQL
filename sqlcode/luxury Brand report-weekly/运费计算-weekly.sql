  

  --参数---
Declare @BegDate date
declare @EndDate date
set @BegDate='2017-08-28'
set @EndDate='2017-09-04'
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