SELECT 

      [ReferenceOrderId]
      ,rtrim(ltrim([OrderStatusId]))  as [OrderStatusId]
    --  ,rtrim(ltrim([PaymentMethodSystemName])) as [PaymentMethodSystemName]
    --  ,rtrim(ltrim([CustomerCurrencyCode])) as [CustomerCurrencyCode]
   --   ,rtrim(ltrim([CurrencyRate])) as [CurrencyRate]
    --  ,rtrim(ltrim([OrderDiscount])) as [OrderDiscount]
      ,rtrim(ltrim([OrderTotal])) as [OrderTotal]
  --    ,rtrim(ltrim([RefundedAmount])) as [RefundedAmount]

      ,rtrim(ltrim([OrderReceivable])) as [OrderReceivable]

  --    ,rtrim(ltrim([PurchaseOrderNumber])) as [PurchaseOrderNumber]

      ,rtrim(ltrim([PaidDateUtc])) as [PaidDateUtc]
      ,rtrim(ltrim([PaymentUniqueId])) as [PaymentUniqueId]
 --     ,rtrim(ltrim([Deleted])) as [Deleted]
      ,rtrim(ltrim([CreatedOnUtc])) as [CreatedOnUtc]
 --     ,rtrim(ltrim([Platform])) as [Platform]
 ,[PaymentMethodSystemName]
	  ,S.Name as StoreName
  FROM [Tradewise].[dbo].[Order] O
  left join [Tradewise].[dbo].[Store] S on S.Id=O.StoreId
  where CreatedOnUtc>'2017-05-01' and CreatedOnUtc<'2017-07-01'