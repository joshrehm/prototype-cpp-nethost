using System;

namespace HostedModule
{
    // Example implementation of a HostProxy.IModuleInfo
    public class ModuleInfo : HostProxy.IModuleInfo
    {
        public string Name { get { return "HostedProxy"; } }
        public string Namespace { get { return "HostedModule"; } }
        public string Version { get { return "1.0.0"; } }
        public string AssemblyName { get { return "HostedModule.dll"; } }
    }
}
