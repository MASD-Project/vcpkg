include(vcpkg_common_functions)
include(CMakePackageConfigHelpers)

# 2.5.0-b.15
vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL "https://git.codesynthesis.com/odb/libodb.git"
    REF 8646a4260c32d180b834c4c2fe2218e81fd2f279
    SHA512 c1884c89c76bbcb9cfb368855ef0f86ae6596791a3610e3ba358a0789f6e7ecd1c81d0bb4983e5bdbb03235739a514e1cc0f9c769ebe18c03fce2dd348ad784e
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
file(READ ${CURRENT_PACKAGES_DIR}/debug/share/odb/odb_libodbConfig-debug.cmake LIBODB_DEBUG_TARGETS)
string(REPLACE "\${_IMPORT_PREFIX}" "\${_IMPORT_PREFIX}/debug" LIBODB_DEBUG_TARGETS "${LIBODB_DEBUG_TARGETS}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/odb/odb_libodbConfig-debug.cmake "${LIBODB_DEBUG_TARGETS}")
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/odbConfig.cmake DESTINATION ${CURRENT_PACKAGES_DIR}/share/odb)
write_basic_package_version_file(${CURRENT_PACKAGES_DIR}/share/odb/odbConfigVersion.cmake
    VERSION 2.5.0
    COMPATIBILITY SameMajorVersion
)

set(LIBODB_HEADER_PATH ${CURRENT_PACKAGES_DIR}/include/odb/details/export.hxx)
file(READ ${LIBODB_HEADER_PATH} LIBODB_HEADER)
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    string(REPLACE "#ifdef LIBODB_STATIC_LIB" "#if 1" LIBODB_HEADER ${LIBODB_HEADER})
else()
    string(REPLACE "#ifdef LIBODB_STATIC_LIB" "#if 0" LIBODB_HEADER ${LIBODB_HEADER})
endif()
file(WRITE ${LIBODB_HEADER_PATH} "${LIBODB_HEADER}")

vcpkg_copy_pdbs()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
