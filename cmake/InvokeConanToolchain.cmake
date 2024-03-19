#
# Determine which type of conan file we're using
if(EXISTS "${CMAKE_SOURCE_DIR}/conanfile.txt")
    set(PROJECT_CONAN_RECIPE "conanfile.txt")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/conanfile.py")
    set(PROJECT_CONAN_RECIPE "conanfile.py")
endif()
    
# If no conan file was detected, leave.
if(NOT PROJECT_CONAN_RECIPE)
    return()
endif()

set(PROJECT_CONAN_RECIPE_FILE "${CMAKE_SOURCE_DIR}/${PROJECT_CONAN_RECIPE}")

# Determine our conan profile location. We check the following locations for profiles:
# - Project root
# - Submodule root (Allows standard library profile definition, preventing duplicate profiles in application projects)
# - Windows profile directory or Linux profile directory
if(EXISTS "${CMAKE_SOURCE_DIR}/conan_profiles/${PROJECT_CONAN_PROFILE}")
    set(PROJECT_CONAN_PROFILE_FILE "${CMAKE_SOURCE_DIR}/conan_profiles/${PROJECT_CONAN_PROFILE}")
elseif(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/conan_profiles/${PROJECT_CONAN_PROFILE}")
    set(PROJECT_CONAN_PROFILE_FILE "${CMAKE_CURRENT_SOURCE_DIR}/conan_profiles/${PROJECT_CONAN_PROFILE}")
elseif(WIN32 AND EXISTS "$ENV{USERPROFILE}/.conan2/profiles/${PROJECT_CONAN_PROFILE}")
    set(PROJECT_CONAN_PROFILE_FILE "$ENV{USERPROFILE}/.conan2/profiles/${PROJECT_CONAN_PROFILE}")
elseif(LINUX AND EXISTS "$ENV{HOME}/.conan2/profiles/${PROJECT_CONAN_PROFILE}")
    set(PROJECT_CONAN_PROFILE_FILE "~/.conan2/profiles/${PROJECT_CONAN_PROFILE}")
else()
    message(FATAL_ERROR "Conan profile ${PROJECT_CONAN_PROFILE} not found")
endif()

# Identify where our conan files will be generated and the location of the Conan generated toolchain.
set(PROJECT_CONAN_DIR            "${CMAKE_SOURCE_DIR}/.conan/${PROJECT_CONAN_PROFILE}")
set(PROJECT_CONAN_TOOLCHAIN_FILE "${PROJECT_CONAN_DIR}/conan_toolchain.cmake")

# Output results
message("-- Conan detected")
message(DEBUG "       Profile: ${PROJECT_CONAN_PROFILE}")
message(DEBUG "  Profile File: ${PROJECT_CONAN_PROFILE_FILE}")
message(DEBUG "        Recipe: ${PROJECT_CONAN_RECIPE_FILE}")
message(DEBUG "     Toolchain: ${PROJECT_CONAN_TOOLCHAIN_FILE}")

# Monitor the conan recipe and profile files for change. If these files change, CMake will automatically
# regenerate the cache.
set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${PROJECT_CONAN_RECIPE_FILE} ${PROJECT_CONAN_PROFILE_FILE})

# If the toolchain file doesn't exist, the recipe is newer, or the profile file is newer, re-run the
# conan package manager to install our packages and generate the conan files.
if(NOT EXISTS "${PROJECT_CONAN_TOOLCHAIN_FILE}"
    OR "${PROJECT_CONAN_RECIPE_FILE}" IS_NEWER_THAN "${PROJECT_CONAN_TOOLCHAIN_FILE}"
    OR "${PROJECT_CONAN_PROFILE_FILE}" IS_NEWER_THAN "${PROJECT_CONAN_TOOLCHAIN_FILE}")
    file(MAKE_DIRECTORY "${PROJECT_CONAN_DIR}")

    # Copy the recipe file to the conan directory so that conan doesn't make
    # a CMakeUserPresets file in our source directory
    file(COPY ${PROJECT_CONAN_RECIPE_FILE} DESTINATION ${PROJECT_CONAN_DIR})

    # Run conan
    execute_process(COMMAND conan install . --profile=${PROJECT_CONAN_PROFILE_FILE} --build=missing
        WORKING_DIRECTORY "${PROJECT_CONAN_DIR}")
    
    # TODO: Check execute_process return for failure
endif()

# Include the generated conan toolchain
include(${PROJECT_CONAN_TOOLCHAIN_FILE})
