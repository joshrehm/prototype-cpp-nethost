set(DOTNET_HOST_ARCH "${CMAKE_SYSTEM_PROCESSOR}" CACHE STRING "Requested .NET Host architecture")

if (DOTNET_HOST_ARCH MATCHES "amd64|AMD64|x64|x86_64")
    set(TARGET_ARCH_NAME "win-x64")
elseif(DOTNET_HOST_ARCH MATCHES "x86|i386")
    set(TARGET_ARCH_NAME "win-x86")
elseif(DOTNET_HOST_ARCH MATCHES "arm64|ARM64")
    set(TARGET_ARCH_NAME "win-arm64")
else()
    set(TARGET_ARCH_NAME "${DOTNET_HOST_ARCH}")
endif()

set(DOTNET_HOST_ROOT_DIR "C:/Program Files/dotnet/packs/Microsoft.NETCore.App.Host.${TARGET_ARCH_NAME}" 
   CACHE PATH "Root directory of .NET installation")

if(NOT nethostfxr_FIND_VERSION)
    file(GLOB AVAILABLE_VERSIONS RELATIVE "${DOTNET_HOST_ROOT_DIR}" "${DOTNET_HOST_ROOT_DIR}/*")
    list(SORT AVAILABLE_VERSIONS COMPARE NATURAL)
    list(GET AVAILABLE_VERSIONS -1 nethostfxr_FIND_VERSION)
endif()

set(DOTNET_HOST_DIR "${DOTNET_HOST_ROOT_DIR}/${nethostfxr_FIND_VERSION}/runtimes/${TARGET_ARCH_NAME}/native")
if (EXISTS "${DOTNET_HOST_DIR}")
    set(nethostfxr_VERSION "${nethostfxr_FIND_VERSION}")

    find_library(nethostfxr_LIBRARY NAMES nethost.lib PATHS "${DOTNET_HOST_DIR}")
    find_file(nethostfxr_RUNTIME_LIBRARY NAMES nethost.dll PATHS "${DOTNET_HOST_DIR}")
    find_path(nethostfxr_INCLUDE_DIR NAMES nethost.h hostfxr.h PATHS "${DOTNET_HOST_DIR}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(nethostfxr
    FOUND_VAR nethostfxr_FOUND
    REQUIRED_VARS
        nethostfxr_LIBRARY
        nethostfxr_INCLUDE_DIR
        nethostfxr_RUNTIME_LIBRARY
    VERSION_VAR nethostfxr_VERSION
)

if (nethostfxr_FOUND)
    set(nethostfxr_INCLUDE_DIRS "${DOTNET_HOST_DIR}")
    set(nethostfxr_LIBRARY_DIRS "${DOTNET_HOST_DIR}")
    set(nethostfxr_RUNTIME_LIBRARY_DIRS "${DOTNET_HOST_DIR}")
    set(nethostfxr_LIBRARIES "nethost.lib;hostfxr.lib")
endif()

if (nethostfxr_FOUND AND NOT TARGET nethostfxr::nethostfxr)
    add_library(nethostfxr::nethostfxr SHARED IMPORTED)
    set_target_properties(nethostfxr::nethostfxr PROPERTIES
        IMPORTED_LOCATION "${nethostfxr_RUNTIME_LIBRARY}"
        IMPORTED_IMPLIB "${nethostfxr_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${nethostfxr_INCLUDE_DIR}"
    )
endif()

mark_as_advanced(nethostfxr_INCLUDE_DIR nethostfxr_LIBRARY)
