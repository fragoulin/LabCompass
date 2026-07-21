set(TARGET_NAME labcompass)

qt_add_translations(
  ${TARGET_NAME}
  TS_FILE_DIR
  translations
  RESOURCE_PREFIX
  translations
  LUPDATE_OPTIONS
  -no-obsolete
  LRELEASE_OPTIONS
  -idbased)

include(CMake/QHotkey.cmake)
include(CMake/Qwindowkit.cmake)

file(
  GLOB_RECURSE SOURCES CONFIGURE_DEPENDS
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
  *.cpp *.h *.qrc)
file(
  GLOB_RECURSE CPP_SOURCES CONFIGURE_DEPENDS
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
  *.cpp *.h)
file(
  GLOB_RECURSE QML_SOURCES CONFIGURE_DEPENDS
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
  *.qml *.js)
file(
  GLOB_RECURSE IMAGES_RESOURCES CONFIGURE_DEPENDS
  RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
  *.svg)

if(WIN32)
  # ! [appicon_windows]
  configure_file("assets/icons/LabCompass.ico" "LabCompass.ico" COPYONLY)
  configure_file("assets/rc/labcompass.rc" "labcompass.rc")
  set(app_icon_resource_windows "${CMAKE_CURRENT_BINARY_DIR}/labcompass.rc")
  qt_add_executable(${TARGET_NAME} WIN32 ${SOURCES}
                    ${app_icon_resource_windows})
  # ! [appicon_windows]
else()
  qt_add_executable(${TARGET_NAME} WIN32 ${SOURCES})
endif()

set_source_files_properties(qml/Global.qml PROPERTIES QT_QML_SINGLETON_TYPE
                                                      TRUE)

# Set alias for qml files stored in qml directory
# https://doc.qt.io/qt-6.8/qt-add-qml-module.html#caching-compiled-qml-sources
foreach(QML_SOURCE ${QML_SOURCES})
  string(LENGTH ${QML_SOURCE} QML_SOURCE_LENGTH)
  string(SUBSTRING ${QML_SOURCE} 4 ${QML_SOURCE_LENGTH}
                   QML_SOURCE_WITHOUT_QML_DIR)
  set_source_files_properties(
    ${QML_SOURCE} PROPERTIES QT_RESOURCE_ALIAS ${QML_SOURCE_WITHOUT_QML_DIR})
endforeach()

target_include_directories(${TARGET_NAME} PRIVATE src)

target_precompile_headers(${TARGET_NAME} PRIVATE src/stdafx.h)

target_link_libraries(${TARGET_NAME} PRIVATE common qhotkey)

target_link_libraries(${TARGET_NAME} PRIVATE
  Qt6::Core
  Qt6::Gui
  Qt6::Quick
  Qt6::Qml
  QWindowKit::Quick)

set_target_properties(
  ${TARGET_NAME} PROPERTIES MACOSX_BUNDLE ON QT_QMLCACHEGEN_ARGUMENTS
                                             "--only-bytecode")

qt_add_qml_module(
  ${TARGET_NAME}
  URI
  labcompass
  SOURCES
  ${CPP_SOURCES}
  QML_FILES
  ${QML_SOURCES}
  RESOURCES
  ${IMAGES_RESOURCES})
