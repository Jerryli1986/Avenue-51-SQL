/****** Script for SelectTopNRows command from SSMS  ******/
if object_id('tempdb..#temp1000') is not null Begin
     drop table #temp1000
 End
  declare @begindate as date
 declare @enddate as date
 set @begindate='2016-01-01'
 set @enddate='2017-05-12' 
SELECT  
       [ShipmentOrderId]
      ,[StoreId]
      ,[PurchaseOrderNumber]
      ,[PackageType]
      ,[ServiceProviderId]
      ,[ShippingStatusId]
      ,[ShippingDate]
      ,[ReferenceOrderId]
      ,[ShippedDateUtc]
      ,[TrackingNumber]
      ,[CreatedOnUtc]
	  , case when datepart(dw,[ShippedDateUtc])=2  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=7 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate)  
	         when datepart(dw,[ShippedDateUtc])=3  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=6 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate) 
	         when datepart(dw,[ShippedDateUtc])=4  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=5 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate)  
	         when datepart(dw,[ShippedDateUtc])=5  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=4 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate)  
	         when datepart(dw,[ShippedDateUtc])=6  and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=3 then DATEDIFF(HOUR, dateadd(hh,48,S.[ShippedDateUtc]),  S.ShippingDate)  
	         when datepart(dw,[ShippedDateUtc])=7 and DATEDIFF(day, [ShippedDateUtc], S.ShippingDate)>=2 then DATEDIFF(HOUR, dateadd(hh,24,S.[ShippedDateUtc]),  S.ShippingDate)  
	    else DATEDIFF(HOUR, S.[ShippedDateUtc],  S.ShippingDate) end AS ShippedPeriod   
	  ,datepart(yyyy,ShippingDate)  as Shippingyear
	  ,datepart(mm,ShippingDate)    as Shippingmonth
  into #temp1000
  FROM [Tradewise].[dbo].[Shipment] S
  where PurchaseOrderNumber like 'HTO%'  
       and [ShippingDate] >= @begindate
	   and [ShippingDate]< @enddate
	   and ShippingStatusId in (29,200)

Select W.Shippingyear,W.Shippingmonth, 
      sum(case when  W.ShippedPeriod<=24 then W.Counts else 0 end) as Periodless24 ,
	  sum(case when W.ShippedPeriod>24 and W.ShippedPeriod<=48 then W.Counts else 0 end )as Periodover24less48 ,
	  sum(case when W.ShippedPeriod>48 and W.ShippedPeriod<=72 then W.Counts else 0 end )as Periodover48less72 ,
	  sum(case when W.ShippedPeriod>72 and W.ShippedPeriod<=120 then W.Counts else 0 end )as Periodvoer72less120 ,
	  sum(case when W.ShippedPeriod>120                         then W.Counts else 0 end )as Over120
      
  from
( select Shippingyear,Shippingmonth, ShippedPeriod ,count(TrackingNumber) as Counts from #temp1000 group by Shippingyear,Shippingmonth, ShippedPeriod) as W
group by W.Shippingyear,W.Shippingmonth
order by W.Shippingyear,W.Shippingmonth

--select * from #temp1000   where Shippingyear=2017 and Shippingmonth=4
--order by Shippingyear,Shippingmonth

--SELECT DATEDIFF(day,'2017-05-05','2017-05-08') AS DiffDate
--SELECT DATEname(dw,'2017-05-02') AS DiffDate