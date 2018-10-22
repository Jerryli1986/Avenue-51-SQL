---old new customer monthly  with revenue
--- the sum payment is calculated when there is buyerId 

SET DATEFIRST 1;
Declare @BegDate date
declare @EndDate date
declare @mallcode varchar(max)
declare @mallnum int
declare @k int
set @BegDate='2015-01-01'
set @EndDate='2017-06-19'  -- only change this to date of Monday

--------------------------------------------------------------------------------
if object_id('tempdb..#temp400') is not null Begin
             drop table #temp400
          End
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

create table #array(id int identity(1,1), mallcode varchar(max));
insert into #array(mallcode) 
     (select distinct Mallcode from [Tmall51Parcel].[dbo].[ProductImport] where [Paymenttime]>='2017-01-01')
select @mallnum=count(1) from #array;
set @k=1;
while (@k<=@mallnum)
  begin
         set @mallcode=(select mallcode from #array where id=@k)
          
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
       convert(varchar(10), [Paymenttime], 120)  as [Paymenttime]
      ,PI.[PurchaseOrderNumber]
      ,[MallCode]
      ,[buyerId]
	  ,[Payment]   
	  ,pi.trackingnumber
  into #temp100	  
  FROM [Tmall51Parcel].[dbo].[ProductImport] PI
  LEFT JOIN [Tradewise].[dbo].[Product] P ON P.ProductNumber=pi.ProductCode AND (P.STOREID=6) 
  lEFT JOIN [Tradewise].[dbo].[ProductGroup] PG ON PG.[ProductGroupNumber]=PI.ProductCode     --组合商品中其实有些为了修改代码，而不是真正的组合，原子商品中老sku 变新sku，是在组合中改
  LEFT JOIN [Tradewise].[dbo].[Product] P1 ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=p.BrandId
  WHERE [Paymenttime]>=@BegDate and [Paymenttime]<@EndDate --AND P.STOREID=6 --AND p.name LIKE N'%???????%' --AND buyerid='HXTMLS' 
         AND StatusId<>-1
        and [MallCode] like @mallcode
  ORDER BY [Paymenttime] ASC

 --select distinct datepart(yyyy,[Paymenttime]) as yyyy,datepart(mm,[Paymenttime]) as mm,datepart(dd,[Paymenttime]) as dd,[Paymenttime], ShipToCellPhone 
 -- from #temp100  
 -- ORDER BY [Paymenttime] ASC

-- select * from #temp100	order by [PurchaseOrderNumber]

 DECLARE @CustomerTable TABLE (Nums int, weeks date,  oldcustomer decimal(18,0),totalcustomer decimal(18,0),oldpayment decimal(18,2),totalpayment decimal(18,2))
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
			     set @oldcustomer=(select count (distinct [buyerId]) from #temp200  where [buyerId] in (select distinct [buyerId] from #temp300 ))
			     set @totalcustomer=(select count (distinct [buyerId]) from #temp200)
				 set @oldpayment=( select isnull(sum([Payment]),0) from
				                       (
				                       select distinct [PurchaseOrderNumber],[MallCode],[Payment]
				                         from #temp200 
								         where [buyerId] in (
								                                   select distinct [buyerId] 
														  	       from #temp200  
																   where [buyerId] in (
																         select distinct [buyerId] 
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
		   @mallcode as Mallcode,
		   totalcustomer-oldcustomer as newcustomer,
		   cast(isnull((totalcustomer-oldcustomer)/nullif(totalcustomer,0),0) as decimal(18,2)) as '%newcustomer',
		   oldcustomer, 
		   totalcustomer,
		   totalpayment-oldpayment as newpayment,
		   cast(isnull((totalpayment-oldpayment)/nullif(totalpayment,0),0) as decimal(18,2)) as '%newpayment',
		   oldpayment,
		   totalpayment 
		   into #temp400
		   from @CustomerTable

end