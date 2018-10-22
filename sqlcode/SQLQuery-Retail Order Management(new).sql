
 
 
 -- parameter 
 
 declare @begindate as date
 declare @enddate as date
 set @begindate='2017-07-03'
 set @enddate='2017-07-10' 


 -----------------------------------------------------

 if object_id('tempdb..#temp1000') is not null Begin
     drop table #temp1000
 End
 if object_id('tempdb..#temp2000') is not null Begin
     drop table #temp2000
 End

 
 --shipped (not from Dongguan)

  ---London  Labeled  since imported into productimport
 SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		,PI.CreatedOn
		,DATEADD(HH, +8, PL.[UpdatedOn]) As LabeledTime
		,DATEDIFF(HOUR, PI.CreatedOn, DATEADD(HH, +9, PL.[UpdatedOn])) AS LabeledPeriod  --less than 1 hour equals 0
		,PL.[StatusId]
    into #temp1000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 20 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 

Select -- 'london labeled' as  Name,

--	  ,sum(LabeledPeriod) as LabeledHours
	  sum(LabeledPeriod)/count(TrackingNumber) as AvgCreated_labeledTime
	   ,count(TrackingNumber) as unfailedPackages
from #temp1000

-------------faild labeled
SELECT 
		count(DISTINCT PL.[OrderReference]) as Failedlabels

	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join [Tradewise].[dbo].[Shipment] as S On PL.[OrderReference]=S.ReferenceOrderId 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON S.PurchaseOrderNumber=PI.PurchaseOrderNumber
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 50 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 


---London shipped since Labeled

SELECT 
		DISTINCT PL.[OrderReference]
		 ,PL.[TrackingNumber]
		 ,case  when PL.[Name] like '%false%' then 'False'
				else 'True'
				end as Name
		,DATEADD(HH, +8, PL_1.[UpdatedOn]) As LabeledTime
		,DATEADD(HH, +8, PL.[UpdatedOn]) As BeijingTime_ShippedTime
		,DATEDIFF(HOUR, DATEADD(HH, +8, PL_1.[UpdatedOn]), DATEADD(HH, +9, PL.[UpdatedOn])) AS WarehousePeriod
		,PL.[StatusId]
    into #temp2000
	FROM [Tmall51Parcel].[dbo].[PackageLog] AS PL
	left join (SELECT DISTINCT [OrderReference],max([UpdatedOn]) as [UpdatedOn]  FROM [Tmall51Parcel].[dbo].[PackageLog] 
	           WHERE StatusId = 20 group by [OrderReference] ) AS PL_1   
			   ON  PL.OrderReference=PL_1.OrderReference 
	LEFT JOIN [Tmall51Parcel].[dbo].[ProductImport] AS PI ON PL.[TrackingNumber]=PI.[TrackingNumber] AND PL.[TrackingNumber]<>' '
	WHERE DATEADD(HH, +8, PL.[UpdatedOn])>=@begindate AND DATEADD(HH, +8, PL.[UpdatedOn]) <@enddate
	AND PL.StatusId = 29 
	AND PI.StatusId<>-1
	and PL.ServiceProviderId<>24 


Select 

--      ,count(TrackingNumber) as Packages
--	  ,sum(WarehousePeriod) as ShippedHours
	  sum(WarehousePeriod)/count(TrackingNumber) as AvgLabeled_ShippedTime
	  ,sum (case when Name like 'False' then 1 else 0 end) as Vendorparcel
	  ,count(TrackingNumber) -sum (case when Name like 'False' then 1 else 0 end) as Warehouse
from #temp2000
