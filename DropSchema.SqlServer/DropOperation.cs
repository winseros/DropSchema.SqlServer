using System;
using System.Data.Common;

namespace DropSchema.SqlServer
{
    public class DropOperation 
    {
        private readonly DbConnection _conn;

        public DropOperation(DbConnection conn)
        {
            _conn = conn ?? throw new ArgumentNullException(nameof(conn));
        }

        public void Run(string schema)
        {
            if (string.IsNullOrEmpty(schema) || string.IsNullOrWhiteSpace(schema))
                throw new ArgumentException("Schema can not be null or empty");

            ScriptVariableInflater inflater = new ScriptVariableInflater()
                .AddVariableWithValue("SchemaName", schema);

            string[] scripts = new EmbeddedScriptsProvider().GetScripts();
            foreach (string script in scripts)
            {
                DbCommand command = _conn.CreateCommand();
                command.CommandText = inflater.InflateScript(script);
                command.ExecuteNonQuery();
            }
        }
    }
}