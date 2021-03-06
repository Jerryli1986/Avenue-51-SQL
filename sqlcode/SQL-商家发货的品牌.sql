/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      P.[Name]
      ,P.[ProductEnglishName]
      ,P.[ProductNumber]
      ,P.[ShortDescription]
      ,P.[BrandId]
	  ,B.Name as Brand
      ,P.[SKU]
  FROM [Tradewise].[dbo].[Product] P
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=p.BrandId
  where P.[IsInWarehouse]=1 and P.[Deleted]=0 and P.STOREID=6 AND P.ProductTypeId=3
