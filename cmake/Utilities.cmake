# General utilities

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
