using System;
using System.Transactions;
using Microsoft.Data.SqlClient;
using Xunit;

namespace DropSchema.SqlServer.Test
{
    public class DropOperationTest
    {
        [Fact]
        public void Test_Run_Cleans_Schema()
        {
            string cs = GetDbConnectionString();

            using var conn = new SqlConnection(cs);
            using var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
            conn.Open();
            new DropOperation(conn).Run("dbo");
        }

        private static string GetDbConnectionString()
        {
            //e.g. "Server=localhost;Database=dev_serv;User Id=dev_adm;Password=1QAZ2wsx3EDC;";
            const string csVarName = "DROP_SCHEMA_TEST_CONN";
            string cs = Environment.GetEnvironmentVariable(csVarName);
            if (string.IsNullOrEmpty(cs))
                throw new ApplicationException($"The environment variable {csVarName} must mbe set for this test to run");
            return cs;
        }
    }
}
