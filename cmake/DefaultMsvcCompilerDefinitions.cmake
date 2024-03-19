target_compile_definitions(${target} PRIVATE
    # Disable CRT Secure Warnings as MS wants us to use non-standard functions
    _CRT_SECURE_NO_WARNINGS

    # Disable warnings about deprecated checked iterators in 3rd party headers (We should remove this once those libraries are fixed)
    _SILENCE_ALL_MS_EXT_DEPRECATION_WARNINGS
)
