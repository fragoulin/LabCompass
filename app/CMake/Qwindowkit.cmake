include(FetchContent)

set(TARGET_WINDOW_KIT WindowKit)
set(QWINDOWKIT_BUILD_QUICK
    ON
    CACHE INTERNAL BOOL "")
set(QWINDOWKIT_BUILD_STATIC
    ${BUILD_SHARED_LIBS}
    CACHE INTERNAL BOOL "")

FetchContent_Declare(
  ${TARGET_WINDOW_KIT}
  GIT_REPOSITORY https://github.com/stdware/qwindowkit
  GIT_TAG 2072958b04820e9e7629f6c40068dee0ce0e9915)
FetchContent_MakeAvailable(${TARGET_WINDOW_KIT})
