/****** Script for SelectTopNRows command from SSMS  ******/

SELECT 
      [ShipmentOrderId]
      ,[PurchaseOrderNumber]
      ,[OrderChargableWeight]
      ,[OrderTotalPrice]
      ,[OrderTotalValue]
      ,[OrderProductTax]
      ,[OrderTotalDiscount]
      ,[OrderTotalPaid]
     -- ,[ExchangeRate]
      ,[ServiceProviderId]
      ,[UKServiceProviderId]
      ,[ShippingStatusId]
      ,[PickupTypeId]
      ,[ShippingDate]
      ,[ReferenceOrderId]
      ,[PaidDateUtc]
      ,[ShippedDateUtc]
      ,[TrackingNumber]
      ,[UKTrackingNumber]
      ,[CreatedOnUtc]
      ,[ExtraUKShippingFee]
      ,[StoreServiceFee]
      ,[RefundedAmount]
	  ,PaymentUniqueId
  FROM [Tradewise].[dbo].[Shipment]

  -- select * FROM [Tradewise].[dbo].[Shipment]
  where StoreId=7 
  --and [ShippingStatusId]<>-1 
 and [PaidDateUtc]>='2017-06-01'  and [PaidDateUtc]<'2017-07-01'
  and [ReferenceOrderId]  not like '%EXP%'
 -- and [ReferenceOrderId]   like '%OWE%'

 -- and PaymentUniqueId like '%134133%'


  

  SELECT 
      convert(varchar(10),[PaidDateUtc],120) as Date,
      sum([OrderTotalPaid])  as SubTotal
	  --,count( ReferenceOrderId) as Quantity
  FROM [Tradewise].[dbo].[Shipment]
  where StoreId=7 
  --and [ShippingStatusId]<>-1 
  and [PaidDateUtc]>='2015-01-01'  
  and [ReferenceOrderId] not like '%EXP%'
  group by convert(varchar(10),[PaidDateUtc],120)
  order by convert(varchar(10),[PaidDateUtc],120)

---------------------------------------------------------

  select * from [Tradewise].[dbo].[Shipment]
  where  --[ReferenceOrderId]='ORD0629021401137'
          [TrackingNumber]='EK811816468GB'
      --   and [ShippingStatusId]<>-1 



	  SELECT PH.id
      ,[PaymentUniqueKey]
      ,[StoreCustomerId]
      ,[EntityId]
      ,[EntityDescription]
      ,[PaymentMethodId]
      ,[PaymentTypeId]
      ,[RequestAmount]
      ,[RequestedOnUtc]
      ,[PaidAmount]
      ,[PaidOnUtc]
      ,PH.[PaymentInfo]
      ,[Token]
      ,[TransactionInfo]
      ,[PaymentCurrency]
	  ,PM.Name
  FROM [Tradewise].[dbo].[PaymentHistory] PH
--  inner join (SELECT ext1.[PaymentInfo],min(ext1.Id) as Id
 --                FROM [Tradewise].[dbo].[PaymentHistory]  ext1 WITH(NOLOCK)
 --                  INNER JOIN [Tradewise].[dbo].[StoreCustomer] ext2 WITH(NOLOCK) on ext2.id=ext1.[StoreCustomerId] and ext2.StoreId=7
 --                  WHERE PaymentTypeId in (1,2) AND PaidOnUtc IS NOT NULL 
 --                  GROUP BY [PaymentInfo]
--              ) Tem on Tem.Id=PH.id
   left join [Tradewise].[dbo].[StoreCustomer] SC on PH.[StoreCustomerId]=SC.Id and SC.StoreId=7
  left join [Tradewise].[dbo].PaymentMethod PM on PM.Id=PH.PaymentMethodId
  where SC.[Username] not in ('51parcel-linda','roletest','roleimplementation','51parcel-buddy')
        and PH.[PaidOnUtc]>='2017-06-01' and PH.[PaidOnUtc]<'2017-07-01'
		and PH.PaidOnUtc IS NOT NULL
		and [PaymentUniqueKey] ='SHP=2017-06-01-12-29-23_34431'
		--and ORD0531020767882




		SELECT distinct 
       [OrderTotalPaid]
     ,[ShippingStatusId]
      ,[ReferenceOrderId]
      ,[PaidDateUtc]
      ,[TrackingNumber]
      ,[UKTrackingNumber]
      ,[RefundedAmount]
	  ,PaymentUniqueId
  FROM [Tradewise].[dbo].[Shipment]

  -- select * FROM [Tradewise].[dbo].[Shipment]
  where StoreId=7 
  --and [ShippingStatusId]<>-1 
 and [PaidDateUtc]>='2017-06-01'  and [PaidDateUtc]<'2017-07-01'
  --and [ReferenceOrderId]  not like '%EXP%'
  and PaymentUniqueId='SHP=2017-06-19-23-54-46_56975'



  
		SELECT 
      sum( [OrderTotalPaid]) as sumtotal


  
	  ,PaymentUniqueId
  FROM [Tradewise].[dbo].[Shipment]

  -- select * FROM [Tradewise].[dbo].[Shipment]
  where StoreId=7 
  --and [ShippingStatusId]<>-1 
 and [PaidDateUtc]>='2017-06-01'  and [PaidDateUtc]<'2017-07-01'
  --and [ReferenceOrderId]  not like '%EXP%'
  and PaymentUniqueId='SHP=2017-06-18-23-11-50_40454'
  group by PaymentUniqueId

