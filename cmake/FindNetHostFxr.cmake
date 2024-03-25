# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindNetHostFxr
-------

Finds the .NET Runtime Host by utilizing the hostfxr library.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``NetHostFxr::DotNetHost``
  The .NET Runtime Host library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``NetHostFxr_FOUND``
  True if the system has the Foo library.
``NetHostFxr_VERSION``
  The version of the .NET Host Runtime library which was found.
``NetHostFxr_VERSION_STRING``
  The version of the .NET Host Runtime library which was found.
``NetHostFxr_INCLUDE_DIRS``
  Include directories needed to use .NET Host Runtime.
``NetHostFxr_LIBRARY_DIRS``
  Library directories needed to use .NET Host Runtime.
``NetHostFxr_LIBRARIES``
  Libraries needed to link to .NET Host Runtime.
``NetHostFxr_RUNTIME_LIBRARY_DIRS``
  Runtime library directories needed to run applications linking to the .NET Host Runtime.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``DOTNET_HOST_ARCH``
  The requestd .NET Runtime Host architecture
``DOTNET_HOST_ROOT_DIR``
  The root directory of the .NET Runtime Host package.
``NetHostFxr_INCLUDE_DIR``
  The directory containing ``coreclr_delegates``, ``hostfxr.h``, and ``nethost.h``.
``NetHostFxr_LIBRARY``
  The path to the ``nethost.lib`` library.
#]=======================================================================]

#
# Set up cache variables for requested architecture and .NET Host path
#
set(DOTNET_HOST_ARCH "${CMAKE_SYSTEM_PROCESSOR}" 
    CACHE STRING "Requested .NET Host architecture. Set to win-x64, win-x86, or win-arm64. The default is selected based on the build system processor architecture.")

if (DOTNET_HOST_ARCH MATCHES "amd64|AMD64|x64|x86_64")
    set(DOTNET_HOST_TARGET_ARCH_NAME "win-x64")
elseif(DOTNET_HOST_ARCH MATCHES "x86|i386")
    set(DOTNET_HOST_TARGET_ARCH_NAME "win-x86")
elseif(DOTNET_HOST_ARCH MATCHES "arm64|ARM64")
    set(DOTNET_HOST_TARGET_ARCH_NAME "win-arm64")
else()
    set(DOTNET_HOST_TARGET_ARCH_NAME "${DOTNET_HOST_ARCH}")
endif()

set(DOTNET_HOST_ROOT_DIR "C:/Program Files/dotnet/packs/Microsoft.NETCore.App.Host.${DOTNET_HOST_TARGET_ARCH_NAME}" 
   CACHE PATH "Root directory of .NET Host installation. The default is 'C:\\Program Files\\dotnet\\packs\\Microsoft.NETCore.App.Host.<arch>'")

#
# Scan the .NET Host path for available runtime versions. Select the latest
#
file(GLOB DOTNET_HOST_AVAILABLE_VERSIONS RELATIVE "${DOTNET_HOST_ROOT_DIR}" "${DOTNET_HOST_ROOT_DIR}/*")
list(SORT DOTNET_HOST_AVAILABLE_VERSIONS COMPARE NATURAL)
list(GET DOTNET_HOST_AVAILABLE_VERSIONS -1 DOTNET_HOST_VERSION)

#
# Set the NetHostFxr_* variables based on the runtime host version we found
#
set(DOTNET_HOST_DIR "${DOTNET_HOST_ROOT_DIR}/${DOTNET_HOST_VERSION}/runtimes/${DOTNET_HOST_TARGET_ARCH_NAME}/native")
if (EXISTS "${DOTNET_HOST_DIR}")
    set(NetHostFxr_VERSION "${DOTNET_HOST_VERSION}")

    find_library(NetHostFxr_LIBRARY NAMES nethost.lib PATHS "${DOTNET_HOST_DIR}")
    find_file(NetHostFxr_RUNTIME_LIBRARY NAMES nethost.dll PATHS "${DOTNET_HOST_DIR}")
    find_path(NetHostFxr_INCLUDE_DIR NAMES nethost.h hostfxr.h PATHS "${DOTNET_HOST_DIR}")
endif()

#
# Let CMake do the version checks and set the FOUND/NOTFOUND variable for us
#
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(NetHostFxr
    FOUND_VAR NetHostFxr_FOUND
    REQUIRED_VARS
        NetHostFxr_LIBRARY
        NetHostFxr_INCLUDE_DIR
        NetHostFxr_RUNTIME_LIBRARY
    VERSION_VAR NetHostFxr_VERSION
)

#
# Set up standard find variables
#
if (NetHostFxr_FOUND)
    set(NetHostFxr_INCLUDE_DIRS "${DOTNET_HOST_DIR}")
    set(NetHostFxr_LIBRARY_DIRS "${DOTNET_HOST_DIR}")
    set(NetHostFxr_LIBRARIES "nethost.lib;hostfxr.lib")
    set(NetHostFxr_RUNTIME_LIBRARY_DIRS "${DOTNET_HOST_DIR}")
    
    set(NetHostFxr_VERSION_STRING "${NetHostFxr_VERSION}")

    string(REPLACE "." ";" DOTNET_HOST_VERSION_COMPONENTS "${NetHostFxr_VERSION}")
    list(GET DOTNET_HOST_VERSION_COMPONENTS 0 NetHostFxr_VERSION_MAJOR)
    list(GET DOTNET_HOST_VERSION_COMPONENTS 1 NetHostFxr_VERSION_MINOR)
    list(GET DOTNET_HOST_VERSION_COMPONENTS 2 NetHostFxr_VERSION_PATCH)
endif()

#
# Set up standard find target
#
if (NetHostFxr_FOUND AND NOT TARGET NetHostFxr::DotNetHost)
    add_library(NetHostFxr::DotNetHost SHARED IMPORTED)

    set_target_properties(NetHostFxr::DotNetHost PROPERTIES
        IMPORTED_LOCATION "${NetHostFxr_RUNTIME_LIBRARY}"
        IMPORTED_IMPLIB "${NetHostFxr_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${NetHostFxr_INCLUDE_DIR}"
    )

    target_compile_definitions(NetHostFxr::DotNetHost INTERFACE
        DOTNET_HOST_VERSION="${NetHostFxr_VERSION}"
        DOTNET_HOST_VERSION_MAJOR=${NetHostFxr_VERSION_MAJOR}
        DOTNET_HOST_VERSION_MINOR=${NetHostFxr_VERSION_MINOR}
        DOTNET_HOST_VERSION_PATCH=${NetHostFxr_VERSION_PATCH}
    )
endif()

#
# Cleanup
#
mark_as_advanced(NetHostFxr_INCLUDE_DIR NetHostFxr_LIBRARY)
unset(DOTNET_HOST_TARGET_ARCH_NAME)
unset(DOTNET_HOST_VERSION_COMPONENTS)
unset(DOTNET_HOST_AVAILABLE_VERSIONS)
unset(DOTNET_HOST_VERSION)
unset(DOTNET_HOST_DIR)
