cmake_minimum_required(VERSION 3.28)

project(hosted_module LANGUAGES CSharp)

add_library(HostedModule SHARED)

set_target_properties(HostedModule PROPERTIES 
    DOTNET_TARGET_FRAMEWORK       "net6.0"
    DOTNET_SDK                    "Microsoft.NET.Sdk"
    VS_PACKAGE_REFERENCES         "System"
    # TODO: Need a way to inject the correct path from the parent project?
    VS_DOTNET_REFERENCE_HostProxy "${CMAKE_SOURCE_DIR}/../.bin/HostProxy.dll"
)

target_compile_options(HostedModule PRIVATE "/platform:x64")

add_subdirectory(src)
