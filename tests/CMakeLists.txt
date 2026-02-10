set(TARGET_NAME tests)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
        *.cpp *.h
        )

add_executable(${TARGET_NAME} WIN32 ${SOURCES})

target_include_directories(${TARGET_NAME} PRIVATE
        src
        )

target_link_libraries(${TARGET_NAME} PUBLIC
        common
        Qt6::Core
        Qt6::Gui
        Qt6::Widgets
        Qt6::Test
        )

add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${CMAKE_CURRENT_SOURCE_DIR}/data/ $<TARGET_FILE_DIR:${TARGET_NAME}>/data/)
