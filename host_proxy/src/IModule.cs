namespace HostProxy
{
    public interface IModule
    {
        string Name { get; }
        string Namespace { get; }
        string AssemblyName { get; }
        string AssemblyVersion { get; }
    }
}
