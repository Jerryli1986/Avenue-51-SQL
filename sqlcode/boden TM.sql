/****** Script for SelectTopNRows command from SSMS  ******/
 if object_id('tempdb..#temp100') is not null Begin
     drop table #temp100
 End
SELECT [Month]
      ,[商品标题]
      ,[商品在线状态]
      ,[浏览量]
      , [访客数]
      ,case when [支付转化率]>0 then [支付转化率] else Null end as [支付转化率]
      , [支付金额]
      , [支付商品件数]
      , [点击次数]

      ,  [搜索引导支付买家数]
      ,case when [搜索支付转化率]>0 then [搜索支付转化率] else Null end as [搜索支付转化率]
      , [搜索引导访客数]
      ,[支付买家数]
  into #temp100
  FROM [Jerry_DB].[dbo].[Sheet6]
  where [商品标题] like '%boden%' order by Month 

  SELECT [Month]
      ,count([商品在线状态])  as totalproduct
	  ,sum(case when [支付商品件数]>0 then 1 else 0 end) as saledproduct
      ,sum([浏览量]) as sum浏览量
      ,sum([访客数]) as sum访客数
      ,cast(avg([支付转化率]) as decimal(4,4)) as avg支付转化率
	    --avg(nullif([支付转化率],0))
      ,sum([支付金额])  as sum支付金额
      ,sum([支付商品件数]) as sum支付商品件数
      ,sum([点击次数]) as sum点击次数
      ,cast(avg([搜索支付转化率])as decimal(2,2)) as avg搜索支付转化率
      ,sum([搜索引导访客数]) as sum搜索引导访客数
      ,sum([支付买家数]) as sum支付买家数

  FROM  #temp100
  where [商品标题] like '%boden%'
  group by Month
  order by Month 