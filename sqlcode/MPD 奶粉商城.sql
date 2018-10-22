SELECT O.ID
,O.[PaiddateUtc]
,O.[ReferenceOrderId]
,CASE OI.ProductNumber WHEN 'YMZA1' THEN 'APT-A1' WHEN 'YMZA2' THEN 'APT-A2' WHEN 'YMZA3' THEN 'APT-A3' WHEN 'YMZA4' THEN 'APT-A4' WHEN 'YMZC1' THEN 'CAG-C1'WHEN 'YMZC2' THEN 'CAG-C2' WHEN 'YMZC3' THEN 'CAG-C3' WHEN 'YMZC4' THEN 'CAG-C4' ELSE CAST(OI.Productnumber  AS varchar(20)) END AS "ProductCode"
--,b.name AS Brand
--,p.name
--,p.[ProductEnglishName]
,O.OrderReceivable
,o.[OrderSubtotal]
,o.[OrderShipping]
,OI.quantity
,OI.statusid
,O.storeid 
,o.storecustomerid
,oi.ProductCost
,o.trackingnumber
--,s.ServiceProviderId
--select distinct O.Referenceorderid, o.trackingnumber
FROM [Tradewise].[dbo].[Order] O 
inner JOIN [Tradewise].[dbo].[OrderItem] OI ON O.ID=OI.ORDERID
--JOIN [Tradewise].[dbo].[Product] P ON P.ProductNumber=oi.Productnumber AND P.STOREID=1
--JOIN [Tradewise].[dbo].[Brand] b ON b.id=p.BrandId
JOIN [Tradewise].[dbo].[OrderStatus_OrderType_Mapping] oom with(nolock) on oom.[OrderStatusId]=o.OrderStatusId AND oom.[OrderTypeId]=188
--INNER JOIN Shipment s with(nolock) on s.PurchaseOrderNumber=o.ReferenceOrderId
WHERE O.[PaiddateUtc]>='2017-04-10' AND O.[PaiddateUtc]<'2017-04-17' AND SUBSTRING(O.Referenceorderid,1,3) in('MPD') and O.ShipToName not like N'测试单' 
