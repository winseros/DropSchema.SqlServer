using Xunit;

namespace DropSchema.SqlServer.Test
{
    public class EmbeddedScriptsProviderTest
    {
        [Fact]
        public void Test_GetScripts_Returns_Embedded_Scripts()
        {
            string[] scripts = new EmbeddedScriptsProvider().GetScripts();
            Assert.Equal(7, scripts.Length);
        }
    }
}