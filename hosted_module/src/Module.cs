using System;

namespace HostedModule
{
    public class Module : HostProxy.IModule
    {
        public string Name { get { return "HostedProxy"; } }
        public string Namespace { get { return "HostedModule"; } }
        public string AssemblyName { get { return "HostedModule.dll"; } }
        public string AssemblyVersion { get { return "1.0.0"; } }
    }
}
