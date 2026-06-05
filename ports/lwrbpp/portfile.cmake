vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/feng9201/lwrbpp
    REF cfb13e4350dde68057bdf73f9f1cf82aa96d7088
)

set(LWRP_BUILD_DEMO OFF)
if("use-demo" IN_LIST FEATURES)
    set(LWRP_BUILD_DEMO ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DLWRP_BUILD_DEMO=${LWRP_BUILD_DEMO}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME lwrbpp)

file(INSTALL "${SOURCE_PATH}/LICENSE"
     DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
     RENAME copyright)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")