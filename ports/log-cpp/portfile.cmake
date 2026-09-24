vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/feng9201/log-cpp
    REF b8ae32d3db0b8a46faba6dc9ac6d92a72351b58a
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        sqlite LOGCPP_SUPPORT_SQLITE
        qt     LOGCPP_ENABLE_QT
)

if("shared" IN_LIST FEATURES)
    set(LOGCPP_BUILD_SHARED ON)
    set(VCPKG_LIBRARY_LINKAGE dynamic)
elseif(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(LOGCPP_BUILD_SHARED ON)
else()
    set(LOGCPP_BUILD_SHARED OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    NO_CHARSET_FLAG
    OPTIONS
        ${FEATURE_OPTIONS}
        -DLOGCPP_BUILD_SHARED=${LOGCPP_BUILD_SHARED}
        -DLOGCPP_BUILD_TESTS=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/log-cpp)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)
