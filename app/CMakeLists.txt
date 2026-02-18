set(TARGET_NAME labcompass)

include(FetchContent)
FetchContent_Declare(
  QHotkey
  GIT_REPOSITORY git@github.com:Skycoder42/QHotkey.git
)
FetchContent_MakeAvailable(QHotkey)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
        *.cpp *.h *.qrc
        )

add_executable(${TARGET_NAME} WIN32 ${SOURCES})

target_include_directories(${TARGET_NAME} PRIVATE
        src
        )

target_precompile_headers(${TARGET_NAME} PRIVATE
        src/stdafx.h
        )

target_link_libraries(${TARGET_NAME} PRIVATE
        common
        qhotkey
        )

set_target_properties(${TARGET_NAME} PROPERTIES
    WIN32_EXECUTABLE ON
    MACOSX_BUNDLE ON
)
