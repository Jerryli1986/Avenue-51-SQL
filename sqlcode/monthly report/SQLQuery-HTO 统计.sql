/****** Script for SelectTopNRows command from SSMS  ******/
if object_id('tempdb..#temp1000') is not null Begin
     drop table #temp1000
 End
 if object_id('tempdb..#ShippingCharge') is not null Begin
     drop table #ShippingCharge
 End
  declare @begindate as date
 declare @enddate as date
 set @enddate='2017-10-01' 
 set @begindate=dateadd(month,-4,@enddate)
 SET DATEFIRST 1

  BEGIN
    CREATE TABLE #ShippingCharge( Id varchar(10), Weight2 DECIMAL(18,2), Rates DECIMAL(18,2))
	INSERT INTO #ShippingCharge(Id,Weight2,Rates)
	VALUES ('EKGB',0.5,6.386),
('EKGB',1,7.5808),
('EKGB',1.5,8.7756),
('EKGB',2,9.9704),
('EKGB',2.5,11.1652),
('EKGB',3,12.1952),
('EKGB',3.5,12.1952),
('EKGB',4,12.1952),
('EKGB',4.5,13.9668),
('EKGB',5,13.9668),
('EKGB',5.5,17.51),
('EKGB',6,17.51),
('EKGB',6.5,17.51),
('EKGB',7,17.51),
('EKGB',7.5,18.3958),
('EKGB',8,19.2816),
('EKGB',8.5,20.1674),
('EKGB',9,21.0532),
('EKGB',9.5,21.939),
('EKGB',10,22.8248),
('EKGB',10.5,23.7106),
('EKGB',11,24.5964),
('EKGB',11.5,25.4822),
('EKGB',12,26.368),
('EKGB',12.5,27.2538),
('EKGB',13,28.1396),
('EKGB',13.5,29.0254),
('EKGB',14,29.9112),
('EKGB',14.5,30.797),
('EKGB',15,31.6828),
('EKGB',15.5,32.5686),
('EKGB',16,33.4544),
('EKGB',16.5,34.3402),
('EKGB',17,35.226),
('EKGB',17.5,36.1118),
('EKGB',18,36.9976),
('EKGB',18.5,37.8834),
('EKGB',19,38.7692),
('EKGB',19.5,39.655),
('EKGB',20,40.5408),
('EKGB',20.5,41.4266),
('EKGB',21,42.3124),
('EKGB',21.5,43.1982),
('EKGB',22,44.084),
('EKGB',22.5,44.9698),
('EKGB',23,45.8556),
('EKGB',23.5,46.7414),
('EKGB',24,47.6272),
('EKGB',24.5,48.513),
('EKGB',25,49.3988),
('EKGB',25.5,50.2846),
('EKGB',26,51.1704),
('EKGB',26.5,52.0562),
('EKGB',27,52.942),
('EKGB',27.5,53.8278),
('EKGB',28,54.7136),
('EKGB',28.5,55.5994),
('EKGB',29,56.4852),
('EKGB',29.5,57.371),
('EKGB',30,58.2568),
('BEUK',0.5,2.55568357953078),
('BEUK',1,3.01818357953078),
('BEUK',1.5,3.64832740345851),
('BEUK',2,4.27847122738624),
('BEUK',2.5,4.90861505131397),
('BEUK',3,5.5387588752417),
('BEUK',3.5,6.16890269916943),
('BEUK',4,6.79904652309716),
('BEUK',4.5,7.42919034702489),
('BEUK',5,8.05933417095262),
('BEUK',5.5,8.68947799488035),
('BEUK',6,9.31962181880808),
('BEUK',6.5,9.94976564273581),
('BEUK',7,10.5799094666635),
('BEUK',7.5,11.2100532905913),
('BEUK',8,11.840197114519),
('BEUK',8.5,12.4703409384467),
('BEUK',9,13.1004847623745),
('BEUK',9.5,13.7306285863022),
('BEUK',10,14.3607724102299),
('BEUK',10.5,14.9909162341576),
('BEUK',11,15.6210600580854),
('BEUK',11.5,16.2512038820131),
('BEUK',12,16.8813477059408),
('BEUK',12.5,17.5114915298686),
('BEUK',13,18.1416353537963),
('BEUK',13.5,18.771779177724),
('BEUK',14,19.4019230016518),
('BEUK',14.5,20.0320668255795),
('BEUK',15,20.6622106495072),
('BEUK',15.5,21.2923544734349),
('BEUK',16,21.9224982973627),
('BEUK',16.5,22.5526421212904),
('BEUK',17,23.1827859452181),
('BEUK',17.5,23.8129297691459),
('BEUK',18,24.4430735930736),
('BEUK',18.5,25.0732174170013),
('BEUK',19,25.7033612409291),
('BEUK',19.5,26.3335050648568),
('BEUK',20,26.9636488887845),
('BEUK',20.5,27.5937927127122),
('BEUK',21,28.22393653664),
('BEUK',21.5,28.8540803605677),
('BEUK',22,29.4842241844954),
('BEUK',22.5,30.1143680084232),
('BEUK',23,30.7445118323509),
('BEUK',23.5,31.3746556562786),
('BEUK',24,32.0047994802064),
('BEUK',24.5,32.6349433041341),
('BEUK',25,33.2650871280618),
('BEUK',25.5,33.8952309519895),
('BEUK',26,34.5253747759173),
('BEUK',26.5,35.155518599845),
('BEUK',27,35.7856624237727),
('BEUK',27.5,36.4158062477005),
('BEUK',28,37.0459500716282),
('BEUK',28.5,37.6760938955559),
('BEUK',29,38.3062377194837),
('BEUK',29.5,38.9363815434114),
('BEUK',30,39.5665253673391),
('EKHK',0.5,6.23745249337787),
('EKHK',1,6.53745249337786),
('EKHK',1.5,7.14494990210757),
('EKHK',2,8.26494299205344),
('EKHK',2.5,9.38493608199931),
('EKHK',3,10.5049291719452),
('EKHK',3.5,11.649922261891),
('EKHK',4,12.7949153518369),
('EKHK',4.5,13.9399084417828),
('EKHK',5,15.0849015317287),
('EKHK',5.5,16.2298946216745),
('EKHK',6,17.3748877116204),
('EKHK',6.5,18.5198808015663),
('EKHK',7,19.6648738915122),
('EKHK',7.5,20.809866981458),
('EKHK',8,21.9548600714039),
('EKHK',8.5,23.0998531613498),
('EKHK',9,24.2448462512956),
('EKHK',9.5,25.3898393412415),
('EKHK',10,26.5348324311874),
('EKHK',10.5,27.6798255211332),
('EKHK',11,28.8248186110791),
('EKHK',11.5,29.969811701025),
('EKHK',12,31.1148047909709),
('EKHK',12.5,32.2597978809167),
('EKHK',13,33.4047909708626),
('EKHK',13.5,34.5497840608085),
('EKHK',14,35.6947771507543),
('EKHK',14.5,36.8397702407002),
('EKHK',15,37.9847633306461),
('EKHK',15.5,39.129756420592),
('EKHK',16,40.2747495105378),
('EKHK',16.5,41.4197426004837),
('EKHK',17,42.5647356904296),
('EKHK',17.5,43.7097287803754),
('EKHK',18,44.8547218703213),
('EKHK',18.5,45.9997149602672),
('EKHK',19,47.1447080502131),
('EKHK',19.5,48.2897011401589),
('EKHK',20,49.4346942301048),
('EKHK',20.5,50.5796873200507),
('EKHK',21,51.7246804099966),
('EKHK',21.5,52.8696734999424),
('EKHK',22,54.0146665898883),
('EKHK',22.5,55.1596596798342),
('EKHK',23,56.30465276978),
('EKHK',23.5,57.4496458597259),
('EKHK',24,58.5946389496718),
('EKHK',24.5,59.7396320396176),
('EKHK',25,60.8846251295635),
('EKHK',25.5,62.0296182195094),
('EKHK',26,63.1746113094553),
('EKHK',26.5,64.3196043994011),
('EKHK',27,65.464597489347),
('EKHK',27.5,66.6095905792929),
('EKHK',28,67.7545836692387),
('EKHK',28.5,68.8995767591846),
('EKHK',29,70.0445698491305),
('EKHK',29.5,71.1895629390764),
('EKHK',30,72.3345560290222),
('EABE',0.5,8.14),
('EABE',1,8.48),
('EABE',1.5,8.82),
('EABE',2,9.19),
('EABE',2.5,10.26),
('EABE',3,10.26),
('EABE',3.5,12.6),
('EABE',4,12.6),
('EABE',4.5,14.94),
('EABE',5,14.94),
('EABE',5.5,17.27),
('EABE',6,17.27),
('EABE',6.5,20.54),
('EABE',7,20.54),
('EABE',7.5,21.95),
('EABE',8,21.95),
('EABE',8.5,24.28),
('EABE',9,24.28),
('EABE',9.5,26.62),
('EABE',10,26.62),
('EABE',10.5,28.96),
('EABE',11,28.96),
('EABE',11.5,31.29),
('EABE',12,31.29),
('EABE',12.5,33.63),
('EABE',13,33.63),
('EABE',13.5,35.97),
('EABE',14,35.97),
('EABE',14.5,38.3),
('EABE',15,38.3),
('EABE',15.5,40.64),
('EABE',16,40.64),
('EABE',16.5,42.98),
('EABE',17,42.98),
('EABE',17.5,45.31),
('EABE',18,45.31),
('EABE',18.5,47.65),
('EABE',19,47.65),
('EABE',19.5,49.98),
('EABE',20,49.98),
('EABE',20.5,52.32),
('EABE',21,52.32),
('EABE',21.5,54.66),
('EABE',22,54.66),
('EABE',22.5,57),
('EABE',23,57),
('EABE',23.5,59.34),
('EABE',24,59.34),
('EABE',24.5,61.68),
('EABE',25,61.68),
('EABE',25.5,64.02),
('EABE',26,64.02),
('EABE',26.5,66.36),
('EABE',27,66.36),
('EABE',27.5,68.7),
('EABE',28,68.7),
('EABE',28.5,71.04),
('EABE',29,71.04),
('EABE',29.5,73.38),
('EABE',30,73.38)
    END



SELECT  
     
      Tb.[PurchaseOrderNumber]
	  --,Tb.[ServiceProviderId]
	  ,SM.[ServiceName] 
      ,Tb.[ShippingStatusId]
	  ,ShipWeight
	  ,sc.rates AS ShippingCost
	  ,Tb.[OrderTotalPrice]
	  ,Tb.[OrderTotalDiscount]
	  ,Tb.[OrderTotalPaid]
      ,Tb.[ShippingDate]
      ,Tb.[ReferenceOrderId]
      ,Tb.[ShippedDateUtc]
      ,Tb.[TrackingNumber]
      ,Tb.[CreatedOnUtc]
	  ,Tb.[PaidDateUtc]
	  ,Tb.Suppliers
	  ,Tb.ShippedHours
	  ,Tb.months
	  ,Tb.weeks
 into #temp1000
  FROM 
   (SELECT  
		 s.[PurchaseOrderNumber]
		 ,s.[ServiceProviderId]
		 ,s.[ShippingStatusId]
		 ,s.OrderChargableWeight
		 ,ceiling(CAST(s.OrderChargableWeight AS DECIMAL(18,2))*2)/2 AS ShipWeight
		 ,s.OrderTotalPrice
		 ,s.[OrderTotalDiscount]
		 ,s.OrderTotalPaid
		 ,[ShippingDate]
		 ,s.[ReferenceOrderId]
		,s.[PaidDateUtc]
		,s.[ShippedDateUtc]
		,s.[CreatedOnUtc]
		 ,s.TrackingNumber 
		 ,CASE WHEN s.[TrackingNumber]=''  THEN 'WAIT' 
		       when substring(s.TrackingNumber,1,2)='BE' then substring(s.TrackingNumber,1,2)+reverse(substring(reverse(s.TrackingNumber),1,2)) 
			   when substring(s.TrackingNumber,1,2)='EA' then substring(s.TrackingNumber,1,2)+reverse(substring(reverse(s.TrackingNumber),1,2))
			   when substring(s.TrackingNumber,1,2)='EK' then substring(s.TrackingNumber,1,2)+reverse(substring(reverse(s.TrackingNumber),1,2))
			   Else 'OTHERS'
			   END as Suppliers
		, case when datepart(dw,[ShippedDateUtc])=2  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=7 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate)  
	         when datepart(dw,[ShippedDateUtc])=3  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=6 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate) 
	         when datepart(dw,[ShippedDateUtc])=4  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=5 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate)  
	         when datepart(dw,[ShippedDateUtc])=5  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=4 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate)  
	         when datepart(dw,[ShippedDateUtc])=6  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=3 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate)  
	         when datepart(dw,[ShippedDateUtc])=7 and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=2 then DATEDIFF(HOUR, dateadd(hh,24,S.[ShippedDateUtc]),  S.ShippingDate)  
	    else DATEDIFF(HOUR, S.[ShippedDateUtc],  S.ShippingDate) end AS ShippedHours   
	  ,convert(varchar(6),[PaidDateUtc],112)  as months
	  ,DATEADD(week, DATEDIFF(week,DATEADD(dd,-@@datefirst,'1900-01-01'),DATEADD(dd,-@@datefirst,convert(varchar(10), [PaidDateUtc], 120))), '1900-01-01') as weeks 
		FROM [Tradewise].[dbo].[Shipment] S) AS Tb
  
  left join  [Tradewise].[dbo].[ShipmentMethod] SM on SM.[ServiceProviderId]=Tb.[ServiceProviderId]
  lEFT JOIN #ShippingCharge sc on (sc.Id= Tb.Suppliers collate Latin1_General_CI_AI and sc.weight2=Tb.ShipWeight)
  where PurchaseOrderNumber like 'HTO%'
       --and [TrackingNumber]<>''  
       and [PaidDateUtc] >= @begindate
	   and [PaidDateUtc]< @enddate
	   --and ShippingStatusId in (29,200)
  order by [PaidDateUtc]

    select   months,
           count(TrackingNumber) as NumofShippedOrder,
           sum(ShipWeight) as TotalShipweight,
		   sum(ShippingCost) as TotalShippingcost,
		   sum([OrderTotalPaid]) as Totalrevenue, 
		   sum([OrderTotalPaid])-sum(ShippingCost) as NetIncome,
		   sum(ShippingCost)/sum(ShipWeight) as CostperKg 
  from #temp1000
  where [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)
  group by months
  order by months
  /*
 ----refund-----
  select   weeks,
           count(TrackingNumber) as NumofrefundOrder,
           sum(ShipWeight) as RefundShipweight,
		   sum(ShippingCost) as RefundShippingcost,
		   sum([OrderTotalPaid]) as Refundrevenue 
  from #temp1000
  where [ShippingStatusId] in (-1,40,41,57,58,59,60,61)
  group by weeks
  order by weeks
  */


   select  Suppliers,months,
           count(TrackingNumber) as NumofShippedOrder,
           sum(ShipWeight) as TotalShipweight,
		   sum(ShippingCost) as TotalShippingcost,
		   sum([OrderTotalPaid]) as Totalrevenue, 
		   sum([OrderTotalPaid])-sum(ShippingCost) as NetIncome,
		   sum(ShippingCost)/sum(ShipWeight) as CostperKg
  from #temp1000
  where Suppliers in ('BEUK','EABE','EKGB','EKHK','WAIT','OTHERS')
        and [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)
  group by months,Suppliers
  order by months,Suppliers