cmake_minimum_required(VERSION 3.28)

project(hosted_module LANGUAGES CSharp)

add_library(HostedModule SHARED)

set_target_properties(HostedModule PROPERTIES 
    DOTNET_TARGET_FRAMEWORK       "net6.0"
    DOTNET_SDK                    "Microsoft.NET.Sdk"
    VS_PACKAGE_REFERENCES         "System"

    # TODO: Need a way to inject the correct path from the parent project?
    VS_DOTNET_REFERENCE_HostProxy      "${CMAKE_SOURCE_DIR}/../.bin/HostProxy.dll"

    # TODO: This doesn't work; supposedly needed to allow mixed mode debugging
    #VS_GLOBAL_EnableUnmanagedDebugging          "true"
)

target_compile_options(HostedModule PRIVATE "/platform:x64")

if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    # This is necessary to allow debugging with coreclr.
    target_compile_options(HostedModule PRIVATE "/debug:portable")
endif()

add_subdirectory(src)
