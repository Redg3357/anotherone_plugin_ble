#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "simpledbus::simpledbus" for configuration ""
set_property(TARGET simpledbus::simpledbus APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(simpledbus::simpledbus PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libsimpledbus.so.0.8.0"
  IMPORTED_SONAME_NOCONFIG "libsimpledbus.so.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS simpledbus::simpledbus )
list(APPEND _IMPORT_CHECK_FILES_FOR_simpledbus::simpledbus "${_IMPORT_PREFIX}/lib/libsimpledbus.so.0.8.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
