#
# Set up our executable
add_executable(prototype_cpp_nethost
    "prototype_cpp_nethost.cpp"
 )

set_standard_target_options(prototype_cpp_nethost)

#
# Enable CppCheck
if (PROTOTYPE_CPP_NETHOST_ENABLE_CPPCHECK)
    include(CppCheck)
    enable_cppcheck(prototype_cpp_nethost)
endif()

#
# Set output directory
set_target_properties(prototype_cpp_nethost PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${PROTOTYPE_CPP_NETHOST_OUTPUT_PATH})

# Set target includes
target_include_directories(prototype_cpp_nethost
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include
    PUBLIC  ${CMAKE_CURRENT_SOURCE_DIR}/../include)

#
# Set target libraries
find_package(fmt REQUIRED)
target_link_libraries(prototype_cpp_nethost PRIVATE
    fmt::fmt
)
