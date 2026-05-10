vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/feng9201/mttool
    REF 8253753c3c284242869fe243f194f519e14b8418
)

set(ENABLE_EVENTPP OFF)
if("eventpp" IN_LIST FEATURES)
    set(ENABLE_EVENTPP ON)
endif()

# 仅 configure，不设置 CMAKE_INSTALL_PREFIX（避免分号问题）
vcpkg_execute_required_process(
    COMMAND "${CMAKE_COMMAND}"
        -S "${SOURCE_PATH}"
        -B "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
        -DMT_TOOL_ENABLE_EVENTPP=${ENABLE_EVENTPP}
    WORKING_DIRECTORY "${SOURCE_PATH}"
    LOGNAME configure
)

# install 时通过 --prefix 指定目标路径
vcpkg_execute_required_process(
    COMMAND "${CMAKE_COMMAND}"
        --install "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
        --prefix "${CURRENT_PACKAGES_DIR}"
    WORKING_DIRECTORY "${SOURCE_PATH}"
    LOGNAME install
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/LICENSE"
    DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
    RENAME copyright
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug")