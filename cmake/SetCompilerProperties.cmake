# Utility functions for setting common/standard compiler options
# based on platform, compiler, and architecture

function(set_standard_target_options target)
    set_standard_target_includes(${target})
    set_standard_target_definitions(${target})
    set_standard_target_compile_options(${target})
    set_standard_target_link_options(${target})
endfunction()

function(set_standard_target_includes target)
endfunction()

function(set_standard_target_definitions target)
    include(DefaultCompilerDefinitions)
    
    if(WIN32)
        include(DefaultWin32CompilerDefinitions)
    endif()

    if(MSVC)
        include(Msvc/DefaultCompilerDefinitions)
    endif()
endfunction()

function(set_standard_target_compile_options target)
    if(MSVC)
        include(Msvc/DefaultCompilerOptions)
    endif()
endfunction()

function(set_standard_target_link_options target)
    # TODO: Using OPT:ICF can cause the debugger to do janky things. This may be why
    #       we have a hard time debugging release builds (other than optimizations,
    #       of course). Maybe experiment with that.
    if(MSVC)
        include(Msvc/DefaultLinkOptions)
    endif()
endfunction()

if(MSVC)
    function(msvc_set_runtime_type target)
        if (NOT MSVC)
            return()
        endif()

        cmake_parse_arguments(ARG "WITH_CLR;STATIC;DYNAMIC" "" "" ${ARGN})

        if (ARG_STATIC AND ARG_DYNAMIC)
            message(FATAL "Cannot specify DYNAMIC and STATIC MSVC runtime on target '${target}'")
        endif()

        if (ARG_WITH_CLR AND ARG_STATIC)
            message(FATAL "CLR not compatible with static MSVC runtime on target '${target}'")
        endif()
        
        if(CMAKE_BUILD_TYPE STREQUAL "Debug")
            if(ARG_STATIC)
                target_compile_options(${target} PRIVATE /MTd)
            elseif(ARG_DYNAMIC)
                target_compile_options(${target} PRIVATE /MDd)
            else()
                message(WARNING "Unknown MSVC runtime link type on target '${target}'")
            endif()
        elseif(CMAKE_BUILD_TYPE STREQUAL "Release" OR 
                CMAKE_BUILD_TYPE STREQUAL "RelMinSize" OR
                CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
            if(ARG_STATIC)
                target_compile_options(${target} PRIVATE /MT)
            elseif(ARG_DYNAMIC)
                target_compile_options(${target} PRIVATE /MD)
            else()
                message(WARNING "Unknown MSVC runtime link type on target '${target}'")
            endif()
        else()
            message(WARNING "Unknown CMAKE_BUILD_TYPE '${CMAKE_BUILD_TYPE}' on '${target}'")
        endif()

        if (ARG_WITH_CLR)
            target_compile_options(${target} PRIVATE /clr)
        endif()
    endfunction()
endif()