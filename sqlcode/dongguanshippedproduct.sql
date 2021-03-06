/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
   
      [PurchaseOrderNumber]
      ,[OrderActualWeight]
      ,[OrderDimensionWeight]
      ,[OrderChargableWeight]
      ,[OrderTotalPrice]
      ,[OrderTotalValue]
      ,[OrderProductTax]
      ,[OrderTotalDiscount]
      ,[DiscountDescription]
      ,[OrderTotalPaid]
      ,[PackageType]
      ,[ServiceProviderId]
      ,[ShippingStatusId]
      ,[PickupTypeId]

      ,[ShippingDate]
      ,[ReferenceOrderId]
      ,[ShippedDateUtc]
      ,[TrackingNumber]
      ,[DeliveryDateUtc]
      ,dateadd(hh,+8,S.[CreatedOnUtc]) as [CreatedOnBeijing]
	  ,SD.[ProductId]
	  ,P.Name
	  ,B.Name
  FROM [Tradewise].[dbo].[Shipment] S
  left join [Tradewise].[dbo].[ShipmentItemDetails] SD on SD.[ShipmentId]=S.Id
  left join [Tradewise].[dbo].[Product] P on P.Id=SD.[ProductId]
  left join [Tradewise].[dbo].[Brand] B on B.Id=P.BrandId
  where [ServiceProviderId]=24 
        and [ShipmentOrderId]<>-1
		and dateadd(hh,+8,S.[CreatedOnUtc]) >='2017-04-01'
		and dateadd(hh,+8,S.[CreatedOnUtc]) <'2017-05-01'
		and [ShippingStatusId] in (29,200)  