/****** Script for SelectTopNRows command from SSMS  ******/
 if object_id('tempdb..#temp1000') is not null Begin
     drop table #temp1000
 End
SELECT 
      TB.[PurchaseOrderNumber]
      ,TB.P_statusId
	  ,TB.S_StatusId
      ,TB.[MallCode]
	  ,TB.ReferenceOrderId
      ,TB.[TrackingNumber]
	  ,TB.[PaymentTime]
	  ,PL_1.UpdatedOn as statusId_20_date
	  ,PL_2.UpdatedOn as statusId_15_date
	  ,PL_3.UpdatedOn  as statusId_13_date
	  ,PL_4.UpdatedOn as statusId_502_date
	  ,PL_5.UpdatedOn  as statusId_22_date
	  ,PL_6.UpdatedOn as statusId_501_date
	  ,isnull(TB.ShippedDate,PL_7.UpdatedOn) as statusId_29_date
	  ,TB.DeliveryDate as DeliveryDate
into #temp1000
from
	(SELECT distinct
			  P.[PurchaseOrderNumber]
			  ,P.[StatusId]  as P_statusId
			  ,[MallCode]
			  ,S.ReferenceOrderId
			  ,P.[TrackingNumber]
			  ,[PaymentTime]
			  ,20  as statusId_20
			  ,15 as statusId_15
			  ,13 as statusId_13 
			  ,502 as statusId_502
			  ,22 as statusId_22
			  ,501 as statusId_501
			  ,29 as statusId_29
			  ,S.[ShippingStatusId] as S_StatusId
			  ,dateadd(hh,8,S.[ShippedDateUtc]) as ShippedDate
			  ,DATEADD(hh,8,S.[DeliveryDateUtc])  as DeliveryDate
		  FROM [Tmall51Parcel].[dbo].[ProductImport] P 
		  left join [Tradewise].[dbo].[Shipment] S  
		  on P.[PurchaseOrderNumber]=S.[PurchaseOrderNumber] and P.[TrackingNumber]=S.[TrackingNumber]
		  where P.PaymentTime>='2017-01-01' and 
		        S.ServiceProviderId<>24 and
				P.StatusId<>-1 ) as TB
  left join [Tmall51Parcel].[dbo].[PackageLog] PL_1 on PL_1.OrderReference=TB.ReferenceOrderId and PL_1.StatusId=TB.statusId_20
  left join [Tmall51Parcel].[dbo].[PackageLog] PL_2 on PL_2.OrderReference=TB.ReferenceOrderId and PL_2.StatusId=TB.statusId_15
  left join [Tmall51Parcel].[dbo].[PackageLog] PL_3 on PL_3.OrderReference=TB.ReferenceOrderId and PL_3.StatusId=TB.statusId_13
  left join [Tmall51Parcel].[dbo].[PackageLog] PL_4 on PL_4.OrderReference=TB.ReferenceOrderId and PL_4.StatusId=TB.statusId_502
  left join [Tmall51Parcel].[dbo].[PackageLog] PL_5 on PL_5.OrderReference=TB.ReferenceOrderId and PL_5.StatusId=TB.statusId_22
  left join [Tmall51Parcel].[dbo].[PackageLog] PL_6 on PL_6.OrderReference=TB.ReferenceOrderId and PL_6.StatusId=TB.statusId_501
  left join [Tmall51Parcel].[dbo].[PackageLog] PL_7 on PL_7.OrderReference=TB.ReferenceOrderId and PL_7.StatusId=TB.statusId_29	

select
  TT.[PurchaseOrderNumber]
      ,TT.P_statusId
	  ,TT.S_StatusId
      ,TT.[MallCode]
	  ,TT.ReferenceOrderId
      ,TT.[TrackingNumber]
	  ,TT.[PaymentTime]
	  ,datediff(hh,TT.[PaymentTime],TT.statusId_20_date) as Yundan_time
	  ,datediff(hh,TT.[PaymentTime],TT.statusId_502_date) as Print_time
	  ,datediff(hh,TT.[PaymentTime],TT.statusId_501_date) as scan_time
	  ,datediff(hh,TT.[PaymentTime], TT.statusId_29_date) as shipping_time
	  ,datediff(hh,TT.[PaymentTime], TT.DeliveryDate) as Delivery_time
	  from #temp1000 as TT
	  where datediff(hh,TT.[PaymentTime], TT.statusId_29_date) >0