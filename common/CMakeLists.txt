set(TARGET_NAME common)

include(HungarianAlgorithm.cmake)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
        *.cpp *.h *.qrc
        )

add_library(${TARGET_NAME} ${SOURCES})

configure_file (
    "src/version.h.in"
    "include/version.h"
)

ExternalProject_Get_Property(HungarianAlgorithm SOURCE_DIR)
target_include_directories(${TARGET_NAME} PUBLIC
        src
        "${PROJECT_BINARY_DIR}/${TARGET_NAME}/include"
        "${SOURCE_DIR}"
        )

target_precompile_headers(${TARGET_NAME} PRIVATE
        src/stdafx.h
        )

target_link_libraries(${TARGET_NAME} PUBLIC
        QtSuperMacros
        hungarian
        QtJsonSchema
        Qt6::Core
        Qt6::Gui
        Qt6::Widgets
        Qt6::Network
        Qt6::Qml
        Qt6::QuickWidgets
        Qt6::QuickControls2
        )
