include(FetchContent)

set(TARGET_WINDOW_KIT WindowKit)
set(QWINDOWKIT_BUILD_WIDGETS
    OFF
    CACHE INTERNAL BOOL "")
set(QWINDOWKIT_BUILD_QUICK
    ON
    CACHE INTERNAL BOOL "")
set(QWINDOWKIT_BUILD_STATIC
    ON
    CACHE INTERNAL BOOL "")

FetchContent_Declare(
  ${TARGET_WINDOW_KIT}
  GIT_REPOSITORY https://github.com/fragoulin/qwindowkit
  GIT_TAG main)
FetchContent_MakeAvailable(${TARGET_WINDOW_KIT})
