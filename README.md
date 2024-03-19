# prototype-cpp-nethost Repository

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
