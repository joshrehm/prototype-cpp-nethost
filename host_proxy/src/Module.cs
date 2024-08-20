using System;
using System.IO;
using System.Reflection;
using System.Runtime.Loader;

namespace HostProxy 
{
    internal class Module
    {
        public string ModulePath { get; private set; }

        public IModuleInfo ModuleInfo { get; private set; }

        public Module()
        {
        }

        internal static Module Load(string path)
        {
            if (string.IsNullOrEmpty(path))
                throw new ArgumentNullException("path");

            // TODO: Potential security issue. We should restrict loading to
            //       our own directory and not allow absolute paths or paths
            //       that attempt to leave our module directory.
            var assemblyPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            if (!Path.IsPathRooted(path))
                path = Path.Combine(assemblyPath, path);

            if (!File.Exists(path))
                throw new FileNotFoundException("Module not found", path);

            var loadContext = AssemblyLoadContext.GetLoadContext(Assembly.GetExecutingAssembly());
            var assembly = loadContext.LoadFromAssemblyPath(path);
            var moduleInfoType = typeof(IModuleInfo);

            foreach(var type in assembly.GetTypes())
            {
                if (type.IsAbstract || !moduleInfoType.IsAssignableFrom(type))
                    continue;

                var moduleInfo = Activator.CreateInstance(type) as IModuleInfo;
                return new Module
                {
                    ModulePath = path,
                    ModuleInfo = moduleInfo
                };
            }

            throw new InvalidOperationException("Module information not found in assembly");
        }
    }
}
