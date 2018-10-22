USE [Tmall51Parcel]
GO
 
/****** Object:  StoredProcedure [dbo].[usp_Report_SalesAndAvenue]    Script Date: 14/07/2017 16:30:30 ******/
SET ANSI_NULLS ON
GO
 
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[usp_Report_SalesAndAvenue]
AS
BEGIN
            SET NOCOUNT ON;
            DECLARE @Reportdate TABLE(Id INT IDENTITY(1,1), RptCol1 NVARCHAR(200),RptCol2 NVARCHAR(200),RptCol3 NVARCHAR(200),RptCol4 NVARCHAR(200),RptCol5 NVARCHAR(200),RptCol6 NVARCHAR(200),RptCol7 NVARCHAR(200), RptCol8 NVARCHAR(200),
                        RptCol9 NVARCHAR(200),RptCol10 NVARCHAR(200),RptCol11 NVARCHAR(200),RptCol12 NVARCHAR(200),RptCol13 NVARCHAR(200),RptCol14 NVARCHAR(200),RptCol15 NVARCHAR(200),RptCol16 NVARCHAR(200),
                        RptCol17 NVARCHAR(200),RptCol18 NVARCHAR(200),RptCol19 NVARCHAR(200),RptCol20 NVARCHAR(200),RptCol21 NVARCHAR(200),RptCol22 NVARCHAR(200),RptCol23 NVARCHAR(200),RptCol24 NVARCHAR(200),
                        RptCol25 NVARCHAR(200),RptCol26 NVARCHAR(200),RptCol27 NVARCHAR(200),RptCol28 NVARCHAR(200),RptCol29 NVARCHAR(200),RptCol30 NVARCHAR(200),RptCol31 NVARCHAR(200),RptCol32 NVARCHAR(200),
                        RptCol33 NVARCHAR(200),RptCol34 NVARCHAR(200),RptCol35 NVARCHAR(200),RptCol36 NVARCHAR(200))
 
            TRUNCATE TABLE [Tmall51Parcel].[dbo].[RevenueReport]
            DECLARE @Settlement TABLE([Partner_transaction_id] [nvarchar](255),[Amount] [decimal](18, 2),[Rmb_amount] [decimal](18, 2),[Fee] [decimal](18, 2) NULL,[Settlement] [decimal](18, 2),[Rmb_settlement] [decimal](18, 2),Records int)
            DECLARE @Revenue TABLE(PartnerTransactionId [nvarchar](255),Records int, OrderPayment decimal(18,2))
            DECLARE @Weighht TABLE([ProductImportId] INT, PFWTrackingNumber [nvarchar](255), RMShipping decimal(18, 2),[Weight] decimal(18, 2)) 
 
            --adjust product group caused Payment=OrderPayment issue
            
            --VALID [ProductImport] WITH/WITHOUT [Package] [Type] = 'P'
            INSERT [Tmall51Parcel].[dbo].[RevenueReport]([ProductImportId],DateOfTransaction, CommissionModel, PartnerTransactionId, PurchaseOrderNumber, PFWService, OrderNumber, [OrderReference],PFWTrackingNumber, NumberOfItems, ChargableWeight, 
                        DeliveryStatus, PaymentStatus, Retailer, TotalOrderValue, RetailerRevenue, RMShipping, RMCommission, A51Commission, AlipayCommission, PaymentAmountRMB, PaymentAmountGBP, Rate, CreatedOn, Notes, ProductCodes, 
                        ProductName, ProductPayment, Payment_time, Settlement_time, Type, Status, Stem_from, ReceiverName, ReceiverCity, ReceiverProvince)
            SELECT EXT1.[Id],EXT1.[PaymentTime],
			ISNULL(EXT3.[CalculationModel],''),
			EXT2.[Partner_transaction_id],
			EXT1.[PurchaseOrderNumber] + CASE WHEN ISNULL(EXT5.[StatusId],29)<>29 AND ISNULL(EXT5.[StatusId],200)<>200
			                                 THEN ':Status='+CONVERT(VARCHAR(2),EXT5.[StatusId]) ELSE '' END,
                        ISNULL(EXT8.[ServiceName],'') AS PFWService,
						 EXT1.[TMOId],ISNULL(EXT5.[OrderReference],''),
						 ISNULL(EXT5.[TrackingNumber],''), 
						 EXT1.[Quantity],
						 ISNULL(EXT6.[weight],
						 ISNULL(EXT5.[weight],0)) AS ChargableWeight,
						  'Delivered' AS DeliveryStatus,
                        'Payment Due' PaymentStatus,
						ISNULL(EXT3.[MerchantName],''),0 AS TotalOrderValue,
						0,ISNULL(EXT7.[ExpensePrice],0) AS RMShipping,
						0,0,0,0,0, ISNULL(EXT2.[Rate],0), 
						CONVERT(VARCHAR(10),GETUTCDATE(),102),
                        CASE WHEN EXT5.[Id] IS NULL THEN 'SHIPMENT IS NOT FOUND' ELSE EXT2.[Remarks] END AS Notes,
						 EXT1.ProductCode,
						 EXT1.[ProductEnglishName] AS ProductName,
						 EXT1.[OrderPayment],
						 ISNULL(EXT2.Payment_time,''),
						 ISNULL(EXT2.Settlement_time,''),
            ISNULL(EXT2.[Type],''),ISNULL(EXT2.[Status],''),ISNULL(EXT2.[Stem_from],''),
			EXT1.ReceiverName,EXT1.ReceiverCity,EXT1.ReceiverProvince
            FROM [Tmall51Parcel].[dbo].[ProductImport] EXT1 WITH(NOLOCK)
            INNER JOIN [Tmall51Parcel].[dbo].[TransactionSettlement] EXT2 WITH(NOLOCK) ON EXT2.[Partner_transaction_id]=EXT1.[PurchaseOrderNumber] AND EXT2.[Type] = 'P'
            LEFT JOIN [Tmall51Parcel].[dbo].[Merchant] EXT3 WITH(NOLOCK) ON EXT3.[ProductCodePrefix] =Substring(EXT1.[ProductCode],1,3)
            LEFT JOIN [Tmall51Parcel].[dbo].[PackageDetails] EXT4 WITH(NOLOCK) ON EXT4.[ProductImportId]=EXT1.[Id]
            LEFT JOIN [Tmall51Parcel].[dbo].[Package] EXT5 WITH(NOLOCK) ON EXT5.[Id]=EXT4.[PackageId]
            LEFT JOIN [Tmall51Parcel].[dbo].[Avenue51Report] EXT6 WITH(NOLOCK) ON EXT6.[consignment]=EXT5.[TrackingNumber]
            LEFT JOIN [Tmall51Parcel].[dbo].[ShipmentMethodExpense] EXT7 WITH(NOLOCK) ON EXT7.[ServiceProviderId] = EXT5.[ServiceProviderId]
			                                                                           AND EXT7.[Weight]>=ISNULL(EXT6.[weight],ISNULL(EXT5.[weight],0)) 
																					   AND EXT7.[Weight]<ISNULL(EXT6.[weight],ISNULL(EXT5.[weight],0))+0.5
            LEFT JOIN [Tmall51Parcel].[dbo].[ShipmentMethod] EXT8 WITH(NOLOCK) ON EXT8.[ServiceProviderId] = EXT5.[ServiceProviderId]
            order by 1
 
            --VALID [ProductImport] WITH/WITHOUT [Package] [Type] = 'R'
            INSERT [Tmall51Parcel].[dbo].[RevenueReport]([ProductImportId],DateOfTransaction, CommissionModel, PartnerTransactionId, PurchaseOrderNumber, PFWService, OrderNumber, [OrderReference], PFWTrackingNumber, NumberOfItems, ChargableWeight, 
                        DeliveryStatus, PaymentStatus, Retailer, TotalOrderValue, RetailerRevenue, RMShipping, RMCommission, A51Commission, AlipayCommission, PaymentAmountRMB, PaymentAmountGBP, Rate, CreatedOn, Notes, ProductCodes, 
                        ProductName, ProductPayment, Payment_time, Settlement_time, Type, Status, Stem_from, ReceiverName, ReceiverCity, ReceiverProvince)
            SELECT EXT1.[Id],EXT1.[PaymentTime],
			ISNULL(EXT3.[CalculationModel],''),
			EXT2.[Partner_transaction_id],
			EXT1.[PurchaseOrderNumber] + CASE WHEN ISNULL(EXT5.[StatusId],29)<>29 AND ISNULL(EXT5.[StatusId],200)<>200 THEN ':Status='+CONVERT(VARCHAR(2),EXT5.[StatusId]) ELSE '' END,
                        ISNULL(EXT8.[ServiceName],'') AS PFWService,
						 EXT1.[TMOId],ISNULL(EXT5.[OrderReference],''),
						 ISNULL(EXT5.[TrackingNumber],''), 
						 EXT1.[Quantity],
						 ISNULL(EXT6.[weight],ISNULL(EXT5.[weight],0)) AS ChargableWeight,
						  'Delivered' AS DeliveryStatus,
                        'Payment Due' PaymentStatus,
						ISNULL(EXT3.[MerchantName],''),0 AS TotalOrderValue,0,
						ISNULL(EXT7.[ExpensePrice],0) AS RMShipping,0,0,0,0,0, 
						ISNULL(EXT2.[Rate],0), CONVERT(VARCHAR(10),GETUTCDATE(),102),
                        CASE WHEN EXT5.[Id] IS NULL THEN 'SHIPMENT IS NOT FOUND' ELSE EXT2.[Remarks] END AS Notes, 
						EXT1.ProductCode,EXT1.[ProductEnglishName] AS ProductName,EXT1.[OrderPayment],
						ISNULL(EXT2.Payment_time,''),ISNULL(EXT2.Settlement_time,''),
            ISNULL(EXT2.[Type],''),ISNULL(EXT2.[Status],''),ISNULL(EXT2.[Stem_from],''),
			EXT1.ReceiverName,EXT1.ReceiverCity,EXT1.ReceiverProvince
            FROM [Tmall51Parcel].[dbo].[ProductImport] EXT1 WITH(NOLOCK)
            INNER JOIN [Tmall51Parcel].[dbo].[TransactionSettlement] EXT2 WITH(NOLOCK) ON EXT2.[Partner_transaction_id]=EXT1.[PurchaseOrderNumber] AND EXT2.[Type] = 'R'
            LEFT JOIN [Tmall51Parcel].[dbo].[Merchant] EXT3 WITH(NOLOCK) ON EXT3.[ProductCodePrefix] = Substring(EXT1.[ProductCode],1,3)
            LEFT JOIN [Tmall51Parcel].[dbo].[PackageDetails] EXT4 WITH(NOLOCK) ON EXT4.[ProductImportId]=EXT1.[Id]
            LEFT JOIN [Tmall51Parcel].[dbo].[Package] EXT5 WITH(NOLOCK) ON EXT5.[Id]=EXT4.[PackageId]
            LEFT JOIN [Tmall51Parcel].[dbo].[Avenue51Report] EXT6 WITH(NOLOCK) ON EXT6.[consignment]=EXT5.[TrackingNumber]
            LEFT JOIN [Tmall51Parcel].[dbo].[ShipmentMethodExpense] EXT7 WITH(NOLOCK) ON EXT7.[ServiceProviderId] = EXT5.[ServiceProviderId] 
			                                                          AND EXT7.[Weight]>=ISNULL(EXT6.[weight],ISNULL(EXT5.[weight],0)) 
																	  AND EXT7.[Weight]<ISNULL(EXT6.[weight],ISNULL(EXT5.[weight],0))+0.5
            LEFT JOIN [Tmall51Parcel].[dbo].[ShipmentMethod] EXT8 WITH(NOLOCK) ON EXT8.[ServiceProviderId] = EXT5.[ServiceProviderId]
            WHERE NOT EXISTS(SELECT *  FROM [Tmall51Parcel].[dbo].[TransactionSettlement] WHERE [Partner_transaction_id]=EXT2.[Partner_transaction_id] AND [Type] = 'P')
 
            --INVALID [ProductImport], GET [TransactionSettlement] ONLY [Type] = 'P'
            INSERT [Tmall51Parcel].[dbo].[RevenueReport]([ProductImportId],DateOfTransaction, CommissionModel, PartnerTransactionId, PurchaseOrderNumber, PFWService, OrderNumber, [OrderReference], PFWTrackingNumber, NumberOfItems, ChargableWeight, 
                        DeliveryStatus, PaymentStatus, Retailer, TotalOrderValue, RetailerRevenue, RMShipping, RMCommission, A51Commission, AlipayCommission, PaymentAmountRMB, PaymentAmountGBP, Rate, CreatedOn, Notes, ProductCodes, 
                        ProductName, ProductPayment, Payment_time, Settlement_time, Type, Status, Stem_from, ReceiverName, ReceiverCity, ReceiverProvince)
            SELECT 0,[Payment_time],'',
			[Partner_transaction_id],
			[Partner_transaction_id],  
			 '' AS PFWService,'','','',0,0,
                        'Delivered' AS DeliveryStatus, 
						'Payment Due' PaymentStatus,
						'',0,0,0,0,0,0,0,0,[Rate], 
						CONVERT(VARCHAR(10),GETUTCDATE(),102),
						'PRODUCT IS NOT FOUND' AS Notes,
						'' AS ProductCodes,
                        '' AS ProductName,[Rmb_amount],
						ISNULL(Payment_time,''),
						ISNULL(Settlement_time,''),
						ISNULL([Type],''),
						ISNULL([Status],''),
						ISNULL([Stem_from],''),'','',''
            FROM [Tmall51Parcel].[dbo].[TransactionSettlement] EXT1 WITH(NOLOCK) 
            WHERE [Type] = 'P' AND NOT EXISTS(SELECT *  FROM [Tmall51Parcel].[dbo].[RevenueReport] WHERE PartnerTransactionId=EXT1.[Partner_transaction_id])
 
            INSERT [Tmall51Parcel].[dbo].[RevenueReport]([ProductImportId], DateOfTransaction, CommissionModel, PartnerTransactionId, PurchaseOrderNumber, PFWService, OrderNumber, [OrderReference], PFWTrackingNumber, NumberOfItems, ChargableWeight, 
                        DeliveryStatus, PaymentStatus, Retailer, TotalOrderValue, RetailerRevenue, RMShipping, RMCommission, A51Commission, AlipayCommission, PaymentAmountRMB, PaymentAmountGBP, Rate, CreatedOn, Notes, ProductCodes, 
                        ProductName, ProductPayment, Payment_time, Settlement_time, Type, Status, Stem_from, ReceiverName, ReceiverCity, ReceiverProvince)
            SELECT 0,[Payment_time],'',[Partner_transaction_id],
			[Partner_transaction_id],   '' AS PFWService,'','','',0,0,
                        'Delivered' AS DeliveryStatus, 
						'Payment Due' PaymentStatus,'',0,0,0,0,0,0,0,0,
						[Rate], 
						CONVERT(VARCHAR(10),GETUTCDATE(),102),
						'PRODUCT IS NOT FOUND' AS Notes,
						'' AS ProductCodes,
                        '' AS ProductName,[Rmb_amount],
						ISNULL(Payment_time,''),
						ISNULL(Settlement_time,''),
						ISNULL([Type],''),
						ISNULL([Status],''),
						ISNULL([Stem_from],''),
						'','',''
            FROM [Tmall51Parcel].[dbo].[TransactionSettlement] EXT1 WITH(NOLOCK) 
            WHERE [Type] = 'R' AND NOT EXISTS(SELECT *  FROM [Tmall51Parcel].[dbo].[RevenueReport] WHERE PartnerTransactionId=EXT1.[Partner_transaction_id])
 
            UPDATE EXT1 
			SET [ProductCodes]=EXT2.[ProductCodes],
			CommissionModel=ISNULL(EXT3.[CalculationModel],''),
			Retailer=ISNULL(EXT3.[MerchantName],'')--,Notes=EXT2.ProductName
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1
            INNER JOIN [Tmall51Parcel].[dbo].[RevenueReport] EXT2 ON EXT2.ProductName=EXT1.ProductName AND EXT2.[ProductCodes]<>''
            LEFT JOIN [Tmall51Parcel].[dbo].[Merchant] EXT3 WITH(NOLOCK) ON EXT3.[ProductCodePrefix] = Substring(EXT2.[ProductCodes],1,3) --REPLACE(Substring(EXT2.[ProductCodes],1,3),'YC0','RMM')
            WHERE EXT1.[ProductCodes]='' 
 
            --
 
            --RMShipping SPLIT BTY ITEM WEIGHT 
            INSERT @Weighht([ProductImportId],PFWTrackingNumber, RMShipping,[Weight])
            SELECT EXT2.[ProductImportId], EXT2.PFWTrackingNumber, EXT1.RMShipping,EXT2.[Weight] 
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 
            INNER JOIN (SELECT MAX(EXT01.[ProductImportId]) [ProductImportId], EXT01.PFWTrackingNumber,
			                   MAX(EXT01.RMShipping) RMShipping,SUM(EXT02.[UnitWeight]*EXT02.[Quantity]) AS [Weight]
                              FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT01
                              INNER JOIN [Tmall51Parcel].[dbo].[ProductImport] EXT02 ON EXT02.[Id]= EXT01.[ProductImportId]
                             where EXT01.[RMShipping]<>0 group by EXT01.PFWTrackingNumber having count(*)>1) EXT2 
			          ON EXT2.PFWTrackingNumber=EXT1.PFWTrackingNumber and EXT2.[ProductImportId]=EXT1.[ProductImportId] and EXT2.PFWTrackingNumber<>''
            ORDER BY EXT1.[PartnerTransactionId],EXT1.RMShipping
            
            UPDATE EXT1 SET RMShipping=EXT2.RMShipping*(EXT3.[UnitWeight]*EXT3.[Quantity])/EXT2.[Weight]
            FROM  [Tmall51Parcel].[dbo].[RevenueReport] EXT1 
            INNER JOIN @Weighht EXT2 ON EXT2.PFWTrackingNumber=EXT1.PFWTrackingNumber
            INNER JOIN [Tmall51Parcel].[dbo].[ProductImport] EXT3 ON EXT3.[Id]= EXT1.[ProductImportId]
 
            UPDATE EXT1 SET RMShipping=EXT1.RMShipping + EXT2.RMShipping - EXT3.RMShipping
            FROM  [Tmall51Parcel].[dbo].[RevenueReport] EXT1 
            INNER JOIN @Weighht EXT2 ON EXT2.[ProductImportId]=EXT1.[ProductImportId] 
            INNER JOIN (SELECT EXT01.PFWTrackingNumber,SUM(EXT01.RMShipping) RMShipping
                        FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT01
                        INNER JOIN @Weighht EXT02 ON EXT02.PFWTrackingNumber=EXT01.PFWTrackingNumber
                        GROUP BY EXT01.PFWTrackingNumber) EXT3 ON EXT3.PFWTrackingNumber=EXT1.PFWTrackingNumber
 
            --MassageReport
            INSERT @Revenue (PartnerTransactionId, Records,OrderPayment) SELECT PartnerTransactionId,COUNT(*),SUM([ProductPayment]) FROM [Tmall51Parcel].[dbo].[RevenueReport]             GROUP BY PartnerTransactionId
            INSERT @Settlement SELECT [Partner_transaction_id],SUM([Amount])[Amount],SUM([Rmb_amount])[Rmb_amount],SUM([Fee])[Fee],SUM([Settlement])[Settlement],SUM([Rmb_settlement])[Rmb_settlement],COUNT(*) 
            FROM [Tmall51Parcel].[dbo].[TransactionSettlement] GROUP BY [Partner_transaction_id]
            
            --one product order
            UPDATE EXT1 SET [TotalOrderValue]=EXT3.[Amount],AlipayCommission = EXT3.[Fee], PaymentAmountGBP=EXT3.[Amount], PaymentAmountRMB = EXT3.[Rmb_amount]
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1
            INNER JOIN @Revenue EXT2 ON EXT2.PartnerTransactionId=EXT1.PartnerTransactionId AND EXT2.Records=1
            INNER JOIN @Settlement EXT3 ON EXT3.[Partner_transaction_id]=EXT1.PartnerTransactionId
 
            --multiple product order(split)
            UPDATE EXT1 SET [TotalOrderValue]=EXT3.[Amount]*EXT1.[ProductPayment]/EXT2.OrderPayment,
                        AlipayCommission = EXT3.[Fee]*EXT1.[ProductPayment]/EXT2.OrderPayment, 
                        PaymentAmountGBP=EXT3.[Amount]*EXT1.[ProductPayment]/EXT2.OrderPayment, 
                        PaymentAmountRMB = EXT3.[Rmb_amount]*EXT1.[ProductPayment]/EXT2.OrderPayment,
                       ProductPayment=EXT3.[Rmb_amount]*EXT1.[ProductPayment]/EXT2.OrderPayment
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1
            INNER JOIN @Revenue EXT2 ON EXT2.PartnerTransactionId=EXT1.PartnerTransactionId AND EXT2.Records>1
            INNER JOIN @Settlement EXT3 ON EXT3.[Partner_transaction_id]=EXT1.PartnerTransactionId and EXT3.[Amount]<>0
 
            --multiple product order(adjust)
            UPDATE EXT1 SET [TotalOrderValue]=EXT1.[TotalOrderValue]+(EXT3.[Amount]-EXT4.[TotalOrderValue]),AlipayCommission =EXT1.AlipayCommission+(EXT3.[Fee]-EXT4.AlipayCommission), 
                        PaymentAmountGBP=EXT1.PaymentAmountGBP+(EXT3.[Amount]-EXT4.PaymentAmountGBP), PaymentAmountRMB =EXT1.PaymentAmountRMB+(EXT3.[Rmb_amount]-EXT4.PaymentAmountRMB)
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1
            INNER JOIN @Revenue EXT2 ON EXT2.PartnerTransactionId=EXT1.PartnerTransactionId AND EXT2.Records>1
            INNER JOIN @Settlement EXT3 ON EXT3.[Partner_transaction_id]=EXT1.PartnerTransactionId
            INNER JOIN (SELECT PartnerTransactionId,SUM([TotalOrderValue]) AS [TotalOrderValue], SUM(AlipayCommission) AS AlipayCommission, SUM(PaymentAmountGBP)AS PaymentAmountGBP, SUM(PaymentAmountRMB) AS PaymentAmountRMB, MAX([Id]) AS [Id]
                        FROM [Tmall51Parcel].[dbo].[RevenueReport] GROUP BY PartnerTransactionId) EXT4 ON EXT4.PartnerTransactionId=EXT1.PartnerTransactionId AND EXT4.[Id]=EXT1.[Id]
 
            -- CalculationType=1 Percantage RetailerRevenue, RMCommission, A51Commission
            UPDATE EXT1 SET RMCommission = TotalOrderValue * 0.08 FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=1)
 
            -- CalculationModel = 'A'
            UPDATE EXT1 SET RetailerRevenue=TotalOrderValue * 0.85 - RMShipping FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=1 AND CalculationModel = 'A')
 
            -- CalculationModel = 'B'
            UPDATE EXT1 SET RetailerRevenue=TotalOrderValue * 0.85 - RMShipping FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=1 AND CalculationModel = 'B')
 
            -- CalculationModel = 'C'
            UPDATE EXT1 SET RetailerRevenue = TotalOrderValue * 0.65 - NumberOfItems*10 FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=1 AND CalculationModel = 'C')
            
            -- CalculationModel = 'D'
            UPDATE EXT1 SET RetailerRevenue=TotalOrderValue * 0.65 FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=1 AND CalculationModel = 'D')
 
            UPDATE EXT1 SET A51Commission = TotalOrderValue-RetailerRevenue - RMCommission - AlipayCommission-RMShipping FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=1)
                        
            -- CalculationType=2 Fixed RetailerRevenue, RMCommission, A51Commission
            UPDATE EXT1 SET RetailerRevenue = RetailerRevenue + EXT2.[ProductCost]
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 
            INNER JOIN [dbo].[ProductCost] EXT2 ON EXT2.[ProductNumber]=EXT1.[ProductCodes]
            WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=2) AND SUBSTRING(EXT1.[ProductCodes],1,5) in ('RMM06','PFM06','CND03')
                        AND EXT1.[TotalOrderValue]>0
 
            UPDATE EXT1 SET RetailerRevenue = RetailerRevenue + EXT2.[ProductCost]*EXT1.[NumberOfItems]
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 
            INNER JOIN [dbo].[ProductCost] EXT2 ON EXT2.[ProductNumber]=EXT1.[ProductCodes] 
            WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=2) AND SUBSTRING(EXT1.[ProductCodes],1,5) not in ('RMM06','PFM06','CND03')
                        AND EXT1.[TotalOrderValue]>0
 
            --RetailerRevenue SHOULD BE NEGITAVE IF TotalOrderValue LESS THAN 0
            UPDATE EXT1 SET RetailerRevenue = RetailerRevenue - EXT2.[ProductCost]
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 
            INNER JOIN [dbo].[ProductCost] EXT2 ON EXT2.[ProductNumber]=EXT1.[ProductCodes]
            WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=2) AND SUBSTRING(EXT1.[ProductCodes],1,5) in ('RMM06','PFM06','CND03')
                        AND EXT1.[TotalOrderValue]<0
 
            UPDATE EXT1 SET RetailerRevenue = RetailerRevenue - EXT2.[ProductCost]*EXT1.[NumberOfItems]
            FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 
            INNER JOIN [dbo].[ProductCost] EXT2 ON EXT2.[ProductNumber]=EXT1.[ProductCodes] 
            WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=2) AND SUBSTRING(EXT1.[ProductCodes],1,5) not in ('RMM06','PFM06','CND03')
                        AND EXT1.[TotalOrderValue]<0
            
            UPDATE EXT1 SET RMCommission = TotalOrderValue * 0.08 FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=2 AND CalculationModel = 'A')
            UPDATE EXT1 SET A51Commission = TotalOrderValue-RetailerRevenue - RMCommission - AlipayCommission-RMShipping FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=2 AND CalculationModel = 'A')
 
            UPDATE EXT1 SET A51Commission = TotalOrderValue * 0.055 FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=2 AND CalculationModel = 'B')
            UPDATE EXT1 SET RMCommission = TotalOrderValue-RetailerRevenue - A51Commission - AlipayCommission-RMShipping FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer AND CalculationType=2 AND CalculationModel = 'B')
            
            --对于Retailer为空因而匹配不到CalculationType的记录，统一使用以下公式
            UPDATE EXT1 SET RMCommission = TotalOrderValue * 0.08, RetailerRevenue = 0  FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE NOT EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer)
            UPDATE EXT1 SET A51Commission = TotalOrderValue-RetailerRevenue - RMCommission - AlipayCommission-RMShipping FROM [Tmall51Parcel].[dbo].[RevenueReport] EXT1 WHERE NOT EXISTS(SELECT * FROM [Tmall51Parcel].[dbo].[Merchant] WITH(NOLOCK) WHERE MerchantName=EXT1.Retailer)
 
            INSERT @Reportdate (RptCol1,RptCol2,RptCol3,RptCol4,RptCol5,RptCol6,RptCol7, RptCol8,RptCol9,RptCol10,RptCol11,RptCol12,RptCol13,RptCol14,RptCol15,RptCol16,RptCol17,RptCol18,
            RptCol19,RptCol20,RptCol21,RptCol22,RptCol23,RptCol24,RptCol25,RptCol26,RptCol27,RptCol28,RptCol29,RptCol30,RptCol31,RptCol32,RptCol33,RptCol34,RptCol35)
            SELECT CONVERT(VARCHAR(10),DateOfTransaction,103), CommissionModel, PartnerTransactionId, PurchaseOrderNumber, PFWService, OrderNumber, PFWTrackingNumber, NumberOfItems, ChargableWeight, DeliveryStatus, PaymentStatus, 
            Retailer, TotalOrderValue, RetailerRevenue, RMShipping, RMCommission, A51Commission, AlipayCommission, PaymentAmountRMB, PaymentAmountGBP, Rate, CONVERT(VARCHAR(10),CreatedOn,103), Notes, ProductCodes, ProductName, 
            ProductPayment,  CONVERT(VARCHAR(10),Payment_time,103),  CONVERT(VARCHAR(10),Settlement_time,103), [Type], [Status], Stem_from, ReceiverName, ReceiverCity, ReceiverProvince ,[OrderReference]
            FROM [Tmall51Parcel].[dbo].[RevenueReport]
 
            SELECT * FROM @Reportdate ORDER BY 1
 
END
 
 
GO
 
