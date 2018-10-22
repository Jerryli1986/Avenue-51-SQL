  
  
  if object_id('tempdb..#ShippingCharge') is not null Begin
     drop table #ShippingCharge
 End
  if object_id('tempdb..#temp100') is not null Begin
     drop table #temp100
 End
 if object_id('tempdb..#temp200') is not null Begin
     drop table #temp200
 End

-- productimport left join shippment  P1-S1 ; P1 -S1 and P2-S1  using PurchaseOrderNumber
SELECT 
       PIt.[PurchaseOrderNumber]
      ,[ProductCode]
      ,[ProductChineseName]
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[UnitPrice]
      ,[UnitWeight]
      ,[Quantity]
      ,[Unit]
      ,[StatusId]
      ,[MallCode]
      ,[PaymentTime]
      ,s.[TrackingNumber]
      ,[buyerId]
	  ,s.[ReferenceOrderId]
	  ,s.ShipmentOrderId
	  ,s.OrderChargableWeight
	  ,ceiling(CAST(s.OrderChargableWeight AS DECIMAL(18,2))*2)/2 AS StandardWeight
	  ,s.OrderTotalPrice
	  ,s.OrderTotalValue
	  ,s.OrderTotalPaid
	  ,s.ExchangeRate
	  ,s.[ShippingStatusId]
	  ,CASE WHEN s.[TrackingNumber]=''  THEN 'BEUK' 
		       ElSE substring(s.TrackingNumber,1,2)+reverse(substring(reverse(s.TrackingNumber),1,2))  
			   END as Suppliers
  into #temp100
  FROM [Tmall51Parcel].[dbo].[ProductImport] as PIt
  left join [Tradewise].[dbo].[Shipment] as s
            ON PIt.[PurchaseOrderNumber]=s.[PurchaseOrderNumber]
  
  WHERE PIt.[PaymentTime]>='2017-04-24' and PIt.[PaymentTime]<'2017-05-01' 
       AND PIt.[PurchaseOrderNumber] NOT LIKE 'HTO%' 
	   AND   s.[ShippingStatusId]<>-1	

 --  productimport left join shippment   P1-S1 and P1 -S2    using TrackingNum
SELECT 
       PIt.[PurchaseOrderNumber]
      ,[ProductCode]
      ,[ProductChineseName]
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[UnitPrice]
      ,[UnitWeight]
      ,[Quantity]
      ,[Unit]
      ,[StatusId]
      ,[MallCode]
      ,[PaymentTime]
      ,s.[TrackingNumber]
      ,[buyerId]
	  ,s.[ReferenceOrderId]
	  ,s.ShipmentOrderId
	  ,s.OrderChargableWeight
	  ,ceiling(CAST(s.OrderChargableWeight AS DECIMAL(18,2))*2)/2 AS StandardWeight
	  ,s.OrderTotalPrice
	  ,s.OrderTotalValue
	  ,s.OrderTotalPaid
	  ,s.ExchangeRate
	  ,s.[ShippingStatusId]
	  ,CASE WHEN s.[TrackingNumber]=''  THEN 'BEUK' 
		       ElSE substring(s.TrackingNumber,1,2)+reverse(substring(reverse(s.TrackingNumber),1,2))  
			   END as Suppliers
  into #temp200
  FROM [Tmall51Parcel].[dbo].[ProductImport] as PIt
  left join [Tradewise].[dbo].[Shipment] as s
          on  PIt.[TrackingNumber]=s.[TrackingNumber]
  
 WHERE PIt.[PaymentTime]>='2017-04-24' and PIt.[PaymentTime]<'2017-05-01' 
      AND PIt.[PurchaseOrderNumber] NOT LIKE 'HTO%' 
   AND   s.[ShippingStatusId]<>-1	
      











/*
-----can not select period from shippment
--  shippment left join  productimport P1-S1 and P1 -S2
SELECT 
       s.[PurchaseOrderNumber]
      ,PIt.[ProductCode]
      ,PIt.[ProductChineseName]
      ,PIt.[Payment]
      ,PIt.[DiscountFee]
      ,PIt.[OrderPayment]
      ,PIt.[UnitPrice]
      ,PIt.[UnitWeight]
      ,PIt.[Quantity]
      ,PIt.[Unit]
      ,PIt.[StatusId]
      ,PIt.[MallCode]
      ,PIt.[PaymentTime]
      ,s.[TrackingNumber]
      ,PIt.[buyerId]
	  ,s.[ReferenceOrderId]
	  ,s.ShipmentOrderId
	  ,s.OrderChargableWeight
	  ,ceiling(CAST(s.OrderChargableWeight AS DECIMAL(18,2))*2)/2 AS StandardWeight
	  ,s.OrderTotalPrice
	  ,s.OrderTotalValue
	  ,s.OrderTotalPaid
	  ,s.ExchangeRate
	  ,s.[ShippingStatusId]
	  ,CASE WHEN s.[TrackingNumber]=''  THEN 'BEUK' 
		       ElSE substring(s.TrackingNumber,1,2)+reverse(substring(reverse(s.TrackingNumber),1,2))  
			   END as Suppliers
  into #temp200
  from [Tradewise].[dbo].[Shipment] as s
  left join [Tmall51Parcel].[dbo].[ProductImport] as PIt
            ON PIt.[TrackingNumber]=s.[TrackingNumber]
  WHERE PIt.[PaymentTime]>='2017-04-24' and PIt.[PaymentTime]<'2017-05-01' 
       AND PIt.[PurchaseOrderNumber] NOT LIKE 'HTO%' 
	   AND   s.[ShippingStatusId]<>-1
	   --and PIt.[PurchaseOrderNumber]='11955608862495771'
	   */
update #temp100
  set MallCode='Meilishuo' 
  where buyerId='HXTMLS'
  select  * from #temp100

  update #temp200
  set MallCode='Meilishuo' 
  where buyerId='HXTMLS'
  select  * from #temp200

 select [PurchaseOrderNumber]
      ,[ProductCode]
      ,[ProductChineseName]
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[UnitPrice]
      ,[UnitWeight]
      ,[Quantity]
      ,[Unit]
      ,[StatusId]
      ,[MallCode]
      ,[PaymentTime]
      ,[TrackingNumber]
      ,[buyerId]
	  ,[ReferenceOrderId]
	  ,ShipmentOrderId
	  ,OrderChargableWeight
	  , StandardWeight
	  ,sc.rates AS ShippingCost
	  ,OrderTotalPrice
	  ,OrderTotalValue
	  ,OrderTotalPaid
	  ,ExchangeRate
	  ,[ShippingStatusId]
	  ,Suppliers
	  from(
select * from #temp100
union 
select * from #temp200) as temps
left join  #ShippingCharge sc 
on  (sc.Id= temps.Suppliers collate Latin1_General_CI_AI and sc.weight2=temps.StandardWeight)


select top 5000 * from #temp200 order by PurchaseOrderNumber