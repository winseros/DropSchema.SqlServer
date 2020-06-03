set nocount on

print 'Dropping views of schema: ' + '$SchemaName$'

--get the schema id by name
declare @schemaId int
set @schemaId = (select schema_id
                 from [sys].[schemas]
                 where name = '$SchemaName$')

--get the schema stored views names
declare ElementsCursor cursor forward_only read_only for select name
                                                         from [sys].[views]
                                                         where schema_id = @schemaId

open ElementsCursor

declare @sql varchar(255), @viewName varchar(100)

--remove the procedures
fetch next from ElementsCursor into @viewName
while (@@FETCH_STATUS = 0) begin
    set @sql = 'drop view [' + '$SchemaName$' + '].[' + @viewName + ']'
    print 'Running sql: ' + @sql
    exec (@sql)
    fetch next from ElementsCursor into @viewName
end

--cleanout resources
close ElementsCursor
deallocate ElementsCursor

print 'Dropped procedures of schema: ' + '$SchemaName$' 