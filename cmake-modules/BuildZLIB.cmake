macro(build_zlib install_prefix staging_prefix)


# make a custom ZLIB configuration file

SET (ZLIB_VERSION_STRING 1.2)
SET (ZLIB_VERSION_MAJOR  1.2)
SET (ZLIB_VERSION_MINOR  11)

set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
if(APPLE)
  list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
    -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
    -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
    -DMACOSX_RPATH:BOOL=ON
    -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}
  )
endif()


ExternalProject_Add(ZLIB
  URL  "http://zlib.net/zlib-1.2.11.tar.gz"
  URL_MD5 "1c9f62f0778697a09d36121ead88e08e"
  UPDATE_COMMAND ""
  SOURCE_DIR ZLIB
  BINARY_DIR ZLIB-build
  LIST_SEPARATOR :::  
  CMAKE_GENERATOR ${CMAKE_GEN}
  CMAKE_ARGS
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DBUILD_SHARED_LIBS:BOOL=OFF
      -DCMAKE_SKIP_RPATH:BOOL=ON
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
      -DCMAKE_C_FLAGS:STRING=-fPIC ${CMAKE_C_FLAGS}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_SKIP_RPATH:BOOL=OFF
      -DCMAKE_SKIP_INSTALL_RPATH:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:PATH=${install_prefix}/lib${LIB_SUFFIX}
  INSTALL_COMMAND $(MAKE) install DESTDIR=${staging_prefix} 
  INSTALL_DIR ${staging_prefix}/${install_prefix}
)




SET(ZLIB_INCLUDE_DIR ${staging_prefix}/${install_prefix}/include )
SET(ZLIB_LIBRARY     ${staging_prefix}/${install_prefix}/lib/libz.a )
SET(ZLIB_DIR         ${staging_prefix}/${install_prefix}/share/cmake/ZLIB/ )
SET(ZLIB_FOUND ON)

configure_file(${CMAKE_SOURCE_DIR}/cmake-modules/ZLIB-config.cmake.install.in ${staging_prefix}/${install_prefix}/share/cmake/ZLIB/ZLIBConfig.cmake @ONLY )



endmacro(build_zlib)
