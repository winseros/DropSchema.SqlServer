set nocount on

print 'Dropping procedures of schema: ' + '$SchemaName$'

--get the schema id by name
declare @schemaId int
set @schemaId = (select schema_id
                 from [sys].[schemas]
                 where name = '$SchemaName$')

--get the schema stored procedures names
declare ElementsCursor cursor forward_only read_only for select name
                                                         from [sys].[procedures]
                                                         where schema_id = @schemaId

open ElementsCursor

declare @sql varchar(255), @procedureName varchar(100)

--remove the procedures
fetch next from ElementsCursor into @procedureName
while (@@FETCH_STATUS = 0) begin
    set @sql = 'drop procedure [' + '$SchemaName$' + '].[' + @procedureName + ']'
    print 'Running sql: ' + @sql
    exec (@sql)
    fetch next from ElementsCursor into @procedureName
end

--cleanout resources
close ElementsCursor
deallocate ElementsCursor

print 'Dropped procedures of schema: ' + '$SchemaName$'