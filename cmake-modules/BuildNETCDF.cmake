macro(build_netcdf install_prefix staging_prefix)

  IF(CMAKE_BUILD_TYPE STREQUAL Release)
    SET(EXT_C_FLAGS   "${CMAKE_C_FLAGS}   ${CMAKE_C_FLAGS_RELEASE}")
    SET(EXT_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}")
  ELSE()
    SET(EXT_C_FLAGS   "${CMAKE_C_FLAGS}    ${CMAKE_C_FLAGS_DEBUG}")
    SET(EXT_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")
  ENDIF()

  SET(EXT_C_COMPILER ${CMAKE_C_COMPILER})
  SET(EXT_CXX_COMPILER ${CMAKE_CXX_COMPILER})

ExternalProject_Add(NETCDF 
  SOURCE_DIR NETCDF
  URL "ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.3.3.1.tar.gz"
  URL_MD5 "5c9dad3705a3408d27f696e5b31fb88c"
  BUILD_IN_SOURCE 1
  INSTALL_DIR     "${staging_prefix}"
  BUILD_COMMAND   $(MAKE) 
  INSTALL_COMMAND $(MAKE) DESTDIR=${staging_prefix} install 
  CONFIGURE_COMMAND ./configure --prefix=${install_prefix} --libdir=${install_prefix}/lib${LIB_SUFFIX} --with-pic --disable-doxygen --disable-hdf4 --disable-netcdf-4 --disable-shared --disable-dap  --libdir=${install_prefix}/lib${LIB_SUFFIX} "CC=${EXT_C_COMPILER}" "CXX=${EXT_CXX_COMPILER}" "CXXFLAGS=${EXT_CXX_FLAGS}" "CFLAGS=${EXT_C_FLAGS}"
)

SET(NETCDF_LIBRARY     ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libnetcdf.a )
SET(NETCDF_INCLUDE_DIR ${staging_prefix}/${install_prefix}/include )
SET(NETCDF_FOUND ON)


endmacro(build_netcdf)
