include(StandardOptions)

opt(PROTOTYPE_CPP_NETHOST_OUTPUT_PATH STRING
    "${PROJECT_OUTPUT_PATH}" 
    "Default output path for compiled prototype-cpp-nethost binaries.")

opt(PROTOTYPE_CPP_NETHOST_ENABLE_TESTS BOOL OFF
    "Build prototype-cpp-nethost unit tests")

opt(PROTOTYPE_CPP_NETHOST_RUN_TESTS_ON_BUILD BOOL OFF
    "Run prototype-cpp-nethost unit tests on build")

opt(PROTOTYPE_CPP_NETHOST_ENABLE_CPPCHECK BOOL ON
    "Enable CppCheck static code analysis for prototype-cpp-nethost")

opt(PROTOTYPE_CPP_NETHOST_WARNINGS_AS_ERRORS BOOL ${WARNINGS_AS_ERRORS}
    "Treat prototype-cpp-nethost project compiler warnings as compiler errors")
