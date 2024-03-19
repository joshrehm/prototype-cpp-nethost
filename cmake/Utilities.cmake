#
# Define global project level cmake options in this file. Syntax:
#
#   opt(VARIABLE TYPE VALUE "Description")
#
function(opt name type default description)
    if (type STREQUAL "BOOL")
        option(${name} ${description} ${default})
    else()
        set(${name} ${default} CACHE ${type} ${description})
    endif()
endfunction()

# Output the positive if the given variable is TRUE. Otherwise output the negative message.
#
# Syntax:
#     message_bool(VALUE "Positive message" "Negative message" [MODE mode])
#
# Mode may be any value accepted by `message()`.
function(message_bool value positive negative)
    cmake_parse_arguments(ARG "" "MODE" "" ${ARGN})

    if (NOT DEFINED ARG_MODE)
        set(ARG_MODE "NOTICE")
    endif()

    if (${value})
        message(${ARG_MODE} ${positive})
    else()
        message(${ARG_MODE} ${negative})
    endif()
endfunction()

# Generate a version header and optionally store the version in an
# output variable.
#
# Header file templates may use the @VERSION@, @VERSION_MAJOR@,
# #VERSION_MINOR@, @VERSION_REVISION@ or @VERSION_PATCH@, and
# @VERSION_BUILD@ variables.
#
# If VARIABLE is specified, the output variables `<variable>`,
# `<variable>_MAJOR`, `<variable>_MINOR`, `<variable>_REVISION`,
# `<version>_PATCH`, `<version>_BUILD` will be defined.
#
# The value of `<variable>` will be MAJOR.MINOR.REVISION.BUILD.
#
# PATCH and REVISION variables are the same value.
#
# Syntax: generate_version_header("<input>"
#                                 "<output>"
#                                 FROM_TEMPLATE "<template>"
#                                 [VARIABLE <variable>])
function(generate_version_header INPUT OUTPUT)
    cmake_parse_arguments(PARSE_ARGV 2 ARG "" "FROM_TEMPLATE;VARIABLE" "")
  
    # Read the version string from the input file and convert the value into a CMake list
    file(STRINGS ${INPUT} VERSION LIMIT_COUNT 1 ENCODING UTF-8 REGEX "^[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?$")

    string(REPLACE "." "," VERSION_COMMA ${VERSION} )
    string(REPLACE "." ";" VERSION_PARTS ${VERSION})

    list(LENGTH VERSION_PARTS VERSION_PARTS_LENGTH)
    if (VERSION_PARTS_LENGTH LESS 3 OR VERSION_PARTS_LENGTH GREATER 4)
        message(FATAL_ERROR "Incorrect VERSION file format. Use Major.Minor.Patch or Major.Minor.Patch.Build")
    endif()

    list(GET VERSION_PARTS 0 VERSION_MAJOR)
    list(GET VERSION_PARTS 1 VERSION_MINOR)
    list(GET VERSION_PARTS 2 VERSION_PATCH)
    list(GET VERSION_PARTS 2 VERSION_REVISION)
    if (VERSION_PARTS_LENGTH EQUAL 4)
        list(GET VERSION_PARTS 3 VERSION_BUILD)
    else()
        string(TIMESTAMP VERSION_BUILD "%y%j")
        set(VERSION "${VERSION}.${VERSION_BUILD}")
    endif()

    # Generate output variable names
    if (ARG_VARIABLE)
        set("${ARG_VARIABLE}"          ${VERSION} PARENT_SCOPE)
        set("${ARG_VARIABLE}_COMMA"    ${VERSION_COMMA} PARENT_SCOPE)
        set("${ARG_VARIABLE}_MAJOR"    ${VERSION_MAJOR} PARENT_SCOPE)
        set("${ARG_VARIABLE}_MINOR"    ${VERSION_MINOR} PARENT_SCOPE)
        set("${ARG_VARIABLE}_REVISION" ${VERSION_REVISION} PARENT_SCOPE)
        set("${ARG_VARIABLE}_PATCH"    ${VERSION_PATCH} PARENT_SCOPE)
        set("${ARG_VARIABLE}_BUILD"    ${VERSION_BUILD} PARENT_SCOPE)
    endif()
    
    # Monitor the input file for changes. We do not need to monitor the template
    #because CMake will take care of it automatically when we call configure_file().
    set_property(DIRECTORY PROPERTY CMAKE_CONFIGURE_DEPENDS ${INPUT})

    # Generate the header file.
    configure_file(${ARG_FROM_TEMPLATE} ${OUTPUT} @ONLY)
endfunction()

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
        include(DefaultMsvcCompilerDefinitions)
    endif()
endfunction()

function(set_standard_target_compile_options target)
    if(MSVC)
        include(DefaultMsvcCompilerOptions)
    endif()
endfunction()

function(set_standard_target_link_options target)
    # TODO: Using OPT:ICF can cause the debugger to do janky things. This may be why
    #       we have a hard time debugging release builds (other than optimizations,
    #       of course). Maybe experiment with that.
    if(MSVC)
        include(DefaultMsvcLinkOptions)
    endif()
endfunction()

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
