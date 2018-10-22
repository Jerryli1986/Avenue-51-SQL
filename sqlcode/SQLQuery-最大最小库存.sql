
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
	  ,StandardCase
  into #temp700
  FROM [Tradewise].[dbo].[Product] P
  left join [Tradewise].[dbo].Brand on Brand.Id=P.BrandId
  where P.storeid=6 and P.[ProductTypeId]=3 and [IsInWarehouse]=1 
  --select * from #temp700
-------------------Min&Max stock-------------add MPD from Order-----------
Declare @BegDate date
declare @EndDate date
set @EndDate='2017-04-16'
set @BegDate=DATEADD(month, -6, @EndDate);
---------------------------------------------------------

Declare @Beg  date
Declare @End  date
declare @i int
set @i=1
set @Beg=@BegDate
set @End=DATEADD(month, 1, @Beg)

 while (@End<=@EndDate)
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
		--	DECLARE @WeeklyReport_0 table(ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max))
		--	DECLARE @WeeklyReport_1 table(ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max),Totalcost decimal(18,2) ,Revenue   decimal(18,2) ,Commission float(2),Exchangerate decimal(18,2),commissionrate decimal(18,2))
	        create table #WeeklyReport_0 
			           (ProductId int,Paymenttime datetime, PurchaseOrderNumber varchar(max), ProductCode varchar(max), Brand nvarchar(max), ProductName nvarchar(max),  Payment decimal(18,2), DiscountFee decimal(18,2), OrderPayment decimal(18,2), Quantity int, StatusId int, MallCode varchar(max), buyerId varchar(max), Cost decimal(18,2), TrackingNumber varchar(max))
		
			Declare @ProductId int
			DECLARE @Paymenttime datetime
			DECLARE @PurchaseOrderNumber varchar(max)
			DECLARE @ProductCode nvarchar(max)
			DECLARE @Brand nvarchar(max)
			DECLARE @ProductName nvarchar(max)
			DECLARE @Payment decimal(18,2)
			DECLARE @DiscountFee decimal(18,2)
			DECLARE @OrderPayment decimal(18,2)
			DECLARE @Quantity int
			DECLARE @StatusId int
			DECLARE @MallCode varchar(max)
			DECLARE @buyerId nvarchar(max)
			DECLARE @Cost decimal(18,2)
			DECLARE @TrackingNumber varchar(max)
			declare @Totalcost decimal(18,2) 
			declare @Revenue   decimal(18,2)
			declare	@Commission decimal(18,2)
			declare	@Exchangerate decimal(18,2)
			declare @commissionrate decimal(18,2)
	DECLARE db_cursor CURSOR FOR

			SELECT P.id
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
			  FROM [Tmall51Parcel].[dbo].[ProductImport]  PI WITH(NOLOCK)
			  LEFT JOIN [Tradewise].[dbo].[Product] P WITH(NOLOCK) ON P.ProductNumber=pi.ProductCode AND (P.STOREID=6) 
			  lEFT JOIN [Tradewise].[dbo].[ProductGroup] PG WITH(NOLOCK) ON PG.[ProductGroupNumber]=PI.ProductCode     --组合商品中其实有些为了修改代码，而不是真正的组合，原子商品中老sku 变新sku，是在组合中改
			  LEFT JOIN [Tradewise].[dbo].[Product] P1 WITH(NOLOCK) ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
			  LEFT JOIN [Tradewise].[dbo].[Brand] b WITH(NOLOCK) on b.id=p.BrandId
			  --Join [Tradewise].[dbo].[shipment] s WITH(NOLOCK) on s.PurchaseOrderNumber=pi.PurchaseOrderNumber
			  WHERE [Paymenttime]>=@Beg and [Paymenttime]<@End 
					AND P.STOREID=6 --AND p.name LIKE N'%???????%' --AND buyerid='HXTMLS' 
                    AND StatusId<>-1
		            and [buyerId] not in ('51parcel-linda','51parcel-buddy','51parcel-Queenie')
		            and [buyerId] not like N'测试%'
		            and mallcode<>'TmallDYBWG'
					and mallcode<>'TmallNord'
			  ORDER BY [Paymenttime] ASC


			OPEN db_cursor
			FETCH NEXT FROM db_cursor
			INTO @ProductId, @Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand, @ProductName, @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId, @Cost, @TrackingNumber
			WHILE @@FETCH_STATUS = 0
			BEGIN

				if exists (select * from [Tradewise].[dbo].[ProductLog] where ProductId=@ProductId and [UpdatedColumn]=N'ProductCost(??)' and [LoggedOnUtc]<=@Paymenttime)
				begin
					select top 1 @Cost = cast([OriginalValue] as decimal(18,2)) from [Tradewise].[dbo].[ProductLog] where ProductId=@ProductId and [UpdatedColumn]=N'ProductCost(??)' and [LoggedOnUtc]<=@Paymenttime order by Id desc
        
				end
				if @ProductCode='YMZA1'
				   set @ProductCode='APT-A1'
				else if @ProductCode='YMZA2'
				   set @ProductCode='APT-A2'
				else if @ProductCode='YMZA3'
				   set @ProductCode='APT-A3'
				else if @ProductCode='YMZA4'
				   set @ProductCode='APT-A4'
				else if @ProductCode='YMZC1'
				   set @ProductCode='CAG-C1'
				else if @ProductCode='YMZC2'
				   set @ProductCode='CAG-C2'
				else if @ProductCode='YMZC3'
				   set @ProductCode='CAG-C3'
				 else if @ProductCode='YMZC4'
				   set @ProductCode='CAG-C4'

				IF @BuyerId='HXTMLS' 
				Begin
				 set @Mallcode='Meilishuo'
				End

				insert into #WeeklyReport_0 values(@ProductId,@Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand,@ProductName, @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId, @Cost, @TrackingNumber)

			FETCH NEXT FROM db_cursor
			INTO @ProductId, @Paymenttime,  @PurchaseOrderNumber, @ProductCode, @Brand, @ProductName,  @Payment, @DiscountFee, @OrderPayment, @Quantity, @StatusId, @MallCode, @buyerId,  @Cost, @TrackingNumber
			END

			CLOSE db_cursor
			DEALLOCATE db_cursor

			select * into #Report_0 from #WeeklyReport_0
			
			SELECT WRJ.Paymenttime,  WRJ.PurchaseOrderNumber, WRJ.ProductCode, WRJ.Brand, WRJ.ProductName, WRJ.Payment, WRJ.DiscountFee, WRJ.OrderPayment, WRJ.Quantity, WRJ.StatusId, WRJ.MallCode, PI.buyerId, WRJ.Cost, WRJ.TrackingNumber
			into #temp500
			FROM #Report_0  WRJ
			LEFT JOIN (SELECT DISTINCT PurchaseOrderNumber, Buyerid FROM [Tmall51Parcel].[dbo].[ProductImport] ) AS pi ON (PI.PurchaseOrderNumber=WRJ.PurchaseOrderNumber collate Latin1_General_CI_AS)
			where WRJ.PurchaseOrderNumber not like '%MPD%'
			--select * from #revenue_temp1 where MallCode='Meilishuo' order by Paymenttime
			------------MPD from Order---------
			select 
				  O.[PaidDateUtc] as [Paymenttime]
				  ,O.[ReferenceOrderId] as PurchaseOrderNumber
				  ,case when OI.[ProductNumber]='YMZA1' then 'APT-A1'  
						when OI.[ProductNumber]='YMZA2' then 'APT-A2'  
						when OI.[ProductNumber]='YMZA3' then 'APT-A3'  
						when OI.[ProductNumber]='YMZA4' then 'APT-A4'  
						when OI.[ProductNumber]='YMZC1' then 'CAG-C1'  
						when OI.[ProductNumber]='YMZC2' then 'CAG-C2' 
						when OI.[ProductNumber]='YMZC3' then 'CAG-C3' 
						when OI.[ProductNumber]='YMZC4' then 'CAG-C4'  end
				  as ProductCode 
				  ,[Platform] as Brand       --in order to  add a column
				  ,OI.ProductName
				  ,O.OrderTotal as [Payment]
				  ,O.[OrderSubTotalDiscount]+O.[OrderShippingDiscount] as [DiscountFee]
				  ,O.OrderTotal  as OrderPayment 
				  ,OI.[Quantity]
				  ,O.OrderStatusId as [StatusId]
				  ,'WebAPI_51taouk.com' as [MallCode]
				  ,O.CustomerIp as [buyerId]
				  ,OI.UnitPrice as [Cost]
				  ,O.[TrackingNumber]
			into #temp600
			FROM [Tradewise].[dbo].[Order] O WITH(NOLOCK)
			left join [Tradewise].[dbo].[OrderItem] OI WITH(NOLOCK) on O.Id=OI.OrderId
			where ReferenceOrderId like '%MPD%' 
			and O.[PaidDateUtc]>=@Beg and O.[PaidDateUtc]<@End
			and O.Deleted =0 and O.[PaidDateUtc] is not null

			----------------------------------

			select P.ProductNumber as ProductCode,
				   B.Name  as Brand,
				   P.name as ProductName,
				   P.ProductCost as Cost
			 into #temp400
			 from [Tradewise].[dbo].[Product] P 
			  LEFT JOIN [Tradewise].[dbo].[Brand] B on B.id=P.BrandId



			update #temp600
			set #temp600.Brand=#temp400.Brand
			from #temp600
			inner join #temp400 on #temp600.ProductCode=#temp400.ProductCode collate Latin1_General_CI_AS
			where #temp600.PurchaseOrderNumber like '%MPD%'

			update #temp600
			set #temp600.ProductName=#temp400.ProductName
			from #temp600
			inner join #temp400 on #temp600.ProductCode=#temp400.ProductCode collate Latin1_General_CI_AS
			where #temp600.PurchaseOrderNumber like '%MPD%'

			update #temp600
			set #temp600.Cost=#temp400.Cost
			from #temp600
			inner join #temp400 on #temp600.ProductCode=#temp400.ProductCode collate Latin1_General_CI_AS
			where #temp600.PurchaseOrderNumber like '%MPD%'


			Insert into #temp500 
			select Paymenttime, PurchaseOrderNumber, ProductCode, Brand, ProductName, Payment, DiscountFee, OrderPayment, Quantity, StatusId, MallCode, buyerId, Cost, TrackingNumber from #temp600
			--select @End

		   declare @sql_1 nvarchar(4000)
		   declare @sql_2 nvarchar(4000)
		   declare @title nvarchar(21)
		   set @title ='M'+convert(varchar(6),@Beg,112)
		   
		   set @sql_1='alter table #temp700 add '+@title +' int'
		   exec(@sql_1)

		   set @sql_2='update #temp700 set '+ @title +' =T.quantitysum  from( Select  ProductCode ,sum([Quantity]) as quantitysum from #temp500  group by ProductCode) T where #temp700.ProductNumber=T.ProductCode collate Latin1_General_CI_AS'
           exec(@sql_2)

		    set @Beg= DATEADD(month, 1, @Beg);
			set @End= DATEADD(month, 1, @End);
			set @i=@i+1
		end
		select * from #temp700 