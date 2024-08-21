target_link_options(${target} PRIVATE
    /DEBUG                # Generate debug information (PDB) file
    /DYNAMICBASE          # Use address space layout randomization
    /IGNORE:4099          # Ignore warning 4099 (PDB 'x' was not found; Linking as if no pdb information available)
)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    target_link_options(${target} PRIVATE
        /OPT:NOICF        # Disable Identical COMDAT folding (keep duplicate data)
        /OPT:NOREF        # Keep unreferenced functions and data
    )
endif()

if(CMAKE_BUILD_TYPE STREQUAL "Release" OR CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
    target_link_options(${target} PRIVATE
        /INCREMENTAL:NO   # Always perform a full link
        /LTCG             # Enable link-time code generation
        /OPT:ICF          # Enable Identical COMDAT folding (remove duplicate data)
        /OPT:REF          # Discard unreferenced functions and data
    )
endif()
