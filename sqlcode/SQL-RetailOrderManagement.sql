/****** Script for SelectTopNRows command from SSMS  ******/

  declare @Begindate  date
  declare @Enddate date
  set @Begindate='2017-04-01'
  set @Enddate='2017-05-01'

  --Order Received (including MPD order Received）
  select count(distinct PurchaseOrderNumber)  as Received
    from (
          select distinct PurchaseOrderNumber
          from [Tmall51Parcel].[dbo].[ProductImport] 
          where [CreatedOn]>=@Begindate and [CreatedOn]<@Enddate 
        union 
     
	      SELECT  distinct([ReferenceOrderId]) as PurchaseOrderNumber
            FROM [Tradewise].[dbo].[Order]
            where ReferenceOrderId like '%MPD%'
            and DATEADD(HH, +8,[CreatedOnUtc])>=@Begindate 
		    and DATEADD(HH, +8,[CreatedOnUtc])<@Enddate) as M
  
  -- order assigned
  select count(distinct TrackingNumber)  as assined
         --, [CreatedBy]
      FROM [Tmall51Parcel].[dbo].[PackageLog] 
      where [StatusId]=15
      and  DATEADD(HH, +8,[UpdatedOn] )>=@Begindate 
	  and DATEADD(HH, +8,[UpdatedOn] )<@Enddate
	 -- group by [CreatedBy]


  --order shipment Created (print)
  select count (distinct TrackingNumber) as ShipmentCreated
  from
    ( select distinct TrackingNumber
             from [Tmall51Parcel].[dbo].[PackageLog] 	                                      
			 where  StatusId = 20 
				    and  DATEADD(HH, +8,[UpdatedOn] )>=@Begindate 
	     		    and DATEADD(HH, +8,[UpdatedOn] )<@Enddate 
	union
    select distinct TrackingNumber
         FROM [Tmall51Parcel].[dbo].[ProductImport]
		 where [CreatedOn]>=@Begindate and [CreatedOn]<@Enddate
		       and TrackingNumber in
		                            ( select distinct TrackingNumber from [Tmall51Parcel].[dbo].[PackageLog] 	                                      
										   where  
												  [Tmall51Parcel].[dbo].[PackageLog].TrackingNumber is not null
										          and 
												  [Tmall51Parcel].[dbo].[PackageLog].TrackingNumber <>''
												  and
												   DATEADD(HH, +8,[UpdatedOn] )<@Enddate 
                                        )
	) as N


 --order shipped
 select count(distinct TrackingNumber)    as shipped
                                    from [Tmall51Parcel].[dbo].[PackageLog] 
	                                      where [Tmall51Parcel].[dbo].[PackageLog].StatusId =29
										  and  DATEADD(HH, +8,[UpdatedOn] )>=@Begindate 
										  and DATEADD(HH, +8,[UpdatedOn] )<@Enddate