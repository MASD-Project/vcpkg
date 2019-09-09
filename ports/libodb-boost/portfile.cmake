include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://git.codesynthesis.com/odb/libodb-boost.git"
    REF ddb7e77afd87c9733bf776f9d2af973f4c84b572
    SHA512 a52e2e0f8f7d170e9ee0374ad7a20240414b9914a2eb4a2036cfe560901034dd47a8fd77feacf62b92b9ebfa368d7e6b588eab60360b9e219665d01cd78478bc
)

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
  ${CMAKE_CURRENT_LIST_DIR}/config.unix.h.in
  DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS_DEBUG
        -DLIBODB_INSTALL_HEADERS=OFF
)

vcpkg_install_cmake()

file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_boostConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_boostConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libodb-boost)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libodb-boost/LICENSE ${CURRENT_PACKAGES_DIR}/share/libodb-boost/copyright)
vcpkg_copy_pdbs()
