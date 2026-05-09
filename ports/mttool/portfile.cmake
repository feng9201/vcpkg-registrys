vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/feng9201/mttool
    REF 710070dad8d25ecb28fcdecf317f15d25f24c05a
    SHA512 0
)

# eventpp 通过 CMake option 控制
set(ENABLE_EVENTPP OFF)
if("eventpp" IN_LIST FEATURES)
    set(ENABLE_EVENTPP ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMT_TOOL_ENABLE_EVENTPP=${ENABLE_EVENTPP}
)

vcpkg_cmake_install()

# 安装版权文件
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")