/****** Script for SelectTopNRows command from SSMS  ******/
-- these shipped order has some problem before shipped (details)	
SELECT 

     distinct [Notes]
	 ,[OrderReference]
	 ,[TrackingNumber]
	 ,UpdatedOn
	 ,[StatusId]
     
  FROM [Tmall51Parcel].[dbo].[PackageLog]
  where Notes is not null and Notes not like ''
        and TrackingNumber is not null
		and OrderReference in 
		(select distinct OrderReference from [Tmall51Parcel].[dbo].[PackageLog] 
		  where [StatusId]=29)
-- these shipped order has some problem before shipped
select distinct T.[Notes],T.[StatusId]
from(
SELECT 

     distinct [Notes]
	 ,[OrderReference]
	 ,[TrackingNumber]
	 ,UpdatedOn
	 ,[StatusId]
     
  FROM [Tmall51Parcel].[dbo].[PackageLog]
  where Notes is not null and Notes not like ''
        and TrackingNumber is not null
		and OrderReference in (select distinct OrderReference from [Tmall51Parcel].[dbo].[PackageLog] where [StatusId]=29)
) as T

--商品下单失败: 您在本次付款中，如果使用包税专线，请务必保证同一地址多箱发货时，使用不同的收件人姓名和电话
SELECT [OrderReference]
	 ,[TrackingNumber]
	 ,UpdatedOn
	 ,[StatusId] from [Tmall51Parcel].[dbo].[PackageLog] 
where OrderReference is not null 
      and Notes like N'%商品下单失败: 您在本次付款中，如果使用包税专线，请务必保证同一地址多箱发货时%'


--您在跨境易系统中有相同收件人地址的订单还未生成提货单，本订单不能导入
SELECT [OrderReference]
	 ,[TrackingNumber]
	 ,UpdatedOn
	 ,[StatusId] from [Tmall51Parcel].[dbo].[PackageLog] 
where Notes like N'%您在跨境易系统中有相同收件人地址的订单还未生成提货单，本订单不能导入%'

