macro(build_hdf5 install_prefix staging_prefix zlib_include_dir zlib_library)

IF(CMAKE_BUILD_TYPE STREQUAL Release)
  SET(EXT_C_FLAGS   "${CMAKE_C_FLAGS}   ${CMAKE_C_FLAGS_RELEASE}")
  SET(EXT_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}")
ELSE()
  SET(EXT_C_FLAGS   "${CMAKE_C_FLAGS}    ${CMAKE_C_FLAGS_DEBUG}")
  SET(EXT_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")
ENDIF()

SET(EXT_C_COMPILER ${CMAKE_C_COMPILER})
SET(EXT_CXX_COMPILER ${CMAKE_CXX_COMPILER})

get_filename_component(zlib_library_dir ${zlib_library} PATH)

ExternalProject_Add(HDF5
  SOURCE_DIR HDF5
  URL "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.18/src/hdf5-1.8.18.tar.bz2"
  URL_MD5 "29117bf488887f89888f9304c8ebea0b"
  BUILD_IN_SOURCE 1
  INSTALL_DIR     "${CMAKE_BINARY_DIR}/external"
  BUILD_COMMAND   $(MAKE) 
  INSTALL_COMMAND $(MAKE) DESTDIR=${CMAKE_BINARY_DIR}/external install 
  CONFIGURE_COMMAND  ./configure --prefix=${install_prefix} --libdir=${install_prefix}/lib${LIB_SUFFIX} --with-zlib=${zlib_include_dir},${zlib_library_dir} --with-pic --disable-shared --enable-cxx --disable-f77 --disable-f90 --disable-examples --disable-hl --disable-docs --libdir=${install_prefix}/lib${LIB_SUFFIX} "CC=${EXT_C_COMPILER}" "CXX=${EXT_CXX_COMPILER}" "CXXFLAGS=${EXT_CXX_FLAGS}" "CFLAGS=${EXT_C_FLAGS}"
#  INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/external
)

SET(HDF5_LIB_SUFFIX ".a")

SET(HDF5_BIN_DIR     ${staging_prefix}/${install_prefix}/bin )
SET(HDF5_INCLUDE_DIR ${staging_prefix}/${install_prefix}/include )
SET(HDF5_LIBRARY_DIR ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX} )
SET(HDF5_LIBRARY     ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libhdf5${HDF5_LIB_SUFFIX} )

SET(HDF5_LIBRARIES    ${HDF5_LIBRARY})
SET(HDF5_INCLUDE_DIRS ${HDF5_INCLUDE_DIR})

SET(HDF5_DIR         ${staging_prefix}/${install_prefix}/share/cmake/hdf5)
SET(HDF5_FOUND ON)


endmacro(build_hdf5)
