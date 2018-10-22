SELECT SC.id as StoreCustomerid
      ,[CustomerId]
      ,[StoreId]
      ,[Username]
      ,[CreatedOnUtc]
	  ,C.[Email]
  FROM [Tradewise].[dbo].[StoreCustomer] SC
  left join [Tradewise].[dbo].[Customer] C on C.Id=SC.[CustomerId]
  where StoreId=11
   and CreatedOnUtc>='2017-01-13'
   and SC.id  not in (select StoreCustomerId FROM [Tradewise].[dbo].[Order] where StoreId=11 and PaidDateUtc>='2017-06-01')
   and SC.id   in (select StoreCustomerId FROM [Tradewise].[dbo].[Order] where StoreId=11and PaidDateUtc<'2017-06-01')
