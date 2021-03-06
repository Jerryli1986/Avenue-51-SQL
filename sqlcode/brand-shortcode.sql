/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
-- P.[Name]
--      ,P.[ProductEnglishName]
--      ,P.[ProductNumber]
 distinct
      B.Name as Brand
	  ,B.[BrandCode]

  FROM [Tradewise].[dbo].[Product] P
  left join [Tradewise].[dbo].[Brand] B on B.Id=P.[BrandId]

  where P.[IsInWarehouse]=0 and P.[StoreId]=6 and P.ProductTypeId=3