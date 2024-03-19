# Enable cppcheck static code analysis for the specified target
#
# Syntax:
#     enable_cppcheck(<target> [NO_DEFAULT_OPTIONS] [OPTIONS options...])
#
function(enable_cppcheck target)
    cmake_parse_arguments(ARG "NO_DEFAULT_OPTIONS" "" "OPTIONS" ${ARGN})

    # Locate cppcheck. If this function was called, cppcheck is required.
    find_program(CPP_CHECK cppcheck REQUIRED)
    
    # Set error output format based on the OS. Assume MSVC on Windows and GCC on Linux.
    if (WIN32)
        # Customize output in 'vs' format, but adds the rule name to the end
        set(CPPCHECK_TEMPLATE "{file}({line}): {severity}: [{id}] {message}")
        
        if (CMAKE_SIZEOF_VOID_P EQUAL 4)
            # We should always be calling the W API variants of Win32 functions. Tell
            # cppcheck this.
            set(CPPCHECK_PLATFORM "win32W")
        else()
            set(CPPCHECK_PLATFORM "win64")
        endif()
    else()
        set(CPPCHECK_TEMPLATE "gcc")

        if (CMAKE_SIZEOF_VOID_P EQUAL 4)
            set(CPPCHECK_PLATFORM "unix32")
        else()
            set(CPPCHECK_PLATFORM "unix64")
        endif()
    endif()

    set(CPPCHECK_DEFAULT_ARGS
        --quiet
        --template=${CPPCHECK_TEMPLATE}
        --std=c++${CMAKE_CXX_STANDARD}
        --platform=${CPPCHECK_PLATFORM}
        --enable=performance,portability,style,warning
        --inconclusive
        --inline-suppr
        --suppress=cppcheckError               # Ignore cppcheck internal analysis errors
        --suppress=internalAstError            # Ignore cppcheck internal AST errors
        --suppress=functionConst               # Technically the member 'x' can be const (lots of false positives)
        --suppress=functionStatic              # Technically the member 'x' can be const (lots of false positives)
        --suppress=passedByValue               # Lots of false positives
        --suppress=preprocessorErrorDirective  # Ignore #error preprocessor directives
        --suppress=syntaxError                 # Ignore C++ syntax errors
        --suppress=unmatchedSuppression        # Ignore cppcheck warnings about no errors to suppress
    )

    if (NOT ARG_NO_DEFAULT_OPTIONS)
        set(CPPCHECK_ARGS ${CPPCHECK_DEFAULT_ARGS})
    endif()

    if (ARG_OPTIONS)
        list(APPEND CPPCHECK_ARGS ${ARG_OPTIONS})
    endif()

    set_property(TARGET ${target} PROPERTY CXX_CPPCHECK ${CPP_CHECK} ${CPPCHECK_ARGS})

    if (${PROJECT_NAME}_WARNINGS_AS_ERRORS)
        # Set error code if issues are found. This will result in warnings being treated as errors
        set_property(TARGET ${target} APPEND PROPERTY CXX_CPPCHECK --error-exitcode=2)
    endif()
endfunction()
