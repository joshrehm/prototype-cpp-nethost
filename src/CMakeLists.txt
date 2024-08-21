#
# Set up our executable
add_executable(prototype_cpp_nethost
    "prototype_cpp_nethost.cpp"
 )

# Set target includes
target_include_directories(prototype_cpp_nethost
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../include
    PUBLIC  ${CMAKE_CURRENT_SOURCE_DIR}/../include)

#
# Set output directory
set_target_properties(prototype_cpp_nethost PROPERTIES
    CXX_STANDARD              20
    CXX_STANDARD_REQUIRED     TRUE
    RUNTIME_OUTPUT_DIRECTORY ${PROTOTYPE_CPP_NETHOST_OUTPUT_PATH})

include(SetCompilerProperties)
set_standard_target_options(prototype_cpp_nethost)

# TODO: These don't work; supposedly needed to allow mixed mode debugging
# if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
#     target_link_options(prototype_cpp_nethost PUBLIC /DEBUG /ASSEMBLYDEBUG)
# endif()

#
# Set target libraries
find_package(NetHostFxr REQUIRED)

target_link_libraries(prototype_cpp_nethost PRIVATE
    NetHostFxr::DotNetHost
)

# Ensure the nethost dll is copied to the output directory so our application runs
add_custom_command(TARGET prototype_cpp_nethost POST_BUILD
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different 
    "${NetHostFxr_RUNTIME_LIBRARY_DIRS}/nethost.dll"
    "$<TARGET_FILE_DIR:prototype_cpp_nethost>")
