/*Expire Date*/
/*
SELECT [ProductNumber]
      ,[Name]
      ,[StockQuantity]
      ,[ProductCost]
	  ,[StockQuantity]*[ProductCost] AS Value
	  ,ProductPickupNumber
	  ,CASE WHEN ProductPickupNumber <> '0' THEN CAST(DATEADD(DD, (CAST (ProductPickupNumber AS BIGINT) - 599266080000000000) / 864000000000, '1900-01-01') AS DATE) END AS BestBefore
FROM [Tradewise].[dbo].[Product]
WHERE [IsInWarehouse]=1 AND StoreId=6 AND StockQuantity>0 AND [ProductTypeId]=3 --AND [Deleted]=0
ORDER BY Value DESC


SELECT
	[ProductNumber]
	,[Name]
	,P.[StockQuantity] AS London
	,ISNULL(BSC.[StockQuantity],0) AS BSC
	,P.ProductCost
	,(P.[StockQuantity]+ISNULL(BSC.[StockQuantity],0))*P.ProductCost AS Value
	,CASE WHEN ProductPickupNumber <> '0' THEN CAST(DATEADD(DD, (CAST (ProductPickupNumber AS BIGINT) - 599266080000000000) / 864000000000, '1900-01-01') AS DATE) END AS BestBefore
	FROM [Tmall51Parcel].[dbo].[BSCWarehouseProduct] BSC
RIGHT JOIN [Tradewise].[dbo].[Product] P ON P.productNumber=BSC.ProductCode AND Storeid=6
WHERE p.[IsInWarehouse]=1 AND p.StoreId=6 AND (P.StockQuantity>0 OR BSC.[StockQuantity]>0) AND p.[ProductTypeId]=3 --AND p.[Deleted]=0 --AND P.StockQuantity=0

ORDER BY Value DESC

SELECT
	[ProductNumber]
	,[Name]
	,P.[StockQuantity] AS London
	,ISNULL(BSC.[StockQuantity],0) AS BSC
	,P.ProductCost
	,(P.[StockQuantity]+ISNULL(BSC.[StockQuantity],0))*P.ProductCost AS Value
FROM [Tmall51Parcel].[dbo].[BSCWarehouseProduct] BSC
RIGHT JOIN [Tradewise].[dbo].[Product] P ON P.productNumber=BSC.ProductCode AND Storeid=6
WHERE p.[IsInWarehouse]=1 AND p.StoreId=6 AND (P.StockQuantity<0 OR BSC.[StockQuantity]<0) AND p.[ProductTypeId]=3 AND p.[Deleted]=0 AND P.Published=1 --AND P.StockQuantity=0
ORDER BY Value DESC




SELECT  TOP 1 *
FROM [Tradewise].[dbo].[Product]
WHERE [IsInWarehouse]=1 AND StoreId=6 AND StockQuantity>0 AND [ProductTypeId]=3 AND [Deleted]=0
-----------------------------------------------------------------------------------------
SELECT
	[ProductNumber]
	,[Name]
	,P.[StockQuantity] AS London
	,ISNULL(BSC.[StockQuantity],0) AS Dongguan
	,P.ProductCost
	,case when P.[StockQuantity]>=0 and ISNULL(BSC.[StockQuantity],0)>=0 then(P.[StockQuantity]+ISNULL(BSC.[StockQuantity],0))*P.ProductCost  
	      when P.[StockQuantity]<0 and ISNULL(BSC.[StockQuantity],0)>=0 then ISNULL(BSC.[StockQuantity],0)*P.ProductCost 
	      when P.[StockQuantity]>=0 and ISNULL(BSC.[StockQuantity],0)<0 then P.[StockQuantity]*P.ProductCost
		  when P.[StockQuantity]<0 and ISNULL(BSC.[StockQuantity],0)<0 then 0  
	 end AS Value
	,CASE WHEN ProductPickupNumber <> '0' THEN CAST(DATEADD(DD, (CAST (ProductPickupNumber AS BIGINT) - 599266080000000000) / 864000000000, '1900-01-01') AS DATE) END AS BestBefore
	FROM [Tmall51Parcel].[dbo].[BSCWarehouseProduct] BSC
RIGHT JOIN [Tradewise].[dbo].[Product] P ON P.productNumber=BSC.ProductCode AND Storeid=6
WHERE p.[IsInWarehouse]=1 AND p.StoreId=6 AND (P.StockQuantity>=0 OR BSC.[StockQuantity]>=0) AND p.[ProductTypeId]=3 AND p.[Deleted]=0 --AND P.StockQuantity=0
ORDER BY Value DESC

-----------------------------------------------------------------
*/
--final used for weekly report
/*
SET DATEFIRST 1;
SELECT
	[ProductNumber]
	,[Name]
	,isnull(P.[StockQuantity],0) AS London
	,ISNULL(BSC.[StockQuantity],0) AS Dongguan
	,P.ProductCost
	,case when isnull(P.[StockQuantity],0)<>0 or ISNULL(BSC.[StockQuantity],0)<>0 then( isnull(P.[StockQuantity],0)+ISNULL(BSC.[StockQuantity],0))*P.ProductCost  
	      else 0  
	 end AS Value
	,CASE WHEN ProductPickupNumber <> '0' 
	     THEN cast(DATEADD(DD, (CAST (ProductPickupNumber AS BIGINT) - 599266080000000000) / 864000000000, '1900-01-01') as date) 
		 END AS BestBefore
	FROM [Tmall51Parcel].[dbo].[BSCWarehouseProduct] BSC
RIGHT JOIN [Tradewise].[dbo].[Product] P ON P.productNumber=BSC.ProductCode AND Storeid=6
WHERE p.[IsInWarehouse]=1 AND p.StoreId=6 AND (isnull(P.[StockQuantity],0)<>0 or ISNULL(BSC.[StockQuantity],0)<>0) AND p.[ProductTypeId]=3 AND p.[Deleted]=0 --AND P.StockQuantity=0
ORDER BY Value DESC

-----
*/
SET DATEFIRST 1;
SELECT
	[ProductNumber]
	,p.[Name]
	,P.[StockQuantity] AS London
	,ISNULL(BSC.[StockQuantity],0) AS Dongguan
	,P.ProductCost
	,case when isnull(P.[StockQuantity],0)<>0 or ISNULL(BSC.[StockQuantity],0)<>0 then( isnull(P.[StockQuantity],0)+ISNULL(BSC.[StockQuantity],0))*P.ProductCost  
	      else 0  
	 end AS Value
	,CASE WHEN P.ProductPickupNumber <> '0' THEN CAST(DATEADD(DD, (CAST (ProductPickupNumber AS BIGINT) - 599266080000000000) / 864000000000, '1900-01-01') AS DATE) END AS BestBefore
	FROM [Tmall51Parcel].[dbo].[BSCWarehouseProduct] BSC
right JOIN [Tradewise].[dbo].[Product] P ON P.productNumber=BSC.ProductCode AND Storeid=6
LEFT JOIN [Tradewise].[dbo].[Brand] B on B.id=P.BrandId
WHERE p.[IsInWarehouse]=1 
AND p.StoreId=6 
AND (isnull(P.[StockQuantity],0)<>0 or ISNULL(BSC.[StockQuantity],0)<>0) 
AND p.[ProductTypeId]=3 
AND p.[Deleted]=0  
AND [ProductNumber] NOT IN ('APT-A1','APT-A2','APT-A3','APT-A4','CAG-C1','CAG-C2','CAG-C3','CAG-C4','APT-AP3','APT-AP1','APT-AP2') 
AND (B.[Comment]<>'BD-SO' OR B.[Comment] IS NULL)  
and (B.[Comment]<>'L' OR B.[Comment] IS NULL)  --大英为 Logistics
--and [ProductNumber]='wrs004602'
--and P.[StockQuantity]<0
ORDER BY Value DESC

------------<0----------------------
/*
SET DATEFIRST 1;
SELECT
	[ProductNumber]
	,p.[Name]
	,P.[StockQuantity] AS London
	,ISNULL(BSC.[StockQuantity],0) AS Dongguan
	,P.ProductCost
	,case when isnull(P.[StockQuantity],0)<>0 or ISNULL(BSC.[StockQuantity],0)<>0 then( isnull(P.[StockQuantity],0)+ISNULL(BSC.[StockQuantity],0))*P.ProductCost  
	      else 0  
	 end AS Value
	,CASE WHEN P.ProductPickupNumber <> '0' THEN CAST(DATEADD(DD, (CAST (ProductPickupNumber AS BIGINT) - 599266080000000000) / 864000000000, '1900-01-01') AS DATE) END AS BestBefore
	FROM [Tmall51Parcel].[dbo].[BSCWarehouseProduct] BSC
right JOIN [Tradewise].[dbo].[Product] P ON P.productNumber=BSC.ProductCode AND Storeid=6
LEFT JOIN [Tradewise].[dbo].[Brand] B on B.id=P.BrandId
WHERE p.[IsInWarehouse]=1 
AND p.StoreId=6 
AND (isnull(P.[StockQuantity],0)<0)  --or ISNULL(BSC.[StockQuantity],0)<>0) 
AND p.[ProductTypeId]=3 
AND p.[Deleted]=0  
AND [ProductNumber] NOT IN ('APT-A1','APT-A2','APT-A3','APT-A4','CAG-C1','CAG-C2','CAG-C3','CAG-C4','APT-AP3','APT-AP1','APT-AP2') 
AND (B.[Comment]<>'BD-SO' OR B.[Comment] IS NULL)  
and (B.[Comment]<>'L' OR B.[Comment] IS NULL)  --大英为 Logistics
--and [ProductNumber]='wrs004602'
--and P.[StockQuantity]<0
ORDER BY london 
*/