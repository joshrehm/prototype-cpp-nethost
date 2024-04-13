#pragma once

#include<cstdint>

struct module_t { };

// Contains a list of function pointers to .NET Proxy functions responsible for delegating
// native calls into .NET calls.
struct dotnet_host_proxy
{
    void (__stdcall* Module_Name)(module_t* module, char* out_buffer, std::int32_t out_size);
    void (__stdcall* Module_Namespace)(module_t* module, char* out_buffer, std::int32_t out_size);
    void (__stdcall* Module_AssemblyName)(module_t* module, char* out_buffer, std::int32_t out_size);
    void (__stdcall* Module_AssemblyVersion)(module_t* module, char* out_buffer, std::int32_t out_size);
};
