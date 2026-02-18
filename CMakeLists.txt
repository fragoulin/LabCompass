cmake_minimum_required(VERSION 3.13...3.31)

project(LabCompass VERSION 1.5.0
                   DESCRIPTION "An overlay aiming to improve the quality of life when running labyrinths in Path of Exile."
                   HOMEPAGE_URL https://github.com/fragoulin/LabCompass
                   LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTORCC TRUE)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

find_package(Qt6 REQUIRED
        Core
        Gui
        Widgets
        Network
        Qml
        QuickWidgets
        QuickControls2
        Test
        )

qt_standard_project_setup(REQUIRES 6.8)

add_subdirectory(vendor/QtSuperMacros)
add_subdirectory(vendor/HungarianAlgorithm)
add_subdirectory(vendor/QtJsonSchema)

add_subdirectory(common)

add_subdirectory(app labcompass)
add_subdirectory(logsimulator)
add_subdirectory(tests)

### Require out-of-source builds
file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

set(default_build_type "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
      STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()
