/****** Script for SelectTopNRows command from SSMS  ******/
/*
SELECT 
      P.[Name]
      ,[ProductEnglishName]
      ,[ProductNumber]
      ,P.[ShortDescription]
      ,[ProductHighlight]
      ,[FullDescription]
      ,[AllowCustomerReviews]
      ,[ApprovedRatingSum]
      ,[NotApprovedRatingSum]
      ,[ApprovedTotalReviews]
      ,[NotApprovedTotalReviews]
      ,[LimitPerOrder]
      ,[MinimumPerOrder]
      ,P.[StoreId]
      ,[SKU]
      ,[StockQuantity]
      ,[VendorCode]
	  ,Brand.Name
  FROM [Tradewise].[dbo].[Product] as P
  left join [Tradewise].[dbo].Brand on Brand.Id=P.[BrandId]
  where P.[IsInWarehouse]=0 and P.Deleted=0  and P.[StoreId]=6
  */
  SELECT 
       distinct
	   Brand.Name
  FROM [Tradewise].[dbo].[Product] as P
  left join [Tradewise].[dbo].Brand on Brand.Id=P.[BrandId]
  where P.[IsInWarehouse]=0 and P.Deleted=0  and P.[StoreId]=6