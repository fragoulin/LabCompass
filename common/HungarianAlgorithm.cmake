include(ExternalProject)
find_program(MAKE_EXE NAMES gmake nmake make)

set(TARGET_HUNGARIAN HungarianAlgorithm)

ExternalProject_Add(${TARGET_HUNGARIAN}
  GIT_REPOSITORY    git@github.com:mcximing/hungarian-algorithm-cpp.git
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  SOURCE_DIR ${CMAKE_BINARY_DIR}/${TARGET_HUNGARIAN}
)

add_library(hungarian ${CMAKE_BINARY_DIR}/${TARGET_HUNGARIAN}/Hungarian.cpp ${CMAKE_BINARY_DIR}/${TARGET_HUNGARIAN}/Hungarian.h)
