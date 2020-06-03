set nocount on

if (not exists(select 1
               from [sys].[schemas]
               where name = '$SchemaName$'))
    begin
        print 'Schema not found: ' + '$SchemaName$'
        return
    end

print 'Dropping tables of schema: ' + '$SchemaName$'

--get the schema id by name
declare @schemaId int
set @schemaId = (select schema_id
                 from [sys].[schemas]
                 where name = '$SchemaName$')

--get the schema tables
declare TablesCursor cursor forward_only read_only for select object_id, name
                                                       from [sys].[tables]
                                                       where schema_id = @schemaId

open TablesCursor

declare @sql varchar(255), @tableId int, @tableName varchar(100)

--remove the tables
fetch next from TablesCursor into @tableId, @tableName
while (@@FETCH_STATUS = 0) begin
    print 'Drop foreign keys referencig table [' + '$SchemaName$' + '].[' + @tableName + ']'
    exec [maintance].[DropTableForeignKeys] @tableId

    set @sql = 'Drop table [' + '$SchemaName$' + '].[' + @tableName + ']'
    print 'Running sql: ' + @sql
    exec (@sql)
    fetch next from TablesCursor into @tableId, @tableName
end

--cleanout resources
close TablesCursor
deallocate TablesCursor
