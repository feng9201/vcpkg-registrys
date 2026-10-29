vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/feng9201/mttool
    REF ff72b37e26ccbb76671d18937d618082162fe70b
)

set(ENABLE_EVENTPP OFF)
if("eventpp" IN_LIST FEATURES)
    set(ENABLE_EVENTPP ON)
endif()

set(ENABLE_SPSC OFF)
if("spsc" IN_LIST FEATURES)
    set(ENABLE_SPSC ON)
endif()

set(ENABLE_MPMC OFF)
if("mpmc" IN_LIST FEATURES)
    set(ENABLE_MPMC ON)
endif()

set(ENABLE_MGENUM OFF)
if("magicenum" IN_LIST FEATURES)
    set(ENABLE_MGENUM ON)
endif()

set(ENABLE_OBS OFF)
if("obs" IN_LIST FEATURES)
    set(ENABLE_OBS ON)
endif()

# 清除 CMake 旧缓存，防止源路径变更后 cache 不匹配
file(REMOVE "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/CMakeCache.txt")
file(REMOVE_RECURSE "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/CMakeFiles")

# 仅 configure
vcpkg_execute_required_process(
    COMMAND "${CMAKE_COMMAND}"
        -S "${SOURCE_PATH}"
        -B "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
        -DMT_TOOL_ENABLE_EVENTPP=${ENABLE_EVENTPP}
        -DMT_TOOL_ENABLE_SPSC=${ENABLE_SPSC}
        -DMT_TOOL_ENABLE_MPMC=${ENABLE_MPMC}
        -DMT_TOOL_ENABLE_MGENUM=${ENABLE_MGENUM}
        -DMT_TOOL_ENABLE_OBS=${ENABLE_OBS}
    WORKING_DIRECTORY "${SOURCE_PATH}"
    LOGNAME configure
)

# install
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