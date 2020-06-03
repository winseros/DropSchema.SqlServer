using System.Collections.Generic;

namespace DropSchema.SqlServer
{
    public class ScriptVariableInflater
    {
        private readonly IDictionary<string, string> _variables = new Dictionary<string, string>();

        public ScriptVariableInflater AddVariableWithValue(string name, string value)
        {
            _variables[name] = value;
            return this;
        }

        public string InflateScript(string script)
        {
            foreach (KeyValuePair<string, string> pair in _variables)
            {
                string varName = string.Concat("$", pair.Key, "$");
                script = script.Replace(varName, pair.Value);
            }

            return script;
        }
    }
}