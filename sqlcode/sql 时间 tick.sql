use [TradewiseFromCN]
declare @date as date, @ticksPerDay as bigint;
set @date = getdate()
set @ticksPerDay = 864000000000

declare @date2 datetime2 = @date

declare @dateBinary binary(9) = cast(reverse(cast(@date2 as binary(9))) as binary(9))
declare @days bigint = cast(substring(@dateBinary, 1, 3) as bigint)
declare @time bigint = cast(substring(@dateBinary, 4, 5) as bigint)

select @date as [DateTime], @date2 as [DateTime2], @days * @ticksPerDay + @time as [Ticks]