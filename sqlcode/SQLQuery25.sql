/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      PurchaseOrderNumber , sum(OrderReceivable),avg(OrderReceivable)
      
  FROM [TradewiseFromCN].[dbo].[Order] where StoreId =4 and Deleted=0 group by PurchaseOrderNumber having count (PurchaseOrderNumber )>2 

  SELECT 
     *
      
  FROM [TradewiseFromCN].[dbo].[Order] where  PurchaseOrderNumber='YGD10151052096' and Deleted=0
  
   SELECT 
     * into #tmp1234
      
  FROM [TradewiseFromCN].[dbo].[Order] where  PurchaseOrderNumber='3201604222200036998S0002'  and Deleted=0


  select * from  #tmp1234 group by ReferenceOrderId having count (ReferenceOrderId)>2