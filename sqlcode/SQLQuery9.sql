SELECT P.id
      ,[Paymenttime]
      ,pi.[PurchaseOrderNumber]
      ,Case pi.ProductCode when 'YMZA2' THEN	'APT-A2' WHEN 'YMZA3' THEN 'APT-A3' WHEN 'YMZA4' THEN 'APT-A4' WHEN 'YMZC2' THEN 'CAG-C2' WHEN 'YMZC4' THEN 'CAG-C4' ELSE CAST(pi.ProductCode  AS varchar(20)) END AS "ProductCode"
      ,b.name
	  ,P.name
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[Quantity]
      ,[StatusId]
      ,[MallCode]
      ,[buyerId]
	  ,P.ProductCost
	  ,pi.trackingnumber
  FROM [Tmall51Parcel].[dbo].[ProductImport] pi
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.ProductNumber=pi.ProductCode AND P.STOREID=6
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=p.BrandId
  --Join [Tradewise].[dbo].[shipment] s on s.PurchaseOrderNumber=pi.PurchaseOrderNumber
  WHERE /*[Paymenttime]>='2017-03-27' and [Paymenttime]<'2017-04-13' AND*/ P.STOREID=6 AND pi.[PurchaseOrderNumber] in ('YGD0317000622583',
'YGD0510000848701',
'YGD0511000852825',
'YGD0523000897319',
'YGD0530000924685',
'YGD0629001078125',
'YGD0703001106630',
'YGD0703001106643',
'YGD0707001132586',
'YGDCN0719001203680',
'YGDCN0719001203821',
'YGDCN0816001375296',
'YGDCN0822001403845',
'YGDCN0827001439473',
'YGDCN0905001488995',
'YGDCN0906001498445',
'YGDCN0906001498445',
'YGDCN0906001498437',
'YGDCN0912001534182',
'YGDCN0912001534355',
'YGDCN0918001574266',
'YGDCN0919001580757',
'YGDCN0919001582735',
'YGDCN0926001629852',
'YGDCN0927001637641',
'YGDCN1008001691585',
'YGDCN1008001691231',
'YGDCN1008001691205',
'YGDCN1008001691191',
'YGDCN1010001707152',
'YGDCN1010001707118',
'YGDCN1011001719589',
'YGDCN1011001719558',
'YGDCN1014001743424',
'YGDCN1017001759441',
'YGDCN1024001813598',
'YGDCN1111003073925',
'YGDCN1111003074104',
'YGDCN1124003227216',
'YGDCN1128003283535',
'YGDCN1202003336091',
'YGDCN1202003341370',
'YGDCN1202003341437',
'YGDCN1207003389179',
'YGDCN1208003401351',
'YGDCN1228003577203',
'YGDCN1228003577265',
'YGDCN1228003577398',
'YGDCN1228003577407',
'YGDCN1228003577557',
'YGDCN1228003577565',
'YGDCN1228003577574',
'YGDCN1228003577628',
'YGDCN0103003616865',
'YGDCN0103003617021',
'YGDCN0104003629930',
'YGDCN0110003678175',
'YGDCN0110003678272',
'YGDCN0111003685636',
'YGDCN0116003716404',
'YGDCN0116003716470',
'YGDCN0116003716571',
'YGDCN0124003750198',
'YGDCN0204003794171',
'YGDCN0206003817955',
'YGDCN0206003818108',
'YGDCN0206003818638',
'YGDCN0206003818862',
'YGDCN0206003818955',
'YGDCN0206003819085',
'YGDCN0209003880365',
'50003454954',
'YGDCN0216003983192',
'YGDCN0217003993549',
'YGDCN0221004042831',
'YGDCN0227004094564',
'YGDCN0227004094555',
'YGDCN0227004097234',
'YGDCN0227004103805',
'YGDCN0301004137300',
'C03-8806103-7736808',
'YGDCN0308004224043',
'YGDCN0308004226733',
'YGDCN0309004232053',
'YGDCN0309004234686',
'YGDCN0309004241188',
'YGDCN0309004232946',
'YGDCN0310004252177',
'YGDCN0313004270944',
'YGDCN0315004304603')
