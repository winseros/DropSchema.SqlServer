set nocount on

print 'Dropping functions of schema: ' + '$SchemaName$'

--get the schema id by name
declare @schemaId int
set @schemaId = (select schema_id
                 from [sys].[schemas]
                 where name = '$SchemaName$')

--get the schema stored procedures names
declare ElementsCursor cursor forward_only read_only for select [name]
                                                         from [sys].[objects]
                                                         where schema_id = @schemaId
                                                           and [type] IN ('FN', 'TF', 'IF')

open ElementsCursor

declare @sql varchar(255), @functionName varchar(100)

--remove the procedures
fetch next from ElementsCursor into @functionName
while (@@FETCH_STATUS = 0) begin
    set @sql = 'drop function [' + '$SchemaName$' + '].[' + @functionName + ']'
    print 'Running sql: ' + @sql
    exec (@sql)
    fetch next from ElementsCursor into @functionName
end

--cleanout resources
close ElementsCursor
deallocate ElementsCursor

print 'Dropped functions of schema: ' + '$SchemaName$'
