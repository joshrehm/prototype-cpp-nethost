add_library(HostProxy SHARED
    Bootstrap.cs
)

set_target_properties(HostProxy PROPERTIES 
    DOTNET_TARGET_FRAMEWORK "net6.0"
    DOTNET_SDK "Microsoft.NET.Sdk"
    VS_PACKAGE_REFERENCES "System;System.Console;System.Runtime.InteropServices"
    VS_GLOBAL_GenerateRuntimeConfigurationFiles "true"
)

target_compile_options(HostProxy PRIVATE "/unsafe" "/platform:x64")
