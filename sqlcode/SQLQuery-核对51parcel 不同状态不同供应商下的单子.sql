/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
--distinct [ShippingStatusId]
   --distinct substring(ReferenceOrderId,1,3)
   *
  FROM [Tradewise].[dbo].[Shipment]
  where [StoreId]=7
  and [ServiceProviderId]=101
  and [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)
 -- and substring(ReferenceOrderId,1,3)not in ('OWE','EXP')
  --and ReferenceOrderId='ORD02271358028'
 -- and TrackingNumber='EA971627889BE'
  and PaidDateUtc>='2015-01-01'
  order by PaidDateUtc


  ---[ShippingStatusId] not in (-1,40,41,57,58,59,60,61) and [ServiceProviderId]=0 and substring(ReferenceOrderId,1,3)not in ('OWE','EXP') 发现数据截至到2016年9月，订单为箱子包材,PurchaseOrderNumber 为PRD
  ---[ShippingStatusId] not in (-1,40,41,57,58,59,60,61) and [ServiceProviderId]=0 and substring(ReferenceOrderId,1,3)  in ('OWE')  发现数据从2016年4月开始至今，补交款的运费
  ---[ShippingStatusId] not in (-1,40,41,57,58,59,60,61) and [ServiceProviderId]=0 and substring(ReferenceOrderId,1,3)  in ('EXP')  发现数据截至到2016年1月到2017年8月只有3条，补交款

  ---菜鸟物流-10
  -- and [ServiceProviderId]=10  and [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)  and substring(ReferenceOrderId,1,3)in ('OWE','EXP') 数据截至到2016年3月，但之后有3个单子
   -- and [ServiceProviderId]=10  and [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)  and substring(ReferenceOrderId,1,3)not in ('OWE','EXP') 数据截至到2016年9月，但之后有3个单子


   -- and [ServiceProviderId]=12  and [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)  数据截至到2016年9月份

   --and [ServiceProviderId]=23  and [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)  数据截至到2016年9月份   包含BE和TX

    --and [ServiceProviderId]=32  and [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)  从2017年8月份  圆通

	 --and [ServiceProviderId]=101  and [ShippingStatusId] not in (-1,40,41,57,58,59,60,61)  截至到从2015年5月份 属于uk service 

  订单ORD02271358028的补款订单(Imported20160920)

  SELECT 
   distinct [ServiceProviderId]
  FROM [Tradewise].[dbo].[Shipment]
  where [StoreId]=7
  --and TrackingNumber='EK217855137HK'


   SELECT top 100
--distinct [ShippingStatusId]
   --distinct substring(ReferenceOrderId,1,3)
   *
  FROM [Tradewise].[dbo].[Shipment]
  where [StoreId]=7
 -- and TrackingNumber='EK217855137HK'
   and TrackingNumber='EK217560296HK'