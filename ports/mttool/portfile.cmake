vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/feng9201/mttool
    REF 710070dad8d25ecb28fcdecf317f15d25f24c05a
    SHA512 0
)

set(ENABLE_EVENTPP OFF)
if("eventpp" IN_LIST FEATURES)
    set(ENABLE_EVENTPP ON)
endif()

# 手动运行 cmake configure + install（vcpkg 内置函数，无需额外 include）
vcpkg_execute_required_process(
    COMMAND "${CMAKE_COMMAND}"
        -S "${SOURCE_PATH}"
        -B "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
        -DMT_TOOL_ENABLE_EVENTPP=${ENABLE_EVENTPP}
        -DCMAKE_INSTALL_PREFIX="${CURRENT_PACKAGES_DIR}"
    WORKING_DIRECTORY "${SOURCE_PATH}"
    LOGNAME configure
)

vcpkg_execute_required_process(
    COMMAND "${CMAKE_COMMAND}" --install "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
    WORKING_DIRECTORY "${SOURCE_PATH}"
    LOGNAME install
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")