# Options specific to the PROTOTYPE_CPP_NETHOST project

include(StandardOptions)

opt(PROTOTYPE_CPP_NETHOST_OUTPUT_PATH STRING
    "${PROJECT_OUTPUT_PATH}" 
    "Default output path for compiled prototype-cpp-nethost binaries.")

opt(PROTOTYPE_CPP_NETHOST_WARNINGS_AS_ERRORS BOOL ${WARNINGS_AS_ERRORS}
    "Treat prototype-cpp-nethost project compiler warnings as compiler errors")
