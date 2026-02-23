set(TARGET_NAME labcompass)

qt_add_translations(${TARGET_NAME}
    TS_FILE_DIR translations
    RESOURCE_PREFIX translations
    LUPDATE_OPTIONS -no-obsolete
)
