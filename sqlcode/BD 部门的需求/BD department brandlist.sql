/****** Script for SelectTopNRows command from SSMS  ******/
SELECT 
      distinct [Name],Comment
      
  FROM [Tradewise].[dbo].[Brand]
  -- where  [Comment] like '%BD-K%'
  where  [Comment] like '%BD%'
		 order by name
