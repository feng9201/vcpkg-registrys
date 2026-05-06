vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

# vcpkg_from_gitlab(
#     GITLAB_URL http://git-inc.ovopark.com:6780
#     OUT_SOURCE_PATH SOURCE_PATH
#     REPO system/threadlibrary/log-cpp
#     REF "${VERSION}"
#     SHA512 0
#     HEAD_REF init
#     AUTHORIZATION_TOKEN Ng2qwPT14ZPo4HwWeJJu
# )

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/feng9201/log-cpp
    REF 7eece11b7d99810e4b3330250b2b1a628688ee7e #need to change
)

set(OPTIONS "")

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        sqlite LOGCPP_SUPPORT_SQLITE
        shared LOGCPP_BUILD_SHARED
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    NO_CHARSET_FLAG 
    OPTIONS ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(
    CONFIG_PATH lib/cmake/log-cpp
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)