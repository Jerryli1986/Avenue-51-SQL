/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  
      
  
  
      [PurchaseOrderNumber]
      ,[ProductCode]
      ,[VendorSKU]
    
      ,[ServiceProviderId]
      ,[PickupTypeId]
      ,[ProductChineseName]
      ,I.[ProductEnglishName]
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[UnitPrice]
      ,[UnitWeight]
      ,[ExtraInsuranceId]
      ,[Quantity]
      ,[Unit]
      ,[ReceiverName]
      ,[ReceiverAddress]
      ,[PostCode]
      ,[ReceiverCity]
      ,[ReceiverProvince]
      ,[PhoneNumber]
      ,[NewCopied]
      ,[StatusId]
      ,[MallCode]
      ,[TMTId]
      ,[TMOId]
      ,[BuyerMemo]
      ,[SellerMemo]
      ,[TradeMemo]
      ,[RefundStatus]
      ,[LastTMStatus]
      ,[NewTMStatus]
      ,[PaymentTime]
      ,[ModifyTime]
      ,[ShippedOn]
      ,[TrackingNumber]
      ,[buyerId]
      ,[alipay_id]
      ,[alipay_no]
      ,[CreatedOn]
      ,[LastUpdatedBy]
      ,[IsPromotion]
      ,I.[IsInWarehouse]
      ,[Notes]
      ,[IDCardNumber]
   
      ,[Barcode]
  FROM [Tmall51Parcel].[dbo].[ProductImport] I
  left join [Tradewise].[dbo].[Product] P on I.ProductCode=P.ProductNumber
  left join [Tradewise].[dbo].[Brand] B on P.BrandId=B.Id
  where B.Name like '%mini Boden%'
  and PaymentTime>'2017-04-11'