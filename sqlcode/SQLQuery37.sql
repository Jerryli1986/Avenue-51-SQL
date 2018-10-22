
/****** Script for SelectTopNRows command from SSMS  ******/
use [TradewiseFromCN]
SELECT 
      [TradewiseFromCN].[dbo].[Order].[StoreCustomerId],
	  ReferenceOrderId ='MPD ',
      count([TradewiseFromCN].[dbo].[Order].[StoreCustomerId]) as Totalorder
	  ,sum([TradewiseFromCN].[dbo].[Order].OrderSubtotal) as sum_OrderSubtotal
	  ,sum([TradewiseFromCN].[dbo].[Order].OrderShipping) as sum_OrderShipping
	  ,sum([TradewiseFromCN].[dbo].[Order].OrderTotal) as sum_OrderTotal
	  
  FROM [TradewiseFromCN].[dbo].[Order] 
  where  CreatedOnUtc>='2016-09-01' 
         and CreatedOnUtc<'2016-11-26 ' 
		 and ReferenceOrderId like 'MPD%'
		 and StoreCustomerId   in
		     (SELECT [StoreCustomer_Id]
                      FROM [TradewiseFromCN].[dbo].[StoreCustomer_PriceGroup_Mapping]
                      where PriceGroup_Id not in (776,777,778,779,819))
         and  [TradewiseFromCN].[dbo].[Order].OrderStatusId in (
		                Select OrderStatusId from
		                [TradewiseFromCN].[dbo].[OrderStatus_OrderType_Mapping]
                        where [TradewiseFromCN].[dbo].[OrderStatus_OrderType_Mapping].[OrderTypeId]=188)
              
			  
 group by StoreCustomerId
 order by Totalorder desc