/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Id]
      ,[ShipmentOrderId]
      ,[StoreId]
      ,[StoreCustomerId]
      ,[PurchaseOrderNumber]
      ,[OrderActualWeight]
      ,[OrderDimensionWeight]
      ,[OrderChargableWeight]
      ,[OrderTotalPrice]
      ,[OrderTotalValue]
      ,[OrderProductTax]
      ,[OrderTotalDiscount]
      ,[DiscountDescription]
      ,[OrderTotalPaid]
      ,[ExchangeRate]
      ,[PackageType]
      ,[ServiceProviderId]
      ,[UKServiceProviderId]
      ,[ShippingStatusId]
      ,[PickupTypeId]
      ,[ExtraInsuranceId]
      ,[ShipFromName]
      ,[ShipFromEmail]
      ,[ShipFromPhone]
      ,[ShipFromCellPhone]
      ,[ShipFromAddress]
      ,[ShipFromAddress2]
      ,[ShipFromAddress3]
      ,[ShipFromCity]
      ,[ShipFromProvince]
      ,[ShipFromPostalCode]
      ,[ShipFromCountry]
      ,[ShipToName]
      ,[ShipToAddress]
      ,[ShipToCity]
      ,[ShipToProvince]
      ,[ShipToPostalCode]
      ,[ShipToAreaCode]
      ,[ShipToProvinceId]
      ,[ShipToCountry]
      ,[ShipToIDCardType]
      ,[ShipToIDCardNumber]
      ,[ShipToQQ]
      ,[ShipToWechat]
      ,[ShipToEmail]
      ,[ShipToPhone]
      ,[ShipToCellPhone]
      ,[ShippingDate]
      ,[ReferenceOrderId]
      ,[PaymentUniqueId]
      ,[PaidDateUtc]
      ,[ShippedDateUtc]
      ,[TrackingNumber]
      ,[UKTrackingNumber]
      ,[DeliveryDateUtc]
      ,[InWarehouseDateUtc]
      ,[Notes]
      ,[CreatedOnUtc]
      ,[ExtraUKShippingFee]
      ,[StoreServiceFee]
      ,[RefundedAmount]
      ,[BatchUniqueKey]
      ,[rowguid]
  FROM [TradewiseFromCN].[dbo].[Shipment]

  Select StoreCustomerId,count(StoreCustomerId) from [TradewiseFromCN].[dbo].[Shipment] group by StoreCustomerId