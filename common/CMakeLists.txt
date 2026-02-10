set(TARGET_NAME common)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
        *.cpp *.h *.qrc
        )

add_library(${TARGET_NAME} ${SOURCES})

target_include_directories(${TARGET_NAME} PUBLIC
        src
        )

target_precompile_headers(${TARGET_NAME} PRIVATE
        src/stdafx.h
        )

target_link_libraries(${TARGET_NAME} PUBLIC
        QtSuperMacros
        HungarianAlgorithm
        QtJsonSchema
        Qt6::Core
        Qt6::Gui
        Qt6::Widgets
        Qt6::Network
        Qt6::Qml
        Qt6::QuickWidgets
        Qt6::QuickControls2
        )
