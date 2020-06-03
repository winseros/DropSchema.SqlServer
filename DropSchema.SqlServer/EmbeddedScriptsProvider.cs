using System.IO;
using System.Linq;
using System.Reflection;

namespace DropSchema.SqlServer
{
    public class EmbeddedScriptsProvider
    {
        public string[] GetScripts()
        {
            Assembly assembly = typeof(EmbeddedScriptsProvider).Assembly;
            string[] resources = assembly.GetManifestResourceNames();
            string[] sql = resources.Where(r => r.EndsWith(".sql"))
                .OrderBy(r => r)
                .Select(r => ReadResource(assembly, r))
                .ToArray();
            return sql;
        }

        private static string ReadResource(Assembly assembly, string resourceName)
        {
            using Stream stream = assembly.GetManifestResourceStream(resourceName);
            using var reader = new StreamReader(stream!);

            string text = reader.ReadToEnd();
            return text;
        }
    }
}