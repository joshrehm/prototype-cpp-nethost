include(Utilities)

opt(PROJECT_OUTPUT_PATH STRING
    "${CMAKE_SOURCE_DIR}/.bin" 
    "Default output path for compiled binaries.")

opt(WARNINGS_AS_ERRORS BOOL ON "Treat compiler warnings as compiler errors.")
