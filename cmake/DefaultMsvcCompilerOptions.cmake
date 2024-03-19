target_compile_options(${target} PRIVATE
    /EHsc                # Standard C++ exceptions; extern "C" functions won't throw
    /FC                  # Output entire source file path in diagnostics
    /GS                  # Enable buffer overrun security checks
    /permissive-         # Disable MS Extensions
    /W4 /WX              # Level 4 warnings and warnings are errors
    /Zc:__cplusplus      # Enable standard __cplusplus macro conformance
    /Zc:__STDC__         # Enable standard __STDC__ macro comformance
    /Zc:enumTypes        # Enable standard comformance enum type deduction
    /Zc:externConstexpr  # Enable standard conformance extern constexpr variables
    /Zc:templateScope    # Enable standard conformance of template parameter shadowing
    /Zc:throwingNew      # Enable throwing new
    /Zi                  # Enable PDB generation (no edit and continue)
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_compile_options(${target} PRIVATE
        /Od                # Disable optimizations
        /RTC1              # Enable stack frame checks and reporting of used unintialized variables
    )
elseif(CMAKE_BUILD_TYPE STREQUAL "Release" OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    target_compile_options(${target} PRIVATE
        /GL                # Enable whole program optimization
        /Gw                # Optimize Global data
        /O2                # Maximize speed
        /Oy                # Omit frame pointers
        /Zc:checkGwOdr     # Enforce C++ standard ODR violations (On unless /GW is used)
        /Zc:inline         # Remove unreferenced data or functions in COMDAT or internal linkage
        /Zo                # Enhanced debug information for optimized builds
    )
endif()

# CMake does not handle a trailing backslash well on a value stored in the
# compile options list. It either results in the next compile option being 
# appended to d1trimfile, or the closing quotation around d1trimfile (when
# a space is in the path) to be escaped, resulting in the entire remaining
# command line being used as the d1trimfile value. So, we just don't put
# a trailing slash.
#
# This results in all the __FILE__ macro paths starting with a backslash, 
# the alternative is constantly trying to figure out why compiler options 
# suddenly broke.
#
# /d1trimfile removes the root path from __FILE__ and related macros in 
# source code. This prevents personal paths from being output in log files 
# and crash dumps.
string(REPLACE "/" "\\" D1_TRIM_FILE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
target_compile_options(${target} PRIVATE
    /d1trimfile:${D1_TRIM_FILE_PATH}
)
