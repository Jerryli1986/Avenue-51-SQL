/****** Script for SelectTopNRows command from SSMS  ******/
use Jerry_DB
if object_id('tempdb..#revenue_temp4') is not null Begin
     drop table #revenue_temp4
 End
 if object_id('tempdb..#revenue_temp1') is not null Begin
     drop table #revenue_temp1
 End

  select     [PurchaseOrderNumber], 
              
                 avg(OrderPayment)-avg(DiscountFee) as drafpayment,
                  avg([Payment]) as payments, 
					 sum(TotalCost) as totalcosts,
					 sum(Quantity)  as totalquantity,
					 avg([Payment])/sum(Quantity) as avgbyquantity,
					 avg([Payment])/isnull(nullif(sum(TotalCost),0),1) as avgbycost

  into #revenue_temp4 
  from [Jerry_DB].[dbo].[Revenue_support]
  group by [PurchaseOrderNumber] 
  
  select [Paymenttime]
      ,R.[PurchaseOrderNumber]
      ,[ProductCode]
      ,R.[Brand]
      ,[ProductName]
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[Quantity]
      ,[StatusId]
      ,R.[MallCode]
      ,[buyerId]
      ,[Cost]
      ,[TrackingNumber]
      ,[TotalCost]
      ,case when totalcosts=0 then #revenue_temp4.avgbyquantity*R.Quantity
			else #revenue_temp4.avgbycost*R.TotalCost
	        end as  [Revenue]
      ,Commissiontable.commissionrate
	    as [Commission]
		,R.Exchangerate
	 into #revenue_temp1
	   from [Jerry_DB].[dbo].[Revenue_support] R
  left join #revenue_temp4 on R.[PurchaseOrderNumber]=#revenue_temp4.PurchaseOrderNumber 
  left join Commissiontable on Commissiontable.Brand=R.Brand and R.[MallCode]=Commissiontable.[MallCode]
  


 select [Paymenttime]
      ,[PurchaseOrderNumber]
      ,[ProductCode]
      ,[Brand]
      ,[ProductName]
      ,[Payment]
      ,[DiscountFee]
      ,[OrderPayment]
      ,[Quantity]
      ,[StatusId]
      ,[MallCode]
      ,[buyerId]
      ,[Cost]
      ,[TrackingNumber]
      ,[TotalCost]
	  ,[Revenue]
	  ,isnull([Revenue]*[Commission],0) as [Commission]
	  ,Exchangerate
	  from #revenue_temp1
