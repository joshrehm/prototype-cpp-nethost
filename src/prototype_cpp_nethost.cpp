#include"prototype_cpp_nethost/prototype_cpp_nethost.h"
#include"prototype_cpp_nethost/dotnet_host_loader.h"
#include"prototype_cpp_nethost/dotnet_host_proxy.h"
#include"prototype_cpp_nethost/native_host_proxy.h"

#include<array>
#include<cassert>
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

void __stdcall debug_log(char const* message, std::int32_t length=-1)
{
    if (length < 0)
    {
        auto const message_length = strlen(message);
        assert(message_length <= std::numeric_limits<std::int32_t>::max());
        length = static_cast<std::int32_t>(message_length);
    }
    std::copy(message, message + length, std::ostream_iterator<char> { std::cout });
}

// Populate an instance of `native_host_proxy` with function pointers we want to 
// expose to managed code.
native_host_proxy get_native_proxy()
{
    return native_host_proxy
    {
        .debug_log = &debug_log
    };
}

int main()
{
    auto const bootstrap = load_dotnet_host();

    // Bootstrap the proxy assembly. Provide it a list of native function pointers
    // it can use to call into native code as well as memory space for it to store
    // its own function pointers for calling into .net
    //
    // The size of the structures are passed to the proxy, allowing it to do basic
    // version checking. This requires that the order and number of function 
    // pointers never change once the API is released.
    auto dotnet_proxy = dotnet_host_proxy {};
    auto native_proxy = get_native_proxy();
    bootstrap(&native_proxy, sizeof(native_proxy),
              &dotnet_proxy, sizeof(dotnet_proxy));
    
    // donet_proxy now contains function pointers into managed space that we
    // may call.
    // 
    // TODO: Add ability to load modules (get a managed IModule) that we can use with
    //       donet_proxy.

    return 0;
}
