using Xunit;

namespace DropSchema.SqlServer.Test
{
    public class ScriptVariableInflaterTest
    {
        [Fact]
        public void Test_InflateScript_Replaces_Variables_With_Values()
        {
            const string sourceString = "this is $something$ what contains \r\n$variables$";
            const string expectedString = "this is new-something what contains \r\nnew-variables";
            string resultString = new ScriptVariableInflater()
                .AddVariableWithValue("something", "new-something")
                .AddVariableWithValue("variables", "new-variables")
                .InflateScript(sourceString);

            Assert.Equal(expectedString, resultString);
        }
    }
}