include(vcpkg_common_functions)

vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "git://git.codesynthesis.com/odb/libodb-mysql.git"
    REF fa51cc270fe6696a0be96e372dd0c00921f1c8b3
    SHA512 84c5f57a146a238911b6de5d568acacd85712ab9250715b902c33146f67ab13f86720f7d38ea103a2a8556816373e1e1f814d2ddaf4c46664a9744c6cd7f82cc
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/adapter_mysql_8.0.patch
)

file(COPY
  ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt
  ${CMAKE_CURRENT_LIST_DIR}/config.unix.h.in
  DESTINATION ${SOURCE_PATH})

set(MYSQL_INCLUDE_DIR "${CURRENT_INSTALLED_DIR}/include/mysql")
set(MYSQL_LIB "${CURRENT_INSTALLED_DIR}/lib/libmysql.lib")
set(MYSQL_LIB_DEBUG "${CURRENT_INSTALLED_DIR}/debug/lib/libmysql.lib")
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DMYSQL_INCLUDE_DIR=${MYSQL_INCLUDE_DIR}
    OPTIONS_RELEASE
        -DMYSQL_LIB=${MYSQL_LIB}
    OPTIONS_DEBUG
        -DLIBODB_INSTALL_HEADERS=OFF
        -DMYSQL_LIB=${MYSQL_LIB_DEBUG}
)

vcpkg_install_cmake()

file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_mysqlConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_mysqlConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)