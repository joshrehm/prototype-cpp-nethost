namespace HostProxy
{
    public interface IModuleInfo
    {
        string Name { get; }
        string Namespace { get; }
        string Version { get; }
        string AssemblyName { get; }
    }
}
