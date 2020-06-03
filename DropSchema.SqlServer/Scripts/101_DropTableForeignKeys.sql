--drops all the table foreign keys
create procedure maintance.[DropTableForeignKeys] @tableId int --target table id
as
begin
    set nocount on

    print 'Dropping foreign keys referencing table: ' + convert(varchar(15), @tableId)

    declare KeysCursor cursor forward_only read_only for select fk.name, tbl.name, sc.name
                                                         from [sys].[foreign_keys] fk
                                                                  join [sys].[tables] tbl on fk.parent_object_id = tbl.object_id
                                                                  join [sys].[schemas] sc on tbl.schema_id = sc.schema_id
                                                         where fk.referenced_object_id = @tableId

    declare @sql varchar(255), @targetSchemaName varchar(100), @targetTableName varchar(100), @targetKeyName varchar(100)

    open KeysCursor

    fetch next from KeysCursor into @targetKeyName, @targetTableName, @targetSchemaName
    while (@@FETCH_STATUS = 0) begin
        set @sql = 'alter table [' + @targetSchemaName + '].[' + @targetTableName + '] drop constraint ' +
                   @targetKeyName
        print 'Running sql: ' + @sql
        exec (@sql)
        fetch next from KeysCursor into @targetKeyName, @targetTableName, @targetSchemaName
    end

    close KeysCursor
    deallocate KeysCursor

    print 'Dropped foreign keys referencing table: ' + convert(varchar(15), @tableId)
end
