include(FetchContent)

set(TARGET_JSON_SCHEMA_VALIDATOR JsonSchemaValidator)

FetchContent_Declare(${TARGET_JSON_SCHEMA_VALIDATOR}
  GIT_REPOSITORY    git@github.com:pboettch/json-schema-validator.git
  GIT_TAG           c780404a84dd9ba978ba26bc58d17cb43fa7bc80
)
FetchContent_MakeAvailable(${TARGET_JSON_SCHEMA_VALIDATOR})
