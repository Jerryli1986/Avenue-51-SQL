use Jerry_DB
delete temp1111;
delete temp2222;
delete temp3333
declare  
		 @Begindate as date,
		 @nextmonthdate  as date,
		 @Enddate  as date,
		 @i  as int,
		 @j  as int,
		 @k  as int
		 

 set     @Begindate='20150101';
 set     @nextmonthdate=DATEADD(MONTH,1,@Begindate);
 set     @Enddate='20170401';
 set     @k=1;
 
 insert into temp2222 
	       select distinct ShipToCellPhone  as customermonthly ,@Begindate as Dates   from shipping 
                where  PaidDateUtc<@Begindate  and ShipToCellPhone is not null;
         
    while @Begindate<@Enddate 
	begin
	
	   insert into temp1111 
	       select  ShipToCellPhone  as customermonthly ,@Begindate as Dates   from shipping 
                where PaidDateUtc<@nextmonthdate and PaidDateUtc>=@Begindate and ShipToCellPhone is not null;
	
       set @i=(select count(distinct customermonthly)    from temp1111   )
	   set @j=(select count(distinct customermonthly)    from temp2222   )
          print  @i
		  print  @j
	   if @i=@j and @k=1
	      begin
		      insert into temp3333 (Dates,newcustomermonthly)
	               select  Dates=@Begindate,count(temp1111.customermonthly)
	                  from temp1111 
		     update  temp3333 
	            set oldcustomermonthly=0,
				    Totalcustomermonthly=newcustomermonthly
	                 where temp3333.Dates=@Begindate
					
	      end
	    else if @i<>@j and @k=1
	      begin
		      insert into temp3333 (Dates,oldcustomermonthly)
			      select  @Begindate,count( distinct temp2222.customermonthly)
	                  from temp1111 
	                  left join temp2222  on temp1111.customermonthly=temp2222.customermonthly   
					  where temp2222.customermonthly is not null
		     update  temp3333 
	            set newcustomermonthly=@i-oldcustomermonthly,
				    Totalcustomermonthly=@i
	                 where temp3333.Dates=@Begindate
					
		   end 
	    else if  @k>1
	       begin
             insert into temp3333 (Dates,oldcustomermonthly)
			      select  @Begindate,count(distinct temp2222.customermonthly)
	                  from temp1111 
	                  left join temp2222  on temp1111.customermonthly=temp2222.customermonthly   
					  where temp2222.customermonthly is not null
	         update  temp3333 
	            set Totalcustomermonthly=@i 
	                 where temp3333.Dates=@Begindate

	          update temp3333
	              set newcustomermonthly=Totalcustomermonthly-oldcustomermonthly where Dates=@Begindate
	       end

    
	SET @Begindate = DATEADD(MONTH,1,@Begindate);
	set @nextmonthdate=DATEADD(MONTH,1,@Begindate);
	set @k=@k+1;
	insert into temp2222 select * from temp1111
    delete temp1111;
	end
	
	go

