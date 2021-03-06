/****** Script for SelectTopNRows command from SSMS  ******/
Declare @BegDate date
declare @EndDate date
set @BegDate='2017-01-01'
set @EndDate='2017-07-01'

SELECT 
       S.[StoreId]
      ,S.[PurchaseOrderNumber]
      ,S.[OrderActualWeight]
      ,S.[OrderDimensionWeight]
      ,S.[OrderChargableWeight]
      ,S.[OrderTotalPrice]
      ,S.[OrderTotalValue]
      ,S.[OrderProductTax]
      ,S.[OrderTotalDiscount]
      ,S.[DiscountDescription]
      ,S.[OrderTotalPaid]
      ,S.[ExchangeRate]
      ,S.[PackageType]
      ,S.[ServiceProviderId]
      ,S.[UKServiceProviderId]
      ,S.[ShippingStatusId]
      ,S.[ReferenceOrderId]
      ,S.[PaymentUniqueId]
      ,S.[PaidDateUtc]
      ,S.[ShippedDateUtc]
      ,S.[TrackingNumber]
      ,S.[UKTrackingNumber]
      ,S.[CreatedOnUtc]
	   ,SD.[ProductId]
      ,SD.[ProductName]
      ,SD.[ProductEnglishName]
      ,SD.[UnitPrice]
      ,SD.[Quantity]
      ,SD.[UnitWeight]
      ,SD.[ProductCode]
      ,SD.[MallCode]
	  ,P.[Weight]  as Pweight
	  ,B.Name
  FROM [Tradewise].[dbo].[Shipment] S
  left join  [Tradewise].[dbo].[ShipmentItemDetails] SD on SD.[ShipmentId]=S.Id
  LEFT JOIN (SELECT DISTINCT  [PurchaseOrderNumber],Mallcode,buyerid FROM [Tmall51Parcel].[dbo].[ProductImport]) AS PI ON PI.[PurchaseOrderNumber]=S.[PurchaseOrderNumber]
  left join [Tradewise].[dbo].[Product] P on P.Id=SD.[ProductId] --and P.[StoreId]=3
  left join [Tradewise].[dbo].Brand  B on B.Id=P.BrandId
  where S.[PaidDateUtc]>=@BegDate and  S.[PaidDateUtc]<@EndDate
  AND S.[PurchaseOrderNumber] NOT LIKE 'HTO%' 
  and PI.[MallCode] like '%TMall%'
  and S.[ShippingStatusId]<>-1
  order by PurchaseOrderNumber
