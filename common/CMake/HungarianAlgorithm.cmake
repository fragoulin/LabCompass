include(FetchContent)

set(TARGET_HUNGARIAN HungarianAlgorithm)

FetchContent_Declare(
  ${TARGET_HUNGARIAN}
  GIT_REPOSITORY https://github.com/mcximing/hungarian-algorithm-cpp.git)
FetchContent_MakeAvailable(${TARGET_HUNGARIAN})

set(SOURCE_DIR_HUNGARIAN ${FETCHCONTENT_BASE_DIR}/hungarianalgorithm-src)

add_library(hungarian ${SOURCE_DIR_HUNGARIAN}/Hungarian.cpp
                      ${SOURCE_DIR_HUNGARIAN}/Hungarian.h)
