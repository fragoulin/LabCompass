include(FetchContent)

set(TARGET_JSON_SCHEMA_VALIDATOR JsonSchemaValidator)

FetchContent_Declare(
  ${TARGET_JSON_SCHEMA_VALIDATOR}
  GIT_REPOSITORY https://github.com/pboettch/json-schema-validator.git
  GIT_TAG 9abddfa905bb4889cc4ae55f87adcaa71dd3bc23)
FetchContent_MakeAvailable(${TARGET_JSON_SCHEMA_VALIDATOR})
