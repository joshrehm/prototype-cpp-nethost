#pragma once

#include<cstdint>

struct module_t { };

// Contains a list of function pointers to .NET Proxy functions responsible for delegating
// native calls into .NET calls.
struct dotnet_host_proxy
{
    module_t* (__stdcall* Module_Load)(char const* path);
    void (__stdcall* Module_Release)(module_t* moduleHandle);
    int (__stdcall* Module_Name)(module_t* moduleHandle, char* out_buffer, std::int32_t out_size);
    int (__stdcall* Module_Namespace)(module_t* moduleHandle, char* out_buffer, std::int32_t out_size);
    int (__stdcall* Module_Version)(module_t* moduleHandle, char* out_buffer, std::int32_t out_size);
    int (__stdcall* Module_AssemblyName)(module_t* moduleHandle, char* out_buffer, std::int32_t out_size);
};
