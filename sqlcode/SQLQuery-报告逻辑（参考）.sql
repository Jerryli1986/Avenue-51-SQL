GO
 
/****** Object:  StoredProcedure [dbo].[usp_Report_FinanceSummaryReport]    Script Date: 20/07/2017 17:18:10 ******/
SET ANSI_NULLS ON
GO
 
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [dbo].[usp_Report_FinanceSummaryReport]
(
            @StoreId int = 1,@Filters nvarchar(2000))
AS
BEGIN
            SET NOCOUNT ON;
            IF NOT EXISTS(SELECT * FROM [dbo].[Report] WHERE ReportName='FinanceSummaryReport')
            BEGIN
                        --update [dbo].[Report] set [ColumnNumber4Excel]=8 where ReportName='FinanceSummaryReport'
                        --select * from [dbo].[Report] where ReportName='FinanceSummaryReport'
                        INSERT [dbo].[Report](ReportName, StoreId, ReportTitle,ReportMenu, ReportType, ReportSP, ColumnNumber,[ColumnNumber4Excel])
                        SELECT 'FinanceSummaryReport',1,N'财务销售汇总',N'财务销售汇总','Finance','usp_Report_FinanceSummaryReport',8,8
 
 
                        --DELETE FROM [dbo].[LocaleStringResource] where [ResourceName]like 'Report.FinanceSummaryReport.Rpt%'
                        INSERT INTO [dbo].[LocaleStringResource]([LanguageId],[StoreId],[ResourceName],[ResourceValue])
                        SELECT 1,0,'Report.FinanceSummaryReport.RptCol1.Title',N'年月'
                        UNION SELECT 1,0,'Report.FinanceSummaryReport.RptCol2.Title',N'销售金额'
                        UNION SELECT 1,0,'Report.FinanceSummaryReport.RptCol3.Title',N'退款金额'
            END
 
 
            DECLARE @Reportdate TABLE(Id INT IDENTITY(1,1), RptCol1 NVARCHAR(100),RptCol2 NVARCHAR(100),RptCol3 NVARCHAR(100),RptCol4 NVARCHAR(100),RptCol5 NVARCHAR(100),RptCol6 NVARCHAR(100),RptCol7 NVARCHAR(100), RptCol8 NVARCHAR(100),
                        RptCol9 NVARCHAR(100),RptCol10 NVARCHAR(100),RptCol11 NVARCHAR(100),RptCol12 NVARCHAR(100),RptCol13 NVARCHAR(100),RptCol14 NVARCHAR(100),RptCol15 NVARCHAR(100),RptCol16 NVARCHAR(100),
                        RptCol17 NVARCHAR(100),RptCol18 NVARCHAR(100),RptCol19 NVARCHAR(100),RptCol20 NVARCHAR(100),RptCol21 NVARCHAR(100),RptCol22 NVARCHAR(100),RptCol23 NVARCHAR(100),RptCol24 NVARCHAR(100),
                        RptCol25 NVARCHAR(100),RptCol26 NVARCHAR(100),RptCol27 NVARCHAR(100),RptCol28 NVARCHAR(100),RptCol29 NVARCHAR(100),RptCol30 NVARCHAR(100),RptCol31 NVARCHAR(100),RptCol32 NVARCHAR(100),
                        RptCol33 NVARCHAR(100),RptCol34 NVARCHAR(100),RptCol35 NVARCHAR(100),RptCol36 NVARCHAR(100))
 
            DECLARE @xml XML,@UserName nvarchar(50), @DateStart DateTime, @DateEnd DateTime,@CustomerTypeId INT, @AffiliateStoreId INT, @SalesPersonId INT
            SET @xml=@Filters
            SELECT  
                        @DateStart = x.y.value('DateStart[1]', 'datetime'),  
                        @DateEnd = x.y.value('DateEnd[1]', 'datetime'),  
                        @UserName = x.y.value('UserName[1]', 'nvarchar(20)'),
                        @CustomerTypeId = x.y.value('CustomerTypeId[1]', 'int'),
                        @AffiliateStoreId = x.y.value('AffiliateStoreId[1]', 'int'),
                        @SalesPersonId = x.y.value('SalesPersonId[1]', 'int')
            FROM @xml.nodes('//Filters') x(y)
 
            IF @DateEnd IS NULL SET @DateEnd=GETUTCDATE()
            IF @DateStart IS NULL SET @DateStart='2016.02.01' 
            IF @DateStart <'2016.02.01' SET @DateStart='2016.02.01' 
 
            SELECT ext1.[PaymentInfo],min(ext1.Id) Id
            INTO #Temp1
            FROM [dbo].[PaymentHistory]  ext1 WITH(NOLOCK)
            INNER JOIN [dbo].[StoreCustomer] ext2 WITH(NOLOCK) on ext2.id=ext1.[StoreCustomerId] and ext2.StoreId=@StoreId
            WHERE PaymentTypeId in (1,2) AND PaidOnUtc IS NOT NULL AND datediff(day,@DateStart,PaidOnUtc)>=0 AND datediff(day,PaidOnUtc,@DateEnd)>=0 
            GROUP BY [PaymentInfo]
 
 
            INSERT @Reportdate (RptCol1,RptCol2,RptCol3)
            SELECT convert(varchar(7),ext1.PaidOnUtc,121), sum([PaidAmount]),0
            FROM [dbo].[PaymentHistory] ext1 with(nolock) 
            INNER JOIN #Temp1 ext2 ON ext2.Id=ext1.Id
            INNER JOIN [dbo].[StoreCustomer] ext3 with(nolock) on ext3.Id=ext1.[StoreCustomerId]
            INNER JOIN [dbo].[PaymentMethod] ext4 with(nolock) on ext4.Id=ext1.[PaymentMethodId]
            where ext3.[Username] not in ('51parcel-linda','roletest','roleimplementation','51parcel-buddy')
            group by convert(varchar(7),ext1.PaidOnUtc,121)
            ORDER BY 1
 
            --refund
            INSERT [dbo].[OrderShipmentRefundReport](ReferenceOrderId, OrderId, OrderTypeId, StoreId, StoreCustomerId, OrderReceivable, [OrderStatusId], CreatedOnUtc, PaidDateUtc, PaymentUniqueId, CancelledOnUtc)
            SELECT ReferenceOrderId, Id, 1, StoreId, StoreCustomerId, OrderReceivable,[OrderStatusId], GETUTCDATE(), PaidDateUtc, PaymentUniqueId, NULL
            FROM [dbo].[Order] EXT1 WITH(NOLOCK)
            WHERE EXT1.[OrderStatusId] in (40,41,59,60,61) 
                        AND EXISTS(SELECT * FROM [dbo].[OrderLog] WITH(NOLOCK) WHERE OrderId=EXT1.Id AND [OrderStatusId] = 10)
                        AND NOT EXISTS(SELECT * FROM [dbo].[OrderShipmentRefundReport] WITH(NOLOCK) WHERE OrderId=EXT1.Id AND OrderTypeId=1)
 
            UPDATE EXT1 SET CancelledOnUtc=EXT2.[LoggedOnUtc]
            FROM [dbo].[OrderShipmentRefundReport]  EXT1
            INNER JOIN (SELECT [OrderId],MIN([LoggedOnUtc]) [LoggedOnUtc] FROM [dbo].[OrderLog] WITH(NOLOCK) WHERE [OrderStatusId] in (40,41,59,60,61) GROUP BY [OrderId]) EXT2 ON EXT2.[OrderId]=EXT1.OrderId
            WHERE EXT1.CancelledOnUtc IS NULL AND EXT1.OrderTypeId=1
            
            update ext01 set RptCol3=ext02.Refund
            from @Reportdate ext01
            inner join (SELECT convert(varchar(7),ext1.CancelledOnUtc,121) YearMonth, sum(ext1.[OrderReceivable]) Refund
            FROM [dbo].[OrderShipmentRefundReport] ext1 with(nolock) 
            INNER JOIN [dbo].[StoreCustomer] ext2 with(nolock) on ext2.Id=ext1.[StoreCustomerId]
            INNER JOIN [dbo].[OrderStatus] ext3 with(nolock) on ext3.[Id]=ext1.[OrderStatusId]
            WHERE EXT1.StoreId=@StoreId AND EXT1.CancelledOnUtc>=@DateStart AND EXT1.CancelledOnUtc<=@DateEnd 
                        and ext2.[Username] not in ('51parcel-linda','roletest','roleimplementation','51parcel-buddy')
            group by convert(varchar(7),ext1.CancelledOnUtc,121)) ext02 on ext02.YearMonth=ext01.RptCol1
 
            SELECT * FROM @Reportdate
 
END
 
 
 
GO
 
