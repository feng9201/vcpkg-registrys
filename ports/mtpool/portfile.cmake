vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/feng9201/mtPool
    REF 4530dd7ee7b711e2cc364c1871c1aa511e870a6e
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        delayed MTPOOL_ENABLE_DELAYED
)

if("shared" IN_LIST FEATURES)
    set(MTPOOL_BUILD_SHARED ON)
    set(VCPKG_LIBRARY_LINKAGE dynamic)
elseif(VCPKG_LIBRARY_LINKAGE STREQUAL "dynamic")
    set(MTPOOL_BUILD_SHARED ON)
else()
    set(MTPOOL_BUILD_SHARED OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    NO_CHARSET_FLAG
    OPTIONS
        ${FEATURE_OPTIONS}
        -DMTPOOL_BUILD_SHARED=${MTPOOL_BUILD_SHARED}
        -DMTPOOL_BUILD_DEMO=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(PACKAGE_NAME mtPool CONFIG_PATH lib/cmake/mtPool)
vcpkg_copy_pdbs()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
configure_file("${CMAKE_CURRENT_LIST_DIR}/usage" "${CURRENT_PACKAGES_DIR}/share/${PORT}/usage" COPYONLY)
