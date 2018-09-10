-- show all objects tracked in CodeWrangler for the current database
select * from master.dbo.[codeWrangler] where [dbName] = db_name() ;

-- pick a random object
declare @id int = (select top 1 [oid] from master.dbo.[codeWrangler] where [dbName] = db_name() and [oid] <> 0 order by newid()) ;

-- and view the details for it...
select
	[o].[id],
	[o].[name],
	[o].[xtype],
	[|] = '|',
	[c].[id],
	[c].[name],
	[c].[xtype],
	[c].[xusertype],
	[objText] =
		case
			when [s].[name] in ('char', 'nchar', 'varchar', 'nvarchar')
				then [s].[name] + ' (' + Convert(varchar, [c].[length]) + ')'
			when [s].[name] in ('decimal', 'numeric')
				then [s].[name] + ' (' + Convert(varchar, [c].[prec]) + ', ' + Convert(varchar, [c].[scale]) + ')'
			when [s].[name] in ('float')
				then [s].[name] + ' (' + Convert(varchar, [c].[prec]) + ')'
			else
				[s].[name]
		end
from
	sysobjects o
	inner join syscolumns [c]
		on [o].[id] = [c].[id]
	inner join systypes [s]
		on [c].[xusertype] = [s].[xusertype]
where
	[o].[id] = @id
order by
	[o].[name] asc,
	[c].[colid] asc ;
go
