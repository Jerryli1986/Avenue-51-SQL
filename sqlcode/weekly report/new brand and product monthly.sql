declare @Begindate  date
declare @Enddate date
set @Begindate='2017-04-01'
set @Enddate='2017-05-01'



--Product intiated

--SELECT count(distinct ProductNumber) as ProductInitiated
  SELECT [ProductEnglishName],[CreatedOnUtc] as ProductInitiated
  FROM [Tradewise].[dbo].[Product]
  where [CreatedOnUtc]>=@Begindate
        and 
		[CreatedOnUtc]<@Enddate
		and [Tradewise].[dbo].[Product].StoreId=6

--Brand intiated

 --SELECT count(distinct p.BrandId) as BrandInitiated
 SELECT distinct b.Name as BrandInitiated
  FROM [Tradewise].[dbo].[Product] p
  left join [Tradewise].[dbo].[Brand] b on b.Id=p.BrandId
  where p.[CreatedOnUtc]>=@Begindate
        and 
		p.[CreatedOnUtc]<@Enddate
		and p.BrandId not in (
		           SELECT distinct BrandId 
                   FROM [Tradewise].[dbo].[Product] 
                   where 
		           [CreatedOnUtc]<@Begindate
				   and [Deleted]=0
	               and BrandId is not null
				         )
   