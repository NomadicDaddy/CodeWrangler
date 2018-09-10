use [master] ;
go

set quoted_identifier, ansi_nulls on ;

if exists (select 1 from INFORMATION_SCHEMA.ROUTINES where [routine_name] = 'udf_longHash')
	drop function dbo.[udf_longHash] ;
go

create function dbo.[udf_longHash] (
	@data varbinary(max)
)
returns varbinary(max)
with returns null on null input
as
begin

-----------------------------------------------------------------------------------------------------------------------
-- Procedure:	udf_longHash
-- Author:		Phillip Beazley (phillip@beazley.org)
-- Date:		06/08/2012
--
-- Purpose:		Generates an MD5 digest/hash against each 8K hunk of the input, concatenates those and then generates
--				another digest/hash against that string. No, it's not ideal.
--
-- Notes:		n/a
--
-- Depends:		n/a
--
-- REVISION HISTORY ---------------------------------------------------------------------------------------------------
-- 06/08/2012	lordbeazley	Initial creation.
-----------------------------------------------------------------------------------------------------------------------

declare
	@res varbinary(max),
	@position int,
	@len int ;

set @res = 0x ;
set @position = 1 ;
set @len = datalength(@data) ;

while (@position < @len)
begin
	set @res = @res + hashbytes('MD5', substring(@data, @position, 8000)) ;
	set @position = @position + 8000 ;
end
set @res = hashbytes('MD5', Left(@res, 8000)) ;

return @res ;

end
go

-- report success/failure and assign permissions as needed
if (exists (select 1 from INFORMATION_SCHEMA.ROUTINES where [routine_name] = 'udf_longHash'))
begin
	print ':: installed dbo.[udf_longHash] on ' + Convert(varchar, serverproperty('servername')) ;
	grant execute on [udf_longHash] to public ;
end
else
	print ':: failed to install dbo.[udf_longHash] on ' + Convert(varchar, serverproperty('servername')) ;
go
return ;

-- example(s)
declare @theHash varbinary(max) ;
select @theHash = dbo.[udf_longHash](Convert(varbinary(max), Replicate(Convert(varchar(max), 'a'), 9999))) ;
print @theHash ;
