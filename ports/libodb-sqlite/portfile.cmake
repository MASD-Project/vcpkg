include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://git.codesynthesis.com/odb/libodb-sqlite.git"
    REF 15df3e3e21be5fbf461edac34355d59c1765d34f
    SHA512 05855ca4feff412ec867dd3dc1f9ef0e5e4ea580e1116a50b073d220f8e66e096bea853a6218a4ae0cbec08bdc6299aee1089cf91ca0986ff324033d2579c067
)

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
  ${CMAKE_CURRENT_LIST_DIR}/config.unix.h.in
  DESTINATION ${SOURCE_PATH})

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/options.ixx
  ${CMAKE_CURRENT_LIST_DIR}/options.hxx
  ${CMAKE_CURRENT_LIST_DIR}/options.cxx
  DESTINATION ${SOURCE_PATH}/odb/sqlite/details)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS_DEBUG
        -DLIBODB_INSTALL_HEADERS=OFF
)

vcpkg_install_cmake()

file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_sqliteConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_sqliteConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)