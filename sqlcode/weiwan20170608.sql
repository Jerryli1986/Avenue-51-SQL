/****** Script for SelectTopNRows command from SSMS  ******/
---old new sku
SELECT 
        PIm.[PaymentTime],
       [PurchaseOrderNumber],
       PIm.[ProductCode]  as Productimportcode
	   ,P1.ProductNumber  as New_yuanzicode
	   ,PG.[ProductGroupNumber]  as Old_yuanzicode
      ,PIm.[VendorSKU]
      ,PIm.[RegisterCode]
      ,PIm.[ProductChineseName]
      ,PIm.[ProductEnglishName]
      ,PIm.[MallCode]
      --,PIm.[VendorCode]
      --,PIm.[Barcode]
      ,PIm.[OriginalProductCode]
	  ,PIm.[Payment]
      ,PIm.[DiscountFee]
      ,PIm.[OrderPayment]
      ,PIm.[UnitPrice]
	  ,PIm.[Quantity]
	  ,PIm.[TrackingNumber]
	  ,PIm.[buyerId]
	  --,b.Name
	  --,P.[Published]
  FROM [Tmall51Parcel].[dbo].[ProductImport] PIm
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.ProductNumber=PIm.ProductCode AND (P.STOREID=6) --原子和组合商品都有
  left join (
             select [ProductId],[ProductGroupNumber],[Quantity]from
                   (select max([ProductId]) as [ProductId] ,max([ProductGroupNumber]) as [ProductGroupNumber]  ,sum([Quantity]) as [Quantity] 
                   from [Tradewise].[dbo].[ProductGroup] 
		           group by [ProductGroupNumber] 
		          having sum( [Quantity])=1 ) PG0
			  left join [Tradewise].[dbo].[Product] P0 on P0.ProductNumber=PG0.[ProductGroupNumber] and P0.STOREID=6
			  where P0.[Published]=1  
			    ) PG	       on PG.[ProductId]=P.Id  
  LEFT JOIN [Tradewise].[dbo].[Product] P1 ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=P.BrandId
  where  PIm.StatusId<>-1 
        and PIm.[ProductCode]=P1.ProductNumber 
		and PIm.[ProductCode]<>PG.[ProductGroupNumber]
		and P1.ProductNumber is not null
		and PIm.[OriginalProductCode] is not null
	--	and [PurchaseOrderNumber]='22897780627140203'
	--	and PIm.[PaymentTime]>'2017-05-01' and PIm.[PaymentTime]<'2017-06-01'

	order by PaymentTime, PurchaseOrderNumber