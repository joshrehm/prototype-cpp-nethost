if(Asio_FOUND)
    target_compile_definitions(${target} PRIVATE
        ASIO_NO_DEPRECATED           # Disable deprecated ASIO APIs
        ASIO_NO_DYNAMIC_BUFFER_V1    # Disable legacy bufferv1 APIs
    )
endif()

if(Boost_FOUND)
    target_compile_definitions(${target} PRIVATE
        BOOST_ASIO_NO_DEPRECATED           # Disable deprecated ASIO APIs
        BOOST_ASIO_NO_DYNAMIC_BUFFER_V1    # Disable legacy bufferv1 APIs

        BOOST_FILESYSTEM_NO_DEPRECATED     # Disable deprecated filesystem APIs
        BOOST_SYSTEM_NO_DEPRECATED         # Disable deprecated sytem APIs
    )
endif()

if(nlohmann_json_FOUND)
    target_compile_definitions(${target} PRIVATE
        JSON_DIAGNOSTICS=1                 # Enable better JSON Diagnostics
    )
endif()
