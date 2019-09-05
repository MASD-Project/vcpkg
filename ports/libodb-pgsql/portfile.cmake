include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://git.codesynthesis.com/odb/libodb-pgsql.git"
    REF v2.5.0-b.15
    SHA512 e68610f21112a45a9f10cfd33f92b7d163cec7281f789df7d19af31e907d35d48dea452c1d4db1210190125fd9509f8f9f6194a89beb04e7217c9c38b37ac3ee
)

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
  ${CMAKE_CURRENT_LIST_DIR}/config.unix.h.in
  DESTINATION ${SOURCE_PATH})

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/options.ixx
  ${CMAKE_CURRENT_LIST_DIR}/options.hxx
  ${CMAKE_CURRENT_LIST_DIR}/options.cxx
  DESTINATION ${SOURCE_PATH}/odb/pgsql/details)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS_DEBUG
        -DLIBODB_INSTALL_HEADERS=OFF
)

vcpkg_install_cmake()

file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_pgsqlConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_pgsqlConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/libodb-pgsql)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libodb-pgsql/LICENSE ${CURRENT_PACKAGES_DIR}/share/libodb-pgsql/copyright)
vcpkg_copy_pdbs()
