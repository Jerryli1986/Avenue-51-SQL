
Declare @BegDate date
declare @EndDate date

set @BegDate='2017-06-01'
set @EndDate='2017-07-01'
SELECT PI.id
      ,PaymentTime
      ,PI.[PurchaseOrderNumber]
      ,ISNULL(P1.ProductNumber, PI.ProductCode) AS ProductCode
      ,b.name
	  ,P.name
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,PI.[Quantity]
      ,[StatusId]
      ,[MallCode]
      ,[buyerId]   
	  ,P.ProductCost
	  ,pi.trackingnumber
	  ,PI.[TMOId]
  FROM [Tmall51Parcel].[dbo].[ProductImport] PI
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.ProductNumber=pi.ProductCode --AND (P.STOREID=6) 
  lEFT JOIN [Tradewise].[dbo].[ProductGroup] PG ON PG.[ProductGroupNumber]=PI.ProductCode     --组合商品中其实有些为了修改代码，而不是真正的组合，原子商品中老sku 变新sku，是在组合中改
  LEFT JOIN [Tradewise].[dbo].[Product] P1 ON P1.Id=PG.[ProductId] -- AND P1.STOREID=6 AND P1.ProductTypeId=3
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=p.BrandId
  --Join [Tradewise].[dbo].[shipment] s on s.PurchaseOrderNumber=pi.PurchaseOrderNumber
  WHERE   --[Paymenttime]>=@BegDate and [Paymenttime]<@EndDate 
          P.STOREID=6 --AND p.name LIKE N'%???????%' 
		--AND buyerid='HXTMLS' 
         --AND StatusId<>-1
		 and  MallCode like '%Tmall%'
		-- and PI.Id=335831
		 and PurchaseOrderNumber like '%22996263916078328%'
/*
         and PI.[PurchaseOrderNumber] in ('16433743657129002',
'17153722408902357',
'13924742546096418',
'19261363765528906',
'20774930914394666',
'15354880013585215',
'26238270432918398',
'21351308052024579',
'21287948798363863',
'21329490263576877',
'21329490262576877',
'22695291412379668',
'21329490264576877',
'18880401053947501',
'17280522168293102',
'18659821972871754',
'21496163690972321',
'22841740233092411',
'18189301461326013',
'25864611161248484',
'22123708875358693',
'25058029378968491',
'22307369036082662',
'14567340700086814',
'21263531392128586',
'18272361588912700',
'24005330207511268',
'23850850616450061',
'24093188925450061',
'24094328567450061',
'25097028066450061',
'2606404361707825',
'17183662850944717',
'20835801903830353',
'24648840785749421',
'24582502538695807',
'5431036581052231',
'27675349905176261',
'6490077514410140',
'5226636230935042',
'25215370987813576',
'5875457455617235',
'5875457456617235',
'7448517492365252',
'25095201289062213'


) */
  ORDER BY [Paymenttime] ASC