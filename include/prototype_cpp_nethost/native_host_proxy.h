#pragma once

#include<cstdint>

// Contains a list of function pointers to native functions for delegating .NET calls 
// into native calls
struct native_host_proxy
{
    void(__stdcall* debug_log)(char const* buffer, std::int32_t length);
};
