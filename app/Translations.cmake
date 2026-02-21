set(TARGET_NAME labcompass)

file(GLOB_RECURSE QML_SOURCES CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR} *.qml *.cpp)
qt_add_translations(${TARGET_NAME}
    SOURCES ${QML_SOURCES}
    TS_FILE_DIR i18n
    LUPDATE_OPTIONS -no-obsolete
)

qt_add_lupdate(
    SOURCE_TARGETS ${TARGET_NAME}
    TS_FILES i18n/LabCompass_fr.ts
    PLURALS_TS_FILE i18n/LabCompass_en.ts
)

qt_add_lrelease(
    TS_FILES i18n/LabCompass_fr.ts
    QM_FILES_OUTPUT_VARIABLE qm_files
)
message(STATUS "QM FILES: ${qm_files}")
message(STATUS "CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
install(FILES ${qm_files} DESTINATION "translations")
