#include"prototype_cpp_nethost/prototype_cpp_nethost.h"
#include"prototype_cpp_nethost/dotnet_host_loader.h"
#include<array>
#include<iostream>
#include<filesystem>
#include<fmt/core.h>

constexpr static wchar_t AssemblyName[]          = L"HostProxy.HostProxy, HostProxy";
constexpr static wchar_t AssemblyFileName[]      = L"HostProxy.dll";
constexpr static wchar_t RuntimeConfigFileName[] = L"HostProxy.runtimeconfig.json";
constexpr static wchar_t DelegateName[]          = L"Bootstrap";

using bootstrap_fn = int (__stdcall *)(void*, int, void*, int);

std::filesystem::path get_executable_path()
{
    wchar_t executable_path[MAX_PATH];
    auto const executable_path_length = GetModuleFileNameW(nullptr, executable_path, 
        static_cast<DWORD>(std::size(executable_path)));
    if (executable_path_length == 0 || executable_path_length == std::size(executable_path))
        throw std::runtime_error(fmt::format("Unable to determine executable path (Error code {})", GetLastError()));

    return std::filesystem::path { executable_path } .parent_path();
}

bootstrap_fn load_dotnet_host()
{
    bootstrap_fn bootstrap;
    dotnet_host_loader loader;

    auto const executable_dir = get_executable_path();
    if (auto const rc = loader.get_bootstrap_delegate(
        &bootstrap, 
        DelegateName,
        AssemblyName,
        (executable_dir / AssemblyFileName).wstring().c_str(),
        (executable_dir / RuntimeConfigFileName).wstring().c_str()))
    {
        throw std::runtime_error(fmt::format("Failed to load .NET Assembly (Error code {})", rc));
    }

    return bootstrap;
}

int main()
{
    [[maybe_unused]]
    auto const bootstrap = load_dotnet_host();
    
    // TODO: Call bootstrap. See bootstrap.cs for more details
    
    return 0;
}
