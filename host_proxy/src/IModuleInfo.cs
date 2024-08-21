namespace HostProxy
{
    // Allows loaded modules to provide information about themselves.
    public interface IModuleInfo
    {
        string Name { get; }
        string Namespace { get; }
        string Version { get; }
        string AssemblyName { get; }
    }
}
