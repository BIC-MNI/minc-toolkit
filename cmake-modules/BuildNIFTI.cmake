macro(build_nifti install_prefix staging_prefix)

  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif()

  IF(CMAKE_BUILD_TYPE STREQUAL Release)
    SET(EXT_C_FLAGS "${CMAKE_C_FLAGS}  ${CMAKE_C_FLAGS_RELEASE}")
  ELSE()
    SET(EXT_C_FLAGS "${CMAKE_C_FLAGS}  ${CMAKE_C_FLAGS_DEBUG}")
  ENDIF()

ExternalProject_Add(NIFTI
  SOURCE_DIR NIFTI
  BINARY_DIR NIFTI-build
  URL "http://downloads.sourceforge.net/project/niftilib/nifticlib/nifticlib_2_0_0/nifticlib-2.0.0.tar.gz"
  URL_MD5 "425a711f8f92fb1e1f088cbc55bea53a"
  CMAKE_GENERATOR ${CMAKE_GEN}
  CMAKE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DCMAKE_SKIP_RPATH:BOOL=YES
        -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
        -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
        -DCMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}
        -DCMAKE_MODULE_LINKER_FLAGS=${CMAKE_MODULE_LINKER_FLAGS}
        -DCMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}
        -DBUILD_SHARED_LIBS:BOOL=NO
   INSTALL_COMMAND $(MAKE) install DESTDIR=${staging_prefix}
   INSTALL_DIR ${staging_prefix}/${install_prefix}
)

SET(NIFTI_LIBRARY     ${staging_prefix}/${install_prefix}/lib/libniftiio.a )
SET(NIFTI_INCLUDE_DIR ${staging_prefix}/${install_prefix}/include/nifti )
SET(ZNZ_LIBRARY     ${staging_prefix}/${install_prefix}/lib/libznz.a )
SET(NIFTI_FOUND ON)

endmacro(build_nifti)

