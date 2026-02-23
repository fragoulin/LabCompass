include(FetchContent)

set(TARGET_QT_SUPER_MACROS QtSuperMacros)

FetchContent_Declare(${TARGET_QT_SUPER_MACROS}
  GIT_REPOSITORY    git@github.com:fragoulin/QtSuperMacros.git
)
FetchContent_MakeAvailable(${TARGET_QT_SUPER_MACROS})
