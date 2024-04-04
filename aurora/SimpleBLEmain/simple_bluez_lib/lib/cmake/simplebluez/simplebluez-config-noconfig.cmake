#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "simplebluez::simplebluez" for configuration ""
set_property(TARGET simplebluez::simplebluez APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(simplebluez::simplebluez PROPERTIES
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libsimplebluez.so.0.8.0"
  IMPORTED_SONAME_NOCONFIG "libsimplebluez.so.0"
  )

list(APPEND _IMPORT_CHECK_TARGETS simplebluez::simplebluez )
list(APPEND _IMPORT_CHECK_FILES_FOR_simplebluez::simplebluez "${_IMPORT_PREFIX}/lib/libsimplebluez.so.0.8.0" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
