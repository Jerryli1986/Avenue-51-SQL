
  ------find productcode------
  if object_id('tempdb..#temp700') is not null Begin
     drop table #temp700
  End

  SELECT 
      [ProductNumber]
	  ,P.Name as ProductName
	  ,Brand.Name as Brand
	  ,Brand.comment
	  ,case when P.[Published]=1 then 'Published' 
	         else 'Non_Published' end
			 as Published
	 -- ,StandardCase
	 ,P.[StockQuantity]
  into #temp700
  FROM [Tradewise].[dbo].[Product] P
  left join [Tradewise].[dbo].Brand on Brand.Id=P.BrandId
  where P.storeid=6 and P.[ProductTypeId]=3 and [IsInWarehouse]=1 and [Tradewise].[dbo].Brand.Name like '%TheBritishMuseum%'
--  select * from #temp700
-------------------Min&Max stock-------------add MPD from Order-----------
Declare @BegDate date
declare @EndDate date
set @EndDate='2017-09-16'
set @BegDate=DATEADD(day, -60, @EndDate);
---------------------------------------------------------

Declare @Beg  date
Declare @End  date
declare @i int
set @i=1
set @End=@EndDate
set @Beg=DATEADD(day, -1, @End)

 while (@Beg>=@BegDate)
   begin  
			if object_id('tempdb..#temp600') is not null Begin
				 drop table #temp600
			 End
			if object_id('tempdb..#temp500') is not null Begin
				 drop table #temp500
			 End
			 if object_id('tempdb..#temp400') is not null Begin
				 drop table #temp400
			 End

			 if object_id('tempdb..#revenue_temp4') is not null Begin
				 drop table #revenue_temp4
			 End
			 if object_id('tempdb..#revenue_temp1') is not null Begin
				 drop table #revenue_temp1
			 End
			 --------
			  if object_id('tempdb..#Report_0') is not null Begin
				 drop table #Report_0
			 End
			 if object_id('tempdb..#Report_1') is not null Begin
				 drop table #Report_1
			 End
			 if object_id('tempdb..#WeeklyReport_0') is not null Begin
				 drop table #WeeklyReport_0
			 End
			 if object_id('tempdb..#WeeklyReport_1') is not null Begin
				 drop table #WeeklyReport_1
			 End
			
			-------------------------------------
  

	        select Sales.ProductCode
			       ,sum(Sales.[Quantity]) as Total_Quantity
			into #temp500
			from
			(
			SELECT P.id
				  ,PI.[PurchaseOrderNumber]
				  ,ISNULL(P1.ProductNumber, PI.ProductCode) AS ProductCode
				  ,b.name  as brands
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
			  FROM [Tmall51Parcel].[dbo].[ProductImport]  PI WITH(NOLOCK)
			  LEFT JOIN [Tradewise].[dbo].[Product] P WITH(NOLOCK) ON P.ProductNumber=pi.ProductCode AND (P.STOREID=6) 
			  lEFT JOIN [Tradewise].[dbo].[ProductGroup] PG WITH(NOLOCK) ON PG.[ProductGroupNumber]=PI.ProductCode     --组合商品中其实有些为了修改代码，而不是真正的组合，原子商品中老sku 变新sku，是在组合中改
			  LEFT JOIN [Tradewise].[dbo].[Product] P1 WITH(NOLOCK) ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
			  LEFT JOIN [Tradewise].[dbo].[Brand] b WITH(NOLOCK) on b.id=p.BrandId
			  WHERE [Paymenttime]>=@Beg and [Paymenttime]<@End 
					AND P.STOREID=6 --AND p.name LIKE N'%???????%' --AND buyerid='HXTMLS' 
                    AND StatusId<>-1
		            and [buyerId] not in ('51parcel-linda','51parcel-buddy')
		            and [buyerId] not like N'测试%'
		            and mallcode='TmallDYBWG'
			  )  Sales
			  group by Sales.ProductCode

			----------------------------------
		   declare @sql_1 nvarchar(4000)
		   declare @sql_2 nvarchar(4000)
		   declare @title nvarchar(21)
		   set @title ='D'+convert(varchar(8),@Beg,112)
		   
		   set @sql_1='alter table #temp700 add '+@title +' int'
		   exec(@sql_1)

		   set @sql_2='update #temp700 set '+ @title +' =T.quantitysum  from( Select  ProductCode ,Total_Quantity as quantitysum from #temp500  ) T where #temp700.ProductNumber=T.ProductCode collate Latin1_General_CI_AS'
           exec(@sql_2)

		    set @Beg= DATEADD(day, -1, @Beg);
			set @End= DATEADD(day, -1, @End);
			set @i=@i+1
		end
		select * from #temp700 