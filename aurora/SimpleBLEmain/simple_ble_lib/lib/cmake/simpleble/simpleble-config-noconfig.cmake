#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "simpleble::simpleble" for configuration ""
set_property(TARGET simpleble::simpleble APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(simpleble::simpleble PROPERTIES
  IMPORTED_LINK_DEPENDENT_LIBRARIES_NOCONFIG "dbus-1"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libsimpleble.so.0.8.0"
  IMPORTED_SONAME_NOCONFIG "libsimpleble.so.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS simpleble::simpleble )
list(APPEND _IMPORT_CHECK_FILES_FOR_simpleble::simpleble "${_IMPORT_PREFIX}/lib/libsimpleble.so.0.8.0" )

# Import target "simpleble::simpleble-c" for configuration ""
set_property(TARGET simpleble::simpleble-c APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(simpleble::simpleble-c PROPERTIES
  IMPORTED_LINK_DEPENDENT_LIBRARIES_NOCONFIG "simpleble::simpleble"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libsimpleble-c.so.0.8.0"
  IMPORTED_SONAME_NOCONFIG "libsimpleble-c.so.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS simpleble::simpleble-c )
list(APPEND _IMPORT_CHECK_FILES_FOR_simpleble::simpleble-c "${_IMPORT_PREFIX}/lib/libsimpleble-c.so.0.8.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
