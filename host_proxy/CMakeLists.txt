cmake_minimum_required(VERSION 3.28)

project(host_proxy LANGUAGES CSharp)

add_library(HostProxy SHARED)

set_target_properties(HostProxy PROPERTIES 
    DOTNET_TARGET_FRAMEWORK  "net6.0"
    DOTNET_SDK               "Microsoft.NET.Sdk"
    VS_PACKAGE_REFERENCES    "System;System.Runtime;System.Runtime.InteropServices"
    VS_GLOBAL_GenerateRuntimeConfigurationFiles "true"

    # TODO: This doesn't work; supposedly needed to allow mixed mode debugging
    #VS_GLOBAL_EnableUnmanagedDebugging          "true"
)

target_compile_options(HostProxy PRIVATE "/unsafe" "/platform:x64")

if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    # This is necessary to allow debugging with coreclr.
    target_compile_options(HostProxy PRIVATE "/debug:portable")
endif()


add_subdirectory(src)
