# CMAKE_SYSTEM_PROCESSOR - CPU architecture name (armv7l, aarch64, x86_64)
# CMAKE_BUILD_TYPE       - Build mode (debug, profile, release)
# PSDK_VERSION           - Build psdk exact version
# PSDK_MAJOR             - Build psdk major version

cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME anotherone_ble)
set(PLUGIN_NAME  anotherone_ble_platform_plugin)

project(${PROJECT_NAME} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wno-psabi")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

find_package(PkgConfig REQUIRED)

pkg_check_modules(FlutterEmbedder REQUIRED IMPORTED_TARGET flutter-embedder)
pkg_check_modules(DBus1 REQUIRED IMPORTED_TARGET dbus-1)

file(GLOB THIRD_PARTY_SOURCE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/SimpleBLE/simpledbus/src/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/SimpleBLE/simpledbus/src/**/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/SimpleBLE/simplebluez/src/*.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/SimpleBLE/simplebluez/src/**/*.cpp
)

# Suppress all warnings from third-party projects
set_source_files_properties(${THIRD_PARTY_SOURCE_FILES} PROPERTIES COMPILE_FLAGS "-w")

add_library(${PLUGIN_NAME} SHARED ${THIRD_PARTY_SOURCE_FILES} anotherone_ble_plugin.cpp)

set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::FlutterEmbedder)
target_link_libraries(${PLUGIN_NAME} PUBLIC PkgConfig::DBus1)

target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/fmt/include)
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/SimpleBLE/simpledbus/include)
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/3rdparty/SimpleBLE/simplebluez/include)

target_compile_definitions(${PLUGIN_NAME} PRIVATE PLUGIN_IMPL FMT_HEADER_ONLY)
