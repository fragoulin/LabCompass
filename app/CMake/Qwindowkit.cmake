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
  GIT_TAG 5626b3ae5f22508d77361495f589abedb39c2ee4)
FetchContent_MakeAvailable(${TARGET_WINDOW_KIT})
