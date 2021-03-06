/****** Script for SelectTopNRows command from SSMS  ******/
if object_id('tempdb..#temp001') is not null Begin
     drop table #temp001
 End

SELECT
      PIm.[PurchaseOrderNumber]
	  ,S.ReferenceOrderId as OrderReference
      ,PIm.[ProductCode]
      ,PIm.[ProductChineseName]
      ,PIm.[Quantity]
      ,PIm.[ReceiverName]
      ,PIm.[ReceiverCity]
      ,Case when  PIm.BuyerId='HXTMLS' then 'Meilishuo' else PIm.[MallCode] end as MallCode
      ,PIm.[PaymentTime]
	  ,PL.UpdatedOn
      ,PIm.[TrackingNumber]
	  --,S.ShippingStatusId
	  ,PL_1.StatusId
	  ,O1.StatusName
	  ,case when P.StockQuantity<0  then N'缺货'  
	        --when PL_1.StatusId=14 and P.StockQuantity>0 then N'已到货'
			else N'不缺货'
	    end as StockQuantity
		,PIm.[Payment]
		,b.Name as Brand
  into #temp001
  FROM [Tmall51Parcel].[dbo].[ProductImport] PIm 
  left join [Tradewise].[dbo].[Shipment] S on S.TrackingNumber=PIm.TrackingNumber 
  --left join [Tradewise].[dbo].[OrderStatus] O on S.ShippingStatusId=O.Id   --ShippingStatusId is not right in shippment 
  left join (select max( DATEADD(HH, +8,[UpdatedOn] )) as UpdatedOn , TrackingNumber from [Tmall51Parcel].[dbo].[PackageLog] where TrackingNumber is not null and UpdatedOn>'2017-01-01' group by TrackingNumber ) as PL on PL.TrackingNumber=PIm.TrackingNumber
  left join [Tmall51Parcel].[dbo].[PackageLog]  PL_1 on  PL.UpdatedOn=DATEADD(HH, +8,PL_1.[UpdatedOn] ) and PL_1.TrackingNumber=PL.TrackingNumber 
  left join [Tradewise].[dbo].[OrderStatus] O1 on PL_1.StatusId=O1.Id
  left join [Tradewise].[dbo].[Product] P on PIm.[ProductCode]=P.ProductNumber and P.ProductTypeId=3 and P.StoreId=6
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=P.BrandId 
  where 
        S.ShippingStatusId<>-1
		--and PIm.PurchaseOrderNumber='C03-2197893-5296031'
		--and S.ReferenceOrderId='ORDCN0526004818988'
        and
        PIm.TrackingNumber  in (select distinct TrackingNumber from [Tmall51Parcel].[dbo].[PackageLog] 	                                      
										   where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 20 
										          or
												  ([Tmall51Parcel].[dbo].[PackageLog].TrackingNumber is not null
										          and 
												  [Tmall51Parcel].[dbo].[PackageLog].TrackingNumber <>''))
        and
        PIm.TrackingNumber not in (select distinct TrackingNumber from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 29 
										  and  [Tmall51Parcel].[dbo].[PackageLog].TrackingNumber is not null)
        and
		PIm.TrackingNumber not in (select distinct TrackingNumber from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = 200 
										  and  [Tmall51Parcel].[dbo].[PackageLog].TrackingNumber is not null)
	    and
		PIm.TrackingNumber not in (select distinct TrackingNumber from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId = -1 
										  and  [Tmall51Parcel].[dbo].[PackageLog].TrackingNumber is not null)
		
		and PL_1.StatusId<>40     ----shippment and packagelog is not the same when status=40

		--and PL_1.StatusId<>-1 
		and PIm.[PaymentTime]<dateadd(DD,-2,getdate())
	order by ReceiverName


	select 
	   [PurchaseOrderNumber] as '订单号'
	  , OrderReference as '订单参考号'
      ,[ProductCode]   as '商品编号'
      ,[ProductChineseName]  as '商品中文名'
      ,[Quantity]  as '数量'
      ,[ReceiverName] as '收件人'
      ,[ReceiverCity]  as '城市'
      ,MallCode as '商城编码'
      ,[PaymentTime]    as '付款时间'
	  ,UpdatedOn         as '最后更新时间'
      ,[TrackingNumber]  as '订单查询号'
	  ,StatusId         as '状态编号'
	  ,StatusName         as '包裹状态'
	  ,StockQuantity     as '单个商品库存'
	  ,[Payment] as '客户订单金额（包括运费）'
	  ,Brand as '品牌'
	  from #temp001
	  order by  N'收件人'

	--  select * from #temp001
