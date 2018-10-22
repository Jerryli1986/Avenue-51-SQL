---old new customer monthly  with revenue
--- the sum payment is calculated when there is ShipToCellPhone 

SET DATEFIRST 1;
Declare @BegDate date
declare @EndDate date
declare @mallcode varchar(max)
set @BegDate='2015-01-01'
set @EndDate='2017-06-19'  -- only change this to date of Monday
set @mallcode='TMall'
--JD
--TMall
--Amazon
--WebAPI_Daifa.51Parcel.com
--WebAPI_51taouk.com
--WebAPI_www.51uktao.com
--WebAPI_51cpk.com
--NetEase
--AVE_WWW
--AVE_JIV
--AVE_LWS
--AVE_NUT
--WebAPI_www.easybest.ie


if object_id('tempdb..#temp100') is not null Begin
     drop table #temp100
 End
 if object_id('tempdb..#temp200') is not null Begin
     drop table #temp200
 End
 if object_id('tempdb..#temp300') is not null Begin
     drop table #temp300
 End
  if object_id('tempdb..#temp400') is not null Begin
     drop table #temp400
 End
SELECT 
       distinct
       convert(varchar(10), [Paymenttime], 120)  as [Paymenttime]
      ,PI.[PurchaseOrderNumber]
      ,[MallCode]
      ,[buyerId]
	  ,[Payment]   
	  ,pi.trackingnumber
	  ,s.ShipToCellPhone
  into #temp100	  
  FROM [Tmall51Parcel].[dbo].[ProductImport] PI
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.ProductNumber=pi.ProductCode AND (P.STOREID=6) 
  lEFT JOIN [Tradewise].[dbo].[ProductGroup] PG ON PG.[ProductGroupNumber]=PI.ProductCode     --组合商品中其实有些为了修改代码，而不是真正的组合，原子商品中老sku 变新sku，是在组合中改
  LEFT JOIN [Tradewise].[dbo].[Product] P1 ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=p.BrandId
  left Join [Tradewise].[dbo].[shipment] s on s.PurchaseOrderNumber=pi.PurchaseOrderNumber
  WHERE [Paymenttime]>=@BegDate and [Paymenttime]<@EndDate --AND P.STOREID=6 --AND p.name LIKE N'%???????%' --AND buyerid='HXTMLS' 
         AND StatusId<>-1
        and [MallCode] like @mallcode
		and s.ShipToCellPhone is not null
  ORDER BY [Paymenttime] ASC

 --select distinct datepart(yyyy,[Paymenttime]) as yyyy,datepart(mm,[Paymenttime]) as mm,datepart(dd,[Paymenttime]) as dd,[Paymenttime], ShipToCellPhone 
 -- from #temp100  
 -- ORDER BY [Paymenttime] ASC


 DECLARE @CustomerTable TABLE (Nums int, weeks date,  oldcustomer INT,totalcustomer INT,oldpayment decimal(18,2),totalpayment decimal(18,2))
 declare @oldcustomer as int
 declare @totalcustomer as int
 set @oldcustomer=0
 set @totalcustomer=0
 declare @oldpayment as int
 declare @totalpayment as int
 set @oldpayment=0
 set @totalpayment=0
 declare 
		  @i as int,
		  @Beg as date,
		  @End  as date
set @Beg=(select DATEADD(week, DATEDIFF(week,DATEADD(dd,-@@datefirst,'1900-01-01'),DATEADD(dd,-@@datefirst,convert(varchar(10), @BegDate, 120))), '1900-01-01') )
 set     @i=1;
       while (@Beg<=@EndDate)
         begin
		       
              select @End= DATEADD(week, 1, @Beg);
		    -- everyweek
		    select  *  into #temp200    
			from #temp100 
            where [Paymenttime]<@End and [Paymenttime]>=@Beg
			-- accumulatefrombegin
			select  *  into #temp300    
			from #temp100 
            where  [Paymenttime]<@Beg
			-- oldcustomer
			-- totalcustomer
			DECLARE @Count AS INT
            Select @Count = count (*) from #temp200 
            If @Count <> 0
			  begin
			     set @oldcustomer=(select count (distinct ShipToCellPhone) from #temp200  where ShipToCellPhone in (select distinct ShipToCellPhone from #temp300 ))
			     set @totalcustomer=(select count (distinct ShipToCellPhone) from #temp200)
				 set @oldpayment=( select isnull(sum([Payment]),0) from
				                       (
				                       select distinct [PurchaseOrderNumber],[MallCode],[Payment]
				                         from #temp200 
								         where ShipToCellPhone in (
								                                   select distinct ShipToCellPhone 
														  	       from #temp200  
																   where ShipToCellPhone in (
																         select distinct ShipToCellPhone 
																		        from #temp300 )
														         	)
										) as T1
									)
				 set @totalpayment=( select isnull(sum([Payment]),0) from
				                       (
				                       select distinct [PurchaseOrderNumber],[MallCode],[Payment]
				                         from #temp200 
										) as T2
									)
			     INSERT @CustomerTable VALUES (@i, @Beg, @oldcustomer,@totalcustomer,@oldpayment,@totalpayment)
				 set @i=@i+1;
				 --select @Beg, @i, @oldcustomer,@totalcustomer
			  end
			if object_id('tempdb..#temp200') is not null Begin
                drop table #temp200
            End
            if object_id('tempdb..#temp300') is not null Begin
                drop table #temp300
            End
		    select @Beg=DATEADD(week, 1, @Beg)
			
	     end
	 
	select Nums,
	       weeks, 
		   @mallcode,
		   totalcustomer-oldcustomer as newcustomer,
		   oldcustomer, 
		   totalcustomer,
		   totalpayment-oldpayment as newpayment,
		   oldpayment,
		   totalpayment 
		   from @CustomerTable