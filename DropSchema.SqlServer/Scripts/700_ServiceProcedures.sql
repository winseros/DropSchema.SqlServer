if exists (select 1
          from [sys].[schemas]
          where [name] = 'maintance')
    begin
        drop procedure [maintance].[DropTableForeignKeys]
        drop schema [maintance]
    end
