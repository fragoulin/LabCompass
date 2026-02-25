set(TARGET_NAME tests)

set_directory_properties(PROPERTIES QT_EXCLUDE_FROM_TRANSLATION ON)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS *.cpp *.h)

add_executable(${TARGET_NAME} WIN32 ${SOURCES})

target_include_directories(${TARGET_NAME} PRIVATE src)

target_link_libraries(${TARGET_NAME} PRIVATE common Qt6::QuickControls2
                                             Qt6::Widgets Qt6::Test)

add_custom_command(
  TARGET ${TARGET_NAME}
  POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/data/
          $<TARGET_FILE_DIR:${TARGET_NAME}>/data/)

set_target_properties(
  ${TARGET_NAME}
  PROPERTIES WIN32_EXECUTABLE ON
             MACOSX_BUNDLE ON
             QT_QMLCACHEGEN_ARGUMENTS "--only-bytecode")
