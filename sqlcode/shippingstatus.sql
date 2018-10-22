  
  if object_id('tempdb..#temp100') is not null Begin
     drop table #temp100
 End
 if object_id('tempdb..#temp200') is not null Begin
     drop table #temp200
 End

-- productimport left join shippment  P1-S1 ; P1 -S1 and P2-S1  using PurchaseOrderNumber
SELECT 
       distinct PIt.[PurchaseOrderNumber]
      ,[MallCode]
      ,s.[TrackingNumber]
	  ,s.[ShippingStatusId]
	
  into #temp100
  FROM [Tmall51Parcel].[dbo].[ProductImport] as PIt
  left join [Tradewise].[dbo].[Shipment] as s
            ON PIt.[PurchaseOrderNumber]=s.[PurchaseOrderNumber]
			   and PIt.[TrackingNumber]=s.[TrackingNumber]
  
  WHERE PIt.[PaymentTime]>='2017-04-24' and PIt.[PaymentTime]<'2017-05-01' 
       AND PIt.[PurchaseOrderNumber] NOT LIKE 'HTO%' 
	   AND   s.[ShippingStatusId]<>-1	
	   and PIt.[StatusId]<>-1
       
	   select * from #temp100  --where PurchaseOrderNumber='51673394141'

 