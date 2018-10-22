if object_id('tempdb..#temp001') is not null
 Begin
     drop table #temp001
 End
if object_id('tempdb..#temp002') is not null
 Begin
     drop table #temp002
 End




use Jerry_DB
declare  @m as int,
         @y as int,
		 @d as int,
		 @Begindate as date,
		 @Enddate  as date

 set     @d=1;
 set     @m=1;
 Set     @y=2015;  
 while   (@y<=2017)
 begin
    
    select @Begindate= CONVERT(datetime,Convert(nvarchar,@y)+'-'+Convert(nvarchar,@m)+'-'+Convert(nvarchar,@d));
    select @Enddate= CONVERT(datetime,Convert(nvarchar,@y)+'-'+Convert(nvarchar,@m+1)+'-'+Convert(nvarchar,@d));
   
    insert into temp001 
	select distinct ShipToCellPhone  as customermonthly ,@Begindate as Dates   from shipping 
            where PaidDateUtc<@Enddate and PaidDateUtc>=@Begindate ;

    insert into temp002  select * from temp001
	insert into temp003(Dates,newcustomermonthly)
	select Dates=@Begindate, count(temp001.customermonthly) 
	         from temp001 
	         left join temp2002  on temp001.customermonthly<>temp002.customermonthly ;
    insert into temp003 (oldcustomermonthly)
	select  count(temp001.customermonthly)
	         from temp001 
	         left join temp002  on temp001.customermonthly=temp002.customermonthly ;

     if object_id('tempdb..#temp001') is not null
     Begin
        drop table #temp001
     End  
end
go

