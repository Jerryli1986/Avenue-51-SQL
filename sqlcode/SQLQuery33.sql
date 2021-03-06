/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [StoreCustomer_Id]
      ,[PriceGroup_Id]
  FROM [TradewiseFromCN].[dbo].[StoreCustomer_PriceGroup_Mapping]
  where PriceGroup_Id=777


  SELECT DISTINCT StoreCustomerId,COUNT(DISTINCT Referenceorderid) AS Orders
FROM [Tradewise].[dbo].[Order] O
JOIN [Tradewise].[dbo].[OrderStatus_OrderType_Mapping] oom 
with(nolock) on oom.[OrderStatusId]=o.OrderStatusId 
AND oom.[OrderTypeId]=188
LEFT JOIN [Tradewise].[dbo].[StoreCustomer_PriceGroup_Mapping] SPM ON SPM.[StoreCustomer_Id]=O.StoreCustomerId
WHERE [PaiddateUtc]>='2016-09-01' AND [PaiddateUtc]<'2017-03-01' 
AND SUBSTRING(Referenceorderid,1,3) in('MPD') 
and ShipToName not like N'测试单' 
AND [PriceGroup_Id] NOT IN (776,777,778,779,819) AND Storeid=1
GROUP BY StoreCustomerId
ORDER BY COUNT(DISTINCT Referenceorderid) DESC