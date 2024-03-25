cmake_minimum_required(VERSION 3.28)

#
# Configure CMake properties
list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

#
# Includes
include(PrototypeCppNethostOptions)

#
# Project setup
generate_version_header("${CMAKE_CURRENT_SOURCE_DIR}/VERSION"
                        "${CMAKE_CURRENT_SOURCE_DIR}/include/prototype_cpp_nethost/prototype_cpp_nethost_version.h"
                        FROM_TEMPLATE  "prototype_cpp_nethost_version.h.in"
                        VARIABLE        PROTOTYPE_CPP_NETHOST_VERSION)
project(prototype_cpp_nethost VERSION ${PROTOTYPE_CPP_NETHOST_VERSION} LANGUAGES C CXX )

#
# Source files
add_subdirectory(src)

#
# Set up our CSharp project as an external project. This is necessary
# because we must use the MSVC generator. Alternatively you can set up
# the whole project to use the MSVC generator, but we use Ninja.
include(ExternalProject)
ExternalProject_add(HostedAssembly
    BUILD_ALWAYS      TRUE
    SOURCE_DIR        "${CMAKE_SOURCE_DIR}/host_proxy"
    BINARY_DIR        "${CMAKE_SOURCE_DIR}/.build_host_proxy"
    CMAKE_GENERATOR    "Visual Studio 17 2022"
    INSTALL_COMMAND   ""
    TEST_COMMAND      ""
)

add_custom_command(TARGET HostedAssembly POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different 
    "${CMAKE_SOURCE_DIR}/.build_host_proxy/src/${CMAKE_BUILD_TYPE}/HostProxy.dll"
    "${CMAKE_SOURCE_DIR}/.bin")

add_custom_command(TARGET HostedAssembly POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different 
    "${CMAKE_SOURCE_DIR}/.build_host_proxy/src/${CMAKE_BUILD_TYPE}/HostProxy.runtimeconfig.json"
    "${CMAKE_SOURCE_DIR}/.bin")
