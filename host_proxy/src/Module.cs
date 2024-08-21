using System;
using System.IO;
using System.Reflection;
using System.Runtime.Loader;

namespace HostProxy 
{
    // Represents a loaded module
    internal class Module
    {
        // The path to the loaded module
        public string ModulePath { get; private set; }

        // The IModuleInfo data provided by the loaded module
        public IModuleInfo ModuleInfo { get; private set; }

        public Module()
        {
        }

        // Load a module. The `path` value may be a path relative 
        // to the `HostProxy.dll` assembly.
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

            // TODO: We load directly into the proxy's load context. This needs
            //       to occur or HostProxy won't be able to find the IModuleInfo
            //       implementation in the module.
            //
            //       The down side is this gives the module access to all the 
            //       public types in HostProxy, which may not be desired. We should
            //       consider moving Module interfaces and APIs into a separate 
            //       assembly or see if we can load the modules into a separate
            //       load context while allowing some types to interact between
            //       them. I'm not sure if the latter is possible.
            var loadContext = AssemblyLoadContext.GetLoadContext(Assembly.GetExecutingAssembly());
            var assembly = loadContext.LoadFromAssemblyPath(path);
            var moduleInfoType = typeof(IModuleInfo);

            // Search the assembly types to find its IModuleInfo implementation
            // TODO: Use attributes for this?
            // TODO: Support multiple IModuleInfo instances per module?
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
