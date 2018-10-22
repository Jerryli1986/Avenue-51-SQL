Declare @BegDate date
declare @EndDate date
declare @mallcode varchar(max)
set @BegDate='2015-01-01'
set @EndDate='2017-05-30'
set @mallcode='WebAPI_51cpk.com'
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
       convert(varchar(10), [Paymenttime], 120)  as [Paymenttime]
      ,PI.[PurchaseOrderNumber]
      ,[MallCode]
      ,[buyerId]   
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


 DECLARE @CustomerTable TABLE (yyyy INT, mm INT, oldcustomer INT,totalcustomer INT)
 declare @oldcustomer as int
 declare @totalcustomer as int
 set @oldcustomer=0
 set @totalcustomer=0
  declare @m as int,
          @y as int,
		  @d as int,
		  @Beg as date,
		  @End  as date

 set     @d=1;
 set     @m=1;
 Set     @y=2015;  
 while   (@y<=2017)
    begin
       while (@m<=12)
          begin
		     select @Beg= CONVERT(datetime,Convert(nvarchar,@y)+'-'+Convert(nvarchar,@m)+'-'+Convert(nvarchar,@d));
		    if @m<12
                select @End= CONVERT(datetime,Convert(nvarchar,@y)+'-'+Convert(nvarchar,@m+1)+'-'+Convert(nvarchar,@d));
			else 
                select @End= CONVERT(datetime,Convert(nvarchar,@y+1)+'-'+Convert(nvarchar,1)+'-'+Convert(nvarchar,@d));
		    -- everymonth
		    select  distinct ShipToCellPhone
			into #temp200    
			from #temp100 
            where [Paymenttime]<@End and [Paymenttime]>=@Beg
			-- accumulatefrombegin
			select  distinct ShipToCellPhone
			into #temp300    
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
			     INSERT @CustomerTable VALUES (@y, @m, @oldcustomer,@totalcustomer)
				 select @y, @m, @oldcustomer,@totalcustomer
			  end
			if object_id('tempdb..#temp200') is not null Begin
                drop table #temp200
            End
            if object_id('tempdb..#temp300') is not null Begin
                drop table #temp300
            End
		    set	@m=@m+1
	     end
	   if @m>12
	     begin
	        set @y=@y+1;
		    set @m=1;
         end
    end 

	select yyyy, mm, totalcustomer-oldcustomer as newcustomer,oldcustomer, totalcustomer from @CustomerTable