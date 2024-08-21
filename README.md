# C++ .NET Core Host Prototype

Demonstrates self-hosting the .NET Core runtime in a C++ application 
and making function calls between both the host and the hosted assembly.

This project is based on the content in [this](https://learn.microsoft.com/en-us/dotnet/core/tutorials/netcore-hosting) 
tutorial using the `nethost.h` and `hostfxr.h` headers along with the
`nethost.lib` and `nethost.dll` libraries.

# Configure and Build

## Requirements

 - CMake 3.28+
 - Microsoft Visual Studio 2022

## Configure Step

To configure the project:

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

By default, output binaries will be put into the project's `bin` directory.

## Debugging

See Debugging section under Known Issues, below.


# Project Structure

The overall project is divided into three sub projects:

1. The native host (prototype-cpp-nethost in the `src` directory)
2. A .NET Proxy Assembly (HostProxy in the `host_proxy` directory)
3. An example .NET Module (HostedModule in the `hosted_module` directory)

The prototype-cpp-nethost project is a C++ application that uses the 
NetHost and HostFXR libraries to locate and load a .NET Core runtime.
After loading the runtime, it loads the .NET Proxy Assembly.

The HostProxy is a C# assembly that acts as a bridge between he native
host and any loaded modules. It does most of the heavy lifting in the
project and is responsible for marshalling calls between the native and
managed worlds. It provides managed interfaces loaded modules must adhere
to as well as a .NET wrapper around native functions exposed by the 
native host. It is expected that modules would reference the proxy 
assembly.

The .NET Example Module is a C# assembly that provides a concrete module
implementation. It is loaded by the .NET Proxy, at the native host's 
request, and is then interacted with by the native host. The example 
module also makes calls back to the native host, demonstrating two way
communication between the native host and the loaded module.

## Calls between native and managed code

Upon loading the HostProxy, the native host locates and runs the
static `Bootstrap` method of the HostProxy class. It provides four 
parameters:

  * unmanged and unmanagedBytes
  * managed and managedBytes

The `unmanaged` and `managed` parameters are pointers to blocks of
memory representing function pointers to the raw API exposed by
the native host and the HostProxy.

The `unmanagedBytes` and `managedBytes` represent the size of each
block of memory, respectively. As long as the order of the function 
pointers in the two blocks of memory never change, and the size of
the blocks of memory never shrink, these two parameters can be used
to perform simple API version control as a larger memory size 
implies additional, or newer, function pointers.

The `unmanaged` memory is populated by the native host before the
`Bootstrap` method is called, making the native API immediately
available to the HostProxy. The `Bootstrap` method is responsible
for populating the `managed` memory with function pointers to the
API it exposes to the native host.

> **WARNING:** The order of the function pointers in both blocks
> of memory MUST match between the HostProxy and the native host
> application. Additionally, the function return types, number 
> of parameters, parameter types, and calling convention must
> match exactly. Great care must be taken to provide this guarantee,
> otherwise the application may crash or perform in other 
> unpredictable ways.

After the `Bootstrap` method executes, the native host has a list
of function pointers that call in to the HostProxy, or managed
code, and the HostProxy has an API that can call into the native
host. This API, however, is dangerous and cumbersome to use directly
so both the native host and HostProxy provide a more friendly
API wrapper that should be used instead.

> **TODO:** The native friendly API.


## HostProxy Marshalling

The HostProxy provides an easy to use API that hides the 
implementation details in the raw function pointers provided by
the native host. This API is responsible for marshalling data
types from managed code into the native API. See the `NativeApi.cs`
file for this implementation.

The HostProxy also provides function pointers the native host
can call into. The implementations of these functions are, again,
responsible for marshalling data types from the native API into
managed code. See the `ManagedDelegates.cs` and `ManagedProxy.cs`
files for this implementation.

The `NativeUtilities.cs` file provides helper functions to make
marshalling some types, like strings, easier.


## Module Requirements

To load a module, it must provide a single public class that 
implements the `HostProxy.IModuleInfo` interface and be placed
into the build output directory (`bin` by default).

> **TODO:** Add more requirements as they are needed.


## Additional Functions to add

Some other items to add in the future:

  * An actual use case to demonstrate
  * A cross-boundry error API (probably error codes)
  * Native modules that can be dynamically loaded
    * A mechanism to allow them to provide their own interfaces and
      APIs to extend overall functionality
  * Get it working on Linux


## Directory Structure

```
/
├ .build                  # CMake intermediate files for the project as a whole
├ .build_host_proxy       # CMake intermediate files for HostProxy
├ .build_hosted_module    # CMake intermediate files for HostedModule
├ .vs                     # Visual Studio 2022 project settings
├ .vscode                 # Visual Studio Code project settings
├ bin                     # Build output directory
├ cmake                   # Utility CMake scripts
├ host_proxy              # HostProxy CMake project and source files
├ hosted_module           # HostedModule CMake project and source files
├ include                 # prototype-cpp-nethost public include files
├ src                     # prototype-cpp-nethost source files
├ .gitattributes
├ .gitigore
├ CMakeLists.txt
├ CMakePresets.json
├ LICENSE
└ README.md
```

# Known Issues

**Debugging**

I need to figure out how to get Mixed Mode debugging working in both Visual Visual
Studio 2022 and Visual Studio Code.

Presently native debugging is only available in Visual Studio 2022. I'm sure native
debugging will work fine in Visual Studio Code; I haven't set up a launch 
configuration for it.

I cannot get Visual Studio 2022 to load the CoreCLR debugger. It insists on using the
.NET Framework debugger. As a result, C# debugging does not currently work in
Visual Studio 2022.

To work around this, my launch settings in Visual Studio Code do launch the CoreCLR
debugger and I use that to do my C# debugging. If I need to debug the native code,
I just load it into Visual Studio 2022. I'll set up a native launch configuration 
eventually.


**Security**

Two issues with security:

1. There currently isn't any path validation when loading modules. Production
   code should verify the modules are only loaded from safe locations.
2. We're loading modules into the hosted application's load context. I don't
   really know if this is a problem, but it exposes all of the host proxy
   C# types to the module. Should modules be loaded into a sandbox context?
   Is there a way to allow types to "bleed" between contexts, like
   IModuleInfo? Is this an issue? Need to look into this more.

**Dependencies**

A dependency mechanism, where one loaded module may rely on another, is not
currently implemented. Need to add that at some point.
