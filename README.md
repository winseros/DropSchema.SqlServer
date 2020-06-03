# DropSchema SQL Server

When I write tests which have to work with a real SQL database, almost in each project in tests I have to repeat the pattern:

1. Drop database schema
2. Apply migrations
3. Seed data
4. Run test

This library - is my effort to save myself from carrying the `"1. Drop database schema"` item as a raw code.

The librady scans the database schema you target and wipes all the _tables_/_views_/_procedures_/_functions_/_etc_ so subsequent migrations can run on a "clean" database and give a predictable result.

## Usage

Somewhere in your test infrastructure code:

```csharp
public static void DropSchema()
{
    //somehow get the connection string
    //pls note, the user must have at least the
    // db_ddladmin+db_datawriter+db_datareader permissions
    string cs = GetDbConnectionString();

    using var conn = new SqlConnection(cs);
    using var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
    conn.Open();
    new DropSchema(conn).Run("some-schema");//or "dbo" - the most often
}
```

And later in your test code:

```csharp
[Test]
public void Test_MyMethod_Should_Do_Somethind_Nice()
{
    DropSchema();
    //apply migrations
    //seed data
    //run test
}
```