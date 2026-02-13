cmake_minimum_required(VERSION 3.13)

project(LabCompass)

set(CMAKE_AUTOMOC TRUE)
set(CMAKE_AUTOUIC TRUE)
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

add_subdirectory(vendor/QtSuperMacros)
add_subdirectory(vendor/HungarianAlgorithm)
add_subdirectory(vendor/QtJsonSchema)
add_subdirectory(vendor/QHotkey)

add_subdirectory(common)

add_subdirectory(app labcompass)
add_subdirectory(logsimulator)
add_subdirectory(tests)
