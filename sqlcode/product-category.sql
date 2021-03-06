/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      P.[Name]
      ,P.[ProductEnglishName]
      ,P.[ProductNumber]
      ,P.[ShortDescription]
   --   ,P.[Published]
  --    ,P.[Deleted]
   --   ,[SKU]
   --   ,[StockQuantity]
    --  ,P.[ProductTypeId]
   --   ,[VendorCode]
   --   ,[IsInWarehouse]
	  ,C1.Name as SubCategoryName
	  ,C2.Name as ParentCategoryName
	  ,B.Name as Brand
  FROM [Tradewise].[dbo].[Product]  P
  left join [Tradewise].[dbo].[Product_Category_Mapping] PCM on PCM.[ProductId]=P.Id
  left join [Tradewise].[dbo].[Category] C1 on C1.Id=PCM.[CategoryId]and  C1.[ParentCategoryId]<>0
  left join [Tradewise].[dbo].[Category] C2 on C1.ParentCategoryId=C2.Id
  left join [Tradewise].[dbo].[Brand] B  on B.Id=P.BrandId
  where P.StoreId=6
  and P.ProductTypeId=3
  order by P.[ProductNumber]