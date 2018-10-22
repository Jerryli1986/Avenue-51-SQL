/****** Script for SelectTopNRows command from SSMS  ******/
---old new sku

/*
---1----for published productcode-------------
SELECT 
        
	   P.ProductNumber  as  New_Productcode
	   ,PG.[ProductGroupNumber]  as Old_Productcode
	   ,b.Name
  FROM [Tradewise].[dbo].[Product] P 
  left join (
             select [ProductId],[ProductGroupNumber] from
                   (select max([ProductId]) as [ProductId] ,max([ProductGroupNumber]) as [ProductGroupNumber]  ,sum([Quantity]) as [Quantity] 
                   from [Tradewise].[dbo].[ProductGroup] 
		           group by [ProductGroupNumber] 
		          having sum( [Quantity])=1 ) PG0
			  left join [Tradewise].[dbo].[Product] P0 on P0.ProductNumber=PG0.[ProductGroupNumber] and P0.STOREID=6
			  where P0.[Published]=1     
			    ) PG	       on PG.[ProductId]=P.Id  
  LEFT JOIN [Tradewise].[dbo].[Product] P1 ON P1.Id=PG.[ProductId] AND P1.STOREID=6 AND P1.ProductTypeId=3
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=P.BrandId
  where  P.STOREID=6 AND P1.ProductTypeId=3
		 and P.ProductNumber is not null
*/

----2----for all product including non published--------------
SELECT distinct 
	   P.ProductNumber  as  New_Productcode
	   ,PG.[ProductGroupNumber]  as Old_Productcode
	   ,b.Name
  FROM [Tradewise].[dbo].[Product] P 
  left join (
                 select max([ProductId]) as [ProductId],max([ProductGroupNumber]) as [ProductGroupNumber] from
                                                               (select max([ProductId]) as [ProductId] ,max([ProductGroupNumber]) as [ProductGroupNumber]  ,sum([Quantity]) as [Quantity] 
                                                                 from [Tradewise].[dbo].[ProductGroup] 
		                                                         group by [ProductGroupNumber] 
		                                                         having sum( [Quantity])=1 ) PG0
			     group by [ProductId]
				 having count([ProductId])=1                                               
			     union
				 select [ProductId],[ProductGroupNumber] from
                     (select max([ProductId]) as [ProductId] ,max([ProductGroupNumber]) as [ProductGroupNumber]  ,sum([Quantity]) as [Quantity] 
                      from [Tradewise].[dbo].[ProductGroup] 
		              group by [ProductGroupNumber] 
		              having sum( [Quantity])=1 ) PG0
			            left join [Tradewise].[dbo].[Product] P0 on P0.ProductNumber=PG0.[ProductGroupNumber] and P0.STOREID=6
			          where P0.[Published]=1
					        and [ProductId] in (
				                               select max([ProductId]) as [ProductId]        from
                                                               (select max([ProductId]) as [ProductId] ,max([ProductGroupNumber]) as [ProductGroupNumber]  ,sum([Quantity]) as [Quantity] 
                                                                 from [Tradewise].[dbo].[ProductGroup] 
		                                                         group by [ProductGroupNumber] 
		                                                         having sum( [Quantity])=1 ) PG0
			                                    group by [ProductId]
				                                having count([ProductId])>1 
				                                )                  
	            
			 ) PG	       on PG.[ProductId]=P.Id   
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=P.BrandId
  where  P.STOREID=6 AND P.ProductTypeId=3
		 and P.ProductNumber is not null
		 and  P.ProductNumber='HNZ70124901'
----3----for all old productcode--------------
/*
SELECT distinct 
	   P.ProductNumber  as  New_Productcode
	   ,PG.[ProductGroupNumber]  as Old_Productcode
	   ,b.Name
  FROM [Tradewise].[dbo].[Product] P 
  left join (
                 select max([ProductId]) as [ProductId],max([ProductGroupNumber]) as [ProductGroupNumber] from
                                                               (select max([ProductId]) as [ProductId] ,max([ProductGroupNumber]) as [ProductGroupNumber]  ,sum([Quantity]) as [Quantity] 
                                                                 from [Tradewise].[dbo].[ProductGroup] 
		                                                         group by [ProductGroupNumber] 
		                                                         having sum( [Quantity])=1 ) PG0
			     group by [ProductId]
				 having count([ProductId])=1                                               
			     union
				 select [ProductId],[ProductGroupNumber] from
                     (select max([ProductId]) as [ProductId] ,max([ProductGroupNumber]) as [ProductGroupNumber]  ,sum([Quantity]) as [Quantity] 
                      from [Tradewise].[dbo].[ProductGroup] 
		              group by [ProductGroupNumber] 
		              having sum( [Quantity])=1 ) PG0
			            left join [Tradewise].[dbo].[Product] P0 on P0.ProductNumber=PG0.[ProductGroupNumber] and P0.STOREID=6
			          where --P0.[Published]=1  and
					         [ProductId] in (
				                               select max([ProductId]) as [ProductId]        from
                                                               (select max([ProductId]) as [ProductId] ,max([ProductGroupNumber]) as [ProductGroupNumber]  ,sum([Quantity]) as [Quantity] 
                                                                 from [Tradewise].[dbo].[ProductGroup] 
		                                                         group by [ProductGroupNumber] 
		                                                         having sum( [Quantity])=1 ) PG0
			                                    group by [ProductId]
				                                having count([ProductId])>1 
				                                )                  
	            
			 ) PG	       on PG.[ProductId]=P.Id   
  LEFT JOIN [Tradewise].[dbo].[Brand] b on b.id=P.BrandId
  where  P.STOREID=6 AND P.ProductTypeId=3
		 and P.ProductNumber is not null
		 */