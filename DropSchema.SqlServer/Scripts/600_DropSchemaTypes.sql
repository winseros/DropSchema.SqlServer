set nocount on

if (not exists(select 1
               from [sys].[schemas]
               where name = '$SchemaName$'))
    begin
        print 'Schema not found: ' + '$SchemaName$'
        return
    end

print 'Dropping types of schema: ' + '$SchemaName$'

--get the schema id by name
declare @schemaId int
set @schemaId = (select schema_id
                 from [sys].[schemas]
                 where name = '$SchemaName$')

--get the schema types
declare TypesCursor cursor forward_only read_only for select name
                                                      from [sys].[types]
                                                      where schema_id = 1

                                                                            open TypesCursor

declare @sql varchar(255), @typeName varchar(100)

--remove the types
fetch next from TypesCursor into @typeName
while (@@FETCH_STATUS = 0) begin
    set @sql = 'Drop type [' + '$SchemaName$' + '].[' + @typeName + ']'
    print 'Running sql: ' + @sql
    exec (@sql)
    fetch next from TypesCursor into @typeName
end

--cleanout resources
close TypesCursor
    deallocate TypesCursor
