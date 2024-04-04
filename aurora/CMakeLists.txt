# CMAKE_SYSTEM_PROCESSOR - CPU architecture name (armv7l, aarch64, x86_64)
# CMAKE_BUILD_TYPE       - Build mode (debug, profile, release)
# PSDK_VERSION           - Build psdk exact version
# PSDK_MAJOR             - Build psdk major version

cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME anotherone_ble)
set(PLUGIN_NAME  anotherone_ble_platform_plugin)
set(PKG_CONFIG_USE_CMAKE_PREFIX_PATH ON)
set(ENV{CMAKE_PREFIX_PATH} "/home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs")
#set(ENV{CMAKE_PREFIX_PATH} "$ENV{CMAKE_PREFIX_PATH}:/home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_ble_lib/lib")
#list(APPEND CMAKE_PREFIX_PATH "/home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_ble_lib/lib")
#set(ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:/home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_ble_lib/lib/pkgconfig")
project(${PROJECT_NAME} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wno-psabi")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

find_package(PkgConfig REQUIRED)
find_package(DBus1 REQUIRED)


pkg_check_modules(FlutterEmbedder REQUIRED IMPORTED_TARGET flutter-embedder)
pkg_check_modules(SimpleBle REQUIRED IMPORTED_TARGET simpleble)
pkg_check_modules(SimpleBluez REQUIRED IMPORTED_TARGET simplebluez)
pkg_check_modules(SimpleDBus REQUIRED IMPORTED_TARGET simpledbus)

#find_library(SimpleBle libsimpleble PATHS /home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_ble_lib/lib)
#find_library(SimpleBluez libsimplebluez PATHS /home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_bluez_lib/lib)
#find_library(SimpleDBus libsimpledbus PATHS /home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_dbus_lib/lib)


#target_link_libraries(${PROJECT_NAME} SHARED ${SimpleBle})
#target_link_libraries(${PROJECT_NAME} SHARED ${SimpleBluez})
#target_link_libraries(${PROJECT_NAME} SHARED ${SimpleDBus})

#find_package(/home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_ble_lib/lib/cmake/simpleble/simpleble REQUIRED CONFIG)
#target_link_libraries(${PROJECT_NAME} simpleble::simpleble)

#add_library(SimpleBle SHARED IMPORTED)
#set_target_properties(${SimpleBle} PROPERTIES IMPORTED_LOCATION /home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_ble_lib/lib/libsimpleble.so)
#
#add_library(SimpleBluez SHARED IMPORTED)
#set_target_properties(${SimpleBluez} PROPERTIES IMPORTED_LOCATION /home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_bluez_lib/lib/libsimplebluez.so)
#
#add_library(SimpleDBus SHARED IMPORTED)
#set_target_properties(${SimpleDBus} PROPERTIES IMPORTED_LOCATION /home/kirill/DIPLOM/FlutterProjects/anotherone_ble/aurora/libs/simple_dbus_lib/lib/libsimpledbus.so)
#
#set(SIMPLEBLUEZ_INCLUDE
#    ${CMAKE_CURRENT_SOURCE_DIR}/include
#    ${CMAKE_CURRENT_SOURCE_DIR}/include/simplebluez
#)
#
#set(SIMPLEDBUS_INCLUDE
#    ${CMAKE_CURRENT_SOURCE_DIR}/include
#    ${CMAKE_CURRENT_SOURCE_DIR}/include/simpledbus/interfaces
#    ${CMAKE_CURRENT_SOURCE_DIR}/include/simpledbus/advanced
#    ${CMAKE_CURRENT_SOURCE_DIR}/include/simpledbus/base
#    ${CMAKE_CURRENT_SOURCE_DIR}/include/simpledbus/external
#)
#
#set(SIMPLEBLUEZ_SRC
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/simplebluez
#    ${CMAKE_CURRENT_SOURCE_DIR}/src/simplebluez/interfaces
#)
#
#set(SIMPLEDBUS_SRC
#    {CMAKE_CURRENT_SOURCE_DIR}/src/simpledbus/interfaces
#    {CMAKE_CURRENT_SOURCE_DIR}/src/simpledbus/advanced
#    {CMAKE_CURRENT_SOURCE_DIR}/src/simpledbus/base
#)

## Добавление путей поиска заголовочных файлов
#include_directories(
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simpleble/include
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simpledbus/include
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simplebluez/include
#    ${CMAKE_BINARY_DIR}/SimpleBLEmain/simpleble/export # если нужно включить путь для сгенерированных заголовков
#    /usr/include/dbus-1.0/dbus # добавление пути к системным заголовкам dbus
#)
#
## Добавление путей поиска зависимостей (не обязательно в CMake)
#link_directories(
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simpleble
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simpledbus
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simplebluez
#)
#
## Добавление библиотек для линковки
#target_link_libraries(${PLUGIN_NAME}
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simpleble/libsimpleble.so
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simpleble/libsimpleble-c.so
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simpledbus/libsimpledbus.so
#    ${CMAKE_CURRENT_SOURCE_DIR}/SimpleBLEmain/simplebluez/libsimplebluez.so
#)


add_library(${PLUGIN_NAME} SHARED anotherone_ble_plugin.cpp)
#add_library(${PLUGIN_NAME} SHARED anotherone_ble_plugin.cpp ${SIMPLEBLUEZ_SRC})
#add_library(${PLUGIN_NAME} SHARED anotherone_ble_plugin.cpp ${SIMPLEBDBUS_SRC})
set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::FlutterEmbedder)

target_link_libraries(${PLUGIN_NAME} PUBLIC PkgConfig::SimpleBle)
target_link_libraries(${PLUGIN_NAME} PUBLIC PkgConfig::SimpleBluez)
target_link_libraries(${PLUGIN_NAME} PUBLIC PkgConfig::SimpleDBus)

target_link_libraries(${PLUGIN_NAME} PRIVATE ${DBus1_LIBRARIES})

target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include/${PROJECT_NAME})
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_compile_definitions(${PLUGIN_NAME} PRIVATE PLUGIN_IMPL)
