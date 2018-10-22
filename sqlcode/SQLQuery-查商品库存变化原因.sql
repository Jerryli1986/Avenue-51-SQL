/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [Id]
      ,[LoggedOnUtc]
      ,[ProductId]
      ,[UpdatedReason]
      ,[OriginalValue]
      ,[NewValue]
      ,[UpdatedBy]
  FROM [Tradewise].[dbo].[ProductStockQuantityLog]
  where UpdatedReason like '%PO%' and [LoggedOnUtc]>'2017-06-01'