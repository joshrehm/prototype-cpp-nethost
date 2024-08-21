# Preprocessor definitions for Windows platforms
#
# DO NOT put MSVC specific definitions in this file!!! Use the
# 'Msvc/DefaultCompilerDefinitions.cmake' file for that.
#
target_compile_definitions(${target} PRIVATE
    NOMINMAX               # Disable creation of min/max items in Windows
    STRICT                 # Enable Strict Type Checking in Windows Types
    UMDF_USING_NTSTATUS    # Disable defining some ntstatus values (include ntstatus.h instead)
    WIN32_LEAN_AND_MEAN    # Cut out a bunch of Windows stuff

    # Use wide character versions of windows API
    _UNICODE
    UNICODE

    # Windows 10 API
    _WIN32_WINNT=0x0A00
    WINVER=0x0A00
)
