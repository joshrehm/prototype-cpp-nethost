# prototype-cpp-nethost Repository

Demonstrates self-hosting the .NET runtime in a C++ application and
making function calls between both the host and the hosted assembly.

This project is based on the content in [this](https://learn.microsoft.com/en-us/dotnet/core/tutorials/netcore-hosting) 
tutorial using the `nethost.h` and `hostfxr.h` headers along with the
`nethost.lib` and `nethost.dll` libraries.

# Configure and Build

## Requirements

 - Conan 2.0+
 - CMake 3.28+

## Configure Step

This project integrates Conan 2 into the build process. Conan is automatically
invoked during the cmake configuration process.

To configure the project with tests:

```
cmake --preset=<preset_name>
```

The `<preset_name>` placeholder should be an available preset defined in
CMakePresets.json:

- windows-x64-debug
- windows-x64-release

Available cmake cache variables are described below:

### Global Variables

 - `WARNINGS_AS_ERRORS`: Treats compiler warnings as errors. `ON` by default. This 
   variable is "global" in that it affects the default value of all subprojets that
   utilize this template.
 - `PROJECT_OUTPUT_PATH`: Specifies the output path of built binaries. The default is 
   the project's `.bin` directory. This variable is "global" in that it affects the 
   default value of all subprojects that utilize this template.
   
### PROTOTYPE_CPP_NETHOST Variables

 - `DOTNET_HOST_ARCH`: Specifies the .NET Host Architecture. Defaults based on the 
   current processor architecture. This name should match the architecture value used
   in the .NET host directory name (e.g. win-x64).
 - `DOTNET_HOST_ROOT_DIR`: Specifies the root directory of the .NET host to load.
   By default this is "C:/Program Files/dotnet/packs/Microsoft.NETCore.App.Host.${DOTNET_HOST_ARCH}".
 - `PROTOTYPE_CPP_NETHOST_OUTPUT_PATH`: Specifies the output path of this project's 
   built binaries. Unlike `PROJECT_OUTPUT_PATH`, this variable affects only this
   project. Defaults to `${PROJECT_OUTPUT_PATH}`.
 - `PROTOTYPE_CPP_NETHOST_ENABLE_CPPCHECK`: Enables cppcheck static analysis. `ON`
   by default.
 - `PROTOTYPE_CPP_NETHOST_WARNINGS_AS_ERRORS`: Treats compiler warnings as errors.
   Set to `${WARNINGS_AS_ERRORS}` by default.


## Build Step

To build the project:

```
cmake --build --preset=<preset_name>
```

Alternatively you may open the project in Visual Studio or Visual Studio Code and 
build from the menu after selecting your desire configuration. Other IDEs may 
work, but they have not been tested.

By default, output binaries will be put into the project's `.bin` directory.
