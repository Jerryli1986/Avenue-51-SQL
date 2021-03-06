/****** Script for SelectTopNRows command from SSMS  ******/
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
  inner join (SELECT ext1.[PaymentInfo],min(ext1.Id) as Id
                 FROM [Tradewise].[dbo].[PaymentHistory]  ext1 WITH(NOLOCK)
                   INNER JOIN [Tradewise].[dbo].[StoreCustomer] ext2 WITH(NOLOCK) on ext2.id=ext1.[StoreCustomerId] and ext2.StoreId=7
                   WHERE PaymentTypeId in (1,2) AND PaidOnUtc IS NOT NULL 
                   GROUP BY [PaymentInfo]
              ) Tem on Tem.Id=PH.id
  inner join [Tradewise].[dbo].[StoreCustomer] SC on PH.[StoreCustomerId]=SC.Id and SC.StoreId=7
  inner join [Tradewise].[dbo].PaymentMethod PM on PM.Id=PH.PaymentMethodId
  where SC.[Username] not in ('51parcel-linda','roletest','roleimplementation','51parcel-buddy')
        and PH.[PaidOnUtc]>='2017-06-01' and PH.[PaidOnUtc]<'2017-07-01'
		and PH.PaidOnUtc IS NOT NULL


-------------------------------------------------------------------------------------------------------------------------------------	

	SELECT 
       convert(varchar(10),PH.[PaidOnUtc],120) as Dates,
       sum(PH.[PaidAmount])  as SubTotal
	 FROM [Tradewise].[dbo].[PaymentHistory] PH
  inner join (SELECT ext1.[PaymentInfo],min(ext1.Id) as Id
                 FROM [Tradewise].[dbo].[PaymentHistory]  ext1 WITH(NOLOCK)
                   INNER JOIN [Tradewise].[dbo].[StoreCustomer] ext2 WITH(NOLOCK) on ext2.id=ext1.[StoreCustomerId] and ext2.StoreId=7
                   WHERE PaymentTypeId in (1,2) AND PaidOnUtc IS NOT NULL 
                   GROUP BY [PaymentInfo]
              ) Tem on Tem.Id=PH.id
  inner join [Tradewise].[dbo].[StoreCustomer] SC on PH.[StoreCustomerId]=SC.Id and SC.StoreId=7
  inner join [Tradewise].[dbo].PaymentMethod PM on PM.Id=PH.PaymentMethodId
  where SC.[Username] not in ('51parcel-linda','roletest','roleimplementation','51parcel-buddy')
       and PH.[PaidOnUtc]>='2017-06-01' and PH.[PaidOnUtc]<'2017-07-01'
		and PH.PaidOnUtc IS NOT NULL	

  group by convert(varchar(10),PH.[PaidOnUtc],120)
  order by convert(varchar(10),PH.[PaidOnUtc],120)

  ------------------------------------Refund
 select   Ext1.[Id]
      ,[ReferenceOrderId]
      ,[OrderId]
      ,[OrderTypeId]
      ,Ext1.[StoreId]
      ,[StoreCustomerId]
      ,[OrderReceivable]
      ,[OrderStatusId]
      ,Ext1.[CreatedOnUtc]
      ,[PaidDateUtc]
      ,[PaymentUniqueId]
      ,[CancelledOnUtc]
	  from [Tradewise].[dbo].[OrderShipmentRefundReport]  Ext1
      INNER JOIN [Tradewise].[dbo].[StoreCustomer] ext2 with(nolock) on ext2.Id=ext1.[StoreCustomerId]
      INNER JOIN [Tradewise].[dbo].[OrderStatus] ext3 with(nolock) on ext3.[Id]=ext1.[OrderStatusId]
	  WHERE Ext1.OrderTypeId=2
      and EXT1.StoreId=7 
      AND EXT1.CancelledOnUtc>='2017-06-01' AND EXT1.CancelledOnUtc<'2017-07-01' 
      and ext2.[Username] not in ('51parcel-linda','roletest','roleimplementation','51parcel-buddy')
	  and  EXT1.CancelledOnUtc IS not NULL
 





--AND EXISTS(SELECT * FROM [Tradewise].[dbo].[ShipmentLog] WITH(NOLOCK) WHERE [ReferenceOrderId]=EXT1.[ReferenceOrderId] AND [ShippingStatusId] = 10)
--      AND NOT EXISTS(SELECT * FROM [Tradewise].[dbo].[OrderShipmentRefundReport] WITH(NOLOCK) WHERE [ReferenceOrderId]=EXT1.[ReferenceOrderId] AND OrderTypeId=1)


 
 -----
  select   convert(varchar(10),EXT1.CancelledOnUtc,120) as Dates
            ,sum([OrderReceivable]) as Refund
     
	  from [Tradewise].[dbo].[OrderShipmentRefundReport]  Ext1
      INNER JOIN [Tradewise].[dbo].[StoreCustomer] ext2 with(nolock) on ext2.Id=ext1.[StoreCustomerId]
      INNER JOIN [Tradewise].[dbo].[OrderStatus] ext3 with(nolock) on ext3.[Id]=ext1.[OrderStatusId]
	  WHERE  Ext1.OrderTypeId=2
             and EXT1.StoreId=7 
		     and  EXT1.CancelledOnUtc>='2017-05-01' AND EXT1.CancelledOnUtc<'2017-07-01' 
            and ext2.[Username] not in ('51parcel-linda','roletest','roleimplementation','51parcel-buddy')
            and  EXT1.CancelledOnUtc IS not NULL
  group by convert(varchar(10),EXT1.CancelledOnUtc,120)
  order by convert(varchar(10),EXT1.CancelledOnUtc,120)