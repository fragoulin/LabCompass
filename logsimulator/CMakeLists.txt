set(TARGET_NAME logsimulator)

set_directory_properties(PROPERTIES QT_EXCLUDE_FROM_TRANSLATION ON)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp *.h *.ui)

add_executable(${TARGET_NAME} WIN32 ${SOURCES})

target_include_directories(${TARGET_NAME} PRIVATE src)

target_precompile_headers(${TARGET_NAME} PRIVATE src/stdafx.h)

target_link_libraries(${TARGET_NAME} PRIVATE common Qt6::Widgets
                                             Qt6::QuickControls2)

set_target_properties(
  ${TARGET_NAME}
  PROPERTIES WIN32_EXECUTABLE ON
             MACOSX_BUNDLE ON
             QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")
