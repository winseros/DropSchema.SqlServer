if not exists(select *
              from sys.schemas
              where name = 'maintance')
    exec ('create schema maintance')

if (exists(select 1
           from [sys].[procedures]
           where name = 'DropTableForeignKeys'))
    begin
        print 'Drop procedure [maintance].[DropTableForeignKeys]'
        drop procedure maintance.[DropTableForeignKeys]
    end

print 'Create procedure [maintance].[DropTableForeignKeys]'