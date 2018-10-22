
 
 
 -- parameter 
 
 declare @begindate as date
 declare @enddate as date
 set @begindate='2017-09-01'
 set @enddate='2017-10-01' 


 -----------------------------------------------------


 if object_id('tempdb..#temp1000') is not null Begin
     drop table #temp1000
 End
 if object_id('tempdb..#temp2000') is not null Begin
     drop table #temp2000
 End
 if object_id('tempdb..#temp3000') is not null Begin
     drop table #temp3000
 End
 if object_id('tempdb..#temp4000') is not null Begin
     drop table #temp4000
 End
 ---London shipped
 --shipped (was not outofstock and not samename and not from Dongguan)
SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS ShippedTimePeriod --less than 1 hour equals 0
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
    into #temp1000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] WHERE StatusId = 15 group by [OrderReference] ) AS PL_1   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 
	and PL.[OrderReference] not in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 14 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)
	and PL.[OrderReference] not in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 504 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)
	----out of stock but not same name
	SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS ShippedTimePeriod --less than 1 hour equals 0
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
    into #temp2000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] WHERE StatusId = 15 group by [OrderReference] ) AS PL_1   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 
	and PL.[OrderReference]  in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 14 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)
	and PL.[OrderReference] not in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 504 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)
----the same name	but not out of stock
   SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS ShippedTimePeriod --less than 1 hour equals 0
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
    into #temp3000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] WHERE StatusId = 15 group by [OrderReference] ) AS PL_1   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 
	and PL.[OrderReference] not in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 14 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)
	and PL.[OrderReference]  in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 504 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)

----the same name	and  out of stock
   SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS ShippedTimePeriod --less than 1 hour equals 0
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
    into #temp4000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] WHERE StatusId = 15 group by [OrderReference] ) AS PL_1   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 
	and PL.[OrderReference]  in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 14 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)
	and PL.[OrderReference]  in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 504 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)



--Select distinct * from #temp2000

Select 'london shipped' as Name,
      sum(case when W.WarehousePeriod<0  then W.Counts else 0 end) as Period0,  
      sum(case when W.WarehousePeriod>=0 and W.WarehousePeriod<=24 then W.Counts else 0 end) as Period24 ,
	  sum(case when W.WarehousePeriod>24 and W.WarehousePeriod<=48 then W.Counts else 0 end )as Period48 ,
	  sum(case when W.WarehousePeriod>48 and W.WarehousePeriod<=72 then W.Counts else 0 end )as Period72 ,
	  sum(case when W.WarehousePeriod>72 and W.WarehousePeriod<=96 then W.Counts else 0 end )as Period96 ,
	  sum(case when W.WarehousePeriod>96 and W.WarehousePeriod<=120 then W.Counts else 0 end )as Period120 ,
	  sum(case when W.WarehousePeriod>120                         then W.Counts else 0 end )as Over120,
	  sum(case when W.WarehousePeriod<0  then W.sumhours else 0 end) as hours0 ,
	  sum(case when W.WarehousePeriod>=0 and W.WarehousePeriod<=24 then W.sumhours else 0 end) as hours24 ,
	  sum(case when W.WarehousePeriod>24 and W.WarehousePeriod<=48 then W.sumhours else 0 end )as hours48 ,
	  sum(case when W.WarehousePeriod>48 and W.WarehousePeriod<=72 then W.sumhours else 0 end )as hours72 ,
	  sum(case when W.WarehousePeriod>72 and W.WarehousePeriod<=96 then W.sumhours else 0 end )as hours96 ,
	  sum(case when W.WarehousePeriod>96 and W.WarehousePeriod<=120 then W.sumhours else 0 end )as hours120 ,
	  sum(case when W.WarehousePeriod>120                         then W.sumhours else 0 end )as hoursover120
      
  from
( select WarehousePeriod ,count(TrackingNumber) as Counts, sum(WarehousePeriod) as sumhours from #temp1000 group by WarehousePeriod) as W

 union

Select  'london out of stock' as Name,
      sum(case when W1.WarehousePeriod<0  then W1.Counts else 0 end) as Period0 ,
	  sum(case when W1.WarehousePeriod>=0 and W1.WarehousePeriod<=24 then W1.Counts else 0 end) as Period24 ,
	  sum(case when W1.WarehousePeriod>24 and W1.WarehousePeriod<=48 then W1.Counts else 0 end )as Period48 ,
	  sum(case when W1.WarehousePeriod>48 and W1.WarehousePeriod<=72 then W1.Counts else 0 end )as Period72 ,
	  sum(case when W1.WarehousePeriod>72 and W1.WarehousePeriod<=96 then W1.Counts else 0 end )as Period96 ,
	  sum(case when W1.WarehousePeriod>96 and W1.WarehousePeriod<=120 then W1.Counts else 0 end )as Period120 ,
	  sum(case when W1.WarehousePeriod>120                         then W1.Counts else 0 end )as Over120,
	  sum(case when W1.WarehousePeriod<0  then W1.sumhours else 0 end) as hours0 ,
	  sum(case when W1.WarehousePeriod>=0 and W1.WarehousePeriod<=24 then W1.sumhours else 0 end) as hours24 ,
	  sum(case when W1.WarehousePeriod>24 and W1.WarehousePeriod<=48 then W1.sumhours else 0 end )as hours48 ,
	  sum(case when W1.WarehousePeriod>48 and W1.WarehousePeriod<=72 then W1.sumhours else 0 end )as hours72 ,
	  sum(case when W1.WarehousePeriod>72 and W1.WarehousePeriod<=96 then W1.sumhours else 0 end )as hours96 ,
	  sum(case when W1.WarehousePeriod>96 and W1.WarehousePeriod<=120 then W1.sumhours else 0 end )as hours120 ,
	  sum(case when W1.WarehousePeriod>120                         then W1.sumhours else 0 end )as hoursover120
      
  from
( select WarehousePeriod ,count(TrackingNumber) as Counts, sum(WarehousePeriod) as sumhours from #temp2000 group by WarehousePeriod) as W1
 union
Select  'london the same name' as Name,
      sum(case when W2.WarehousePeriod<0  then W2.Counts else 0 end) as Period0 ,
	  sum(case when W2.WarehousePeriod>=0 and W2.WarehousePeriod<=24 then W2.Counts else 0 end) as Period24 ,
	  sum(case when W2.WarehousePeriod>24 and W2.WarehousePeriod<=48 then W2.Counts else 0 end )as Period48 ,
	  sum(case when W2.WarehousePeriod>48 and W2.WarehousePeriod<=72 then W2.Counts else 0 end )as Period72 ,
	  sum(case when W2.WarehousePeriod>72 and W2.WarehousePeriod<=96 then W2.Counts else 0 end )as Period96 ,
	  sum(case when W2.WarehousePeriod>96 and W2.WarehousePeriod<=120 then W2.Counts else 0 end )as Period120 ,
	  sum(case when W2.WarehousePeriod>120                         then W2.Counts else 0 end )as Over120,
	  sum(case when W2.WarehousePeriod<0  then W2.sumhours else 0 end) as hours0 ,
	  sum(case when W2.WarehousePeriod>=0 and W2.WarehousePeriod<=24 then W2.sumhours else 0 end) as hours24 ,
	  sum(case when W2.WarehousePeriod>24 and W2.WarehousePeriod<=48 then W2.sumhours else 0 end )as hours48 ,
	  sum(case when W2.WarehousePeriod>48 and W2.WarehousePeriod<=72 then W2.sumhours else 0 end )as hours72 ,
	  sum(case when W2.WarehousePeriod>72 and W2.WarehousePeriod<=96 then W2.sumhours else 0 end )as hours96 ,
	  sum(case when W2.WarehousePeriod>96 and W2.WarehousePeriod<=120 then W2.sumhours else 0 end )as hours120 ,
	  sum(case when W2.WarehousePeriod>120                         then W2.sumhours else 0 end )as hoursover120
      
  from
( select WarehousePeriod ,count(TrackingNumber) as Counts , sum(WarehousePeriod) as sumhours from #temp3000 group by WarehousePeriod) as W2
 union
Select  'london the same name and out of stock' as Name,
      sum(case when W3.WarehousePeriod<0  then W3.Counts else 0 end) as Period0 ,
	  sum(case when W3.WarehousePeriod>=0 and W3.WarehousePeriod<=24 then W3.Counts else 0 end) as Period24 ,
	  sum(case when W3.WarehousePeriod>24 and W3.WarehousePeriod<=48 then W3.Counts else 0 end )as Period48 ,
	  sum(case when W3.WarehousePeriod>48 and W3.WarehousePeriod<=72 then W3.Counts else 0 end )as Period72 ,
	  sum(case when W3.WarehousePeriod>72 and W3.WarehousePeriod<=96 then W3.Counts else 0 end )as Period96 ,
	  sum(case when W3.WarehousePeriod>96 and W3.WarehousePeriod<=120 then W3.Counts else 0 end )as Period120 ,
	  sum(case when W3.WarehousePeriod>120                         then W3.Counts else 0 end )as Over120,
	  sum(case when W3.WarehousePeriod<0  then W3.sumhours else 0 end) as hours0 ,
	  sum(case when W3.WarehousePeriod>=0 and W3.WarehousePeriod<=24 then W3.sumhours else 0 end) as hours24 ,
	  sum(case when W3.WarehousePeriod>24 and W3.WarehousePeriod<=48 then W3.sumhours else 0 end )as hours48 ,
	  sum(case when W3.WarehousePeriod>48 and W3.WarehousePeriod<=72 then W3.sumhours else 0 end )as hours72 ,
	  sum(case when W3.WarehousePeriod>72 and W3.WarehousePeriod<=96 then W3.sumhours else 0 end )as hours96 ,
	  sum(case when W3.WarehousePeriod>96 and W3.WarehousePeriod<=120 then W3.sumhours else 0 end )as hours120 ,
	  sum(case when W3.WarehousePeriod>120                         then W3.sumhours else 0 end )as hoursover120
      
  from
( select WarehousePeriod ,count(TrackingNumber) as Counts , sum(WarehousePeriod) as sumhours from #temp4000 group by WarehousePeriod) as W3

--result  (hours not days)
----shipped (was not outofstock and not samename and not from Dongguan)
----out of stock but not same name
----the same name	but not out of stock
----the same name	and  out of stock

------------------------------------------------------------
/*
--Dongguan

if object_id('tempdb..#temp3000') is not null Begin
     drop table #temp3000
 End
 if object_id('tempdb..#temp4000') is not null Begin
     drop table #temp4000
 End

SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS ShippedTimePeriod --less than 1 hour equals 0
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
    into #temp3000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] WHERE StatusId = 15 group by [OrderReference] ) AS PL_1   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId=24   ---Dongguan
	and PL.[OrderReference] not in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 14 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)
	----out of stock
	SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS ShippedTimePeriod --less than 1 hour equals 0
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
    into #temp4000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] WHERE StatusId = 15 group by [OrderReference] ) AS PL_1   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId=24   ---Dongguan
	and PL.[OrderReference]  in (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 14 
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null)
	



--Select distinct * from #temp1000

Select  
      sum(case when W3.ShippedTimePeriod<0 then W3.Counts else 0 end) as Period0,
	  sum(case when W3.ShippedTimePeriod>=0 and W3.ShippedTimePeriod<=24 then W3.Counts else 0 end) as Period24 ,
	  sum(case when W3.ShippedTimePeriod>24 and W3.ShippedTimePeriod<=48 then W3.Counts else 0 end )as Period48 ,
	  sum(case when W3.ShippedTimePeriod>48 and W3.ShippedTimePeriod<=72 then W3.Counts else 0 end )as Period72 ,
	  sum(case when W3.ShippedTimePeriod>72 and W3.ShippedTimePeriod<=96 then W3.Counts else 0 end )as Period96 ,
	  sum(case when W3.ShippedTimePeriod>96 and W3.ShippedTimePeriod<=120 then W3.Counts else 0 end )as Period120 ,
	  sum(case when W3.ShippedTimePeriod>120                         then W3.Counts else 0 end )as Over120,
	  sum(case when W3.ShippedTimePeriod<0 then W3.ShippedTimePeriod else 0 end) as hours0 ,
	  sum(case when W3.ShippedTimePeriod>=0 and W3.ShippedTimePeriod<=24 then W3.ShippedTimePeriod else 0 end) as hours24 ,
	  sum(case when W3.ShippedTimePeriod>24 and W3.ShippedTimePeriod<=48 then W3.ShippedTimePeriod else 0 end )as hours48 ,
	  sum(case when W3.ShippedTimePeriod>48 and W3.ShippedTimePeriod<=72 then W3.ShippedTimePeriod else 0 end )as hours72 ,
	  sum(case when W3.ShippedTimePeriod>72 and W3.ShippedTimePeriod<=96 then W3.ShippedTimePeriod else 0 end )as hours96 ,
	  sum(case when W3.ShippedTimePeriod>96 and W3.ShippedTimePeriod<=120 then W3.ShippedTimePeriod else 0 end )as hours120 ,
	  sum(case when W3.ShippedTimePeriod>120                         then W3.ShippedTimePeriod else 0 end )as hoursOver120

      
  from
( select ShippedTimePeriod ,count(TrackingNumber) as Counts from #temp3000 group by ShippedTimePeriod) as W3



Select  
      sum(case when W4.ShippedTimePeriod<0  then W4.Counts else 0 end) as Period0,
	  sum(case when W4.ShippedTimePeriod>=0 and W4.ShippedTimePeriod<=24 then W4.Counts else 0 end) as Period24 ,
	  sum(case when W4.ShippedTimePeriod>24 and W4.ShippedTimePeriod<=48 then W4.Counts else 0 end )as Period48 ,
	  sum(case when W4.ShippedTimePeriod>48 and W4.ShippedTimePeriod<=72 then W4.Counts else 0 end )as Period72 ,
	  sum(case when W4.ShippedTimePeriod>72 and W4.ShippedTimePeriod<=96 then W4.Counts else 0 end )as Period96 ,
	  sum(case when W4.ShippedTimePeriod>96 and W4.ShippedTimePeriod<=120 then W4.Counts else 0 end )as Period120 ,
	  sum(case when W4.ShippedTimePeriod>120                         then W4.Counts else 0 end )as Over120,
	  sum(case when W4.ShippedTimePeriod<0 then W4.ShippedTimePeriod else 0 end) as hours0 ,
	  sum(case when W4.ShippedTimePeriod>=0 and W4.ShippedTimePeriod<=24 then W4.ShippedTimePeriod else 0 end) as hours24 ,
	  sum(case when W4.ShippedTimePeriod>24 and W4.ShippedTimePeriod<=48 then W4.ShippedTimePeriod else 0 end )as hours48 ,
	  sum(case when W4.ShippedTimePeriod>48 and W4.ShippedTimePeriod<=72 then W4.ShippedTimePeriod else 0 end )as hours72 ,
	  sum(case when W4.ShippedTimePeriod>72 and W4.ShippedTimePeriod<=96 then W4.ShippedTimePeriod else 0 end )as hours96 ,
	  sum(case when W4.ShippedTimePeriod>96 and W4.ShippedTimePeriod<=120 then W4.ShippedTimePeriod else 0 end )as hours120 ,
	  sum(case when W4.ShippedTimePeriod>120                         then W4.ShippedTimePeriod else 0 end )as hoursOver120
      
  from
( select ShippedTimePeriod ,count(TrackingNumber) as Counts from #temp4000 group by ShippedTimePeriod) as W4





*/

/*
--N'%商品下单失败: 您在本次付款中，如果使用包税专线，请务必保证同一地址多箱发货时%'
declare @begindate as date
 declare @enddate as date
set @begindate='2017-05-01'
 set @enddate='2017-05-08' 
	SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS ShippedTimePeriod --less than 1 hour equals 0
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
   -- into #temp2000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] WHERE StatusId = 15 group by [OrderReference] ) AS PL_1   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	and DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn]))>120
	--AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 
	and PL.[OrderReference]  in  (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].Notes  like N'%商品下单失败: 您在本次付款中，如果使用包税专线，请务必保证同一地址多箱发货时%'
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null
										  and [OrderReference] in(
									                             select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                                                    where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 29
										                                    and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null	
										                                    and DATEADD(HH, +8, [Tmall51Parcel].[dbo].[PackageLog].[UpdatedOn])>=@begindate
																			and  DATEADD(HH, +8, [Tmall51Parcel].[dbo].[PackageLog].[UpdatedOn]) <@enddate
																			)
																			
                                 )
 */  
/*				
--N'%商品下单失败: 您在本次付款中，如果使用包税专线，请务必保证同一地址多箱发货时%'
declare @begindate as date
 declare @enddate as date
set @begindate='2017-05-01'
 set @enddate='2017-05-10' 
	SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS ShippedTimePeriod --less than 1 hour equals 0
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
   -- into #temp2000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] WHERE StatusId = 15 group by [OrderReference] ) AS PL_1   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	and DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn]))>120
	--AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 
	and PL.[OrderReference]  in  (select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].Notes  like N'%商品下单失败: 您在本次付款中，如果使用包税专线，请务必保证同一地址多箱发货时%'
										  and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null
										  and [OrderReference] in(
									                             select distinct [OrderReference] from [Tmall51Parcel].[dbo].[PackageLog] 
	                                                                    where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 29
										                                    and  [Tmall51Parcel].[dbo].[PackageLog].[OrderReference] is not null	
										                                    and DATEADD(HH, +8, [Tmall51Parcel].[dbo].[PackageLog].[UpdatedOn])>=@begindate
																			and  DATEADD(HH, +8, [Tmall51Parcel].[dbo].[PackageLog].[UpdatedOn]) <@enddate
																			)
                                   )

*/

/*  there is duplication record for the same OrderreferenceNum 
SELECT TimePeriod, COUNT([TrackingNumber]) AS ShippedAmout
FROM (SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.PaymentTime
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As Assignedtowarehouse
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, PI.PaymentTime, DATEADD(HH, +9, PL.[UpdatedOn])) AS TimePeriod --less than 1 hour equals 0
		,PL.[StatusId]
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	LEFT JOIN [Tmall51Parcel].[dbo].[PackageLog] AS PL_1  ON PL.[TrackingNumber]=PL_1.[TrackingNumber] AND PL.[TrackingNumber]<>' ' and PL.OrderReference=PL_1.OrderReference and PL_1.StatusId = 15
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>='2017-05-01' AND DATEADD(HH, +8, PL.[UpdatedOn]) <'2017-05-08' AND PL.StatusId = 29 AND PI.StatusId<>-1
	) AS Tb1
GROUP BY TimePeriod
ORDER by TimePeriod ASC
*/