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

