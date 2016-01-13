macro(build_gifti install_prefix staging_prefix)
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

ExternalProject_Add(GIFTI
  SOURCE_DIR GIFTI
  BINARY_DIR GIFTI-build
  URL "file:///home/rvincent/Dropbox/MCIN/gifticlib-1.0.10-Source.tar.gz"
  URL_MD5 ""
  CMAKE_GENERATOR ${CMAKE_GEN}
  CMAKE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DCMAKE_SKIP_RPATH:BOOL=YES
        -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
        -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
        -DCMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}
        -DNIFTI_INCLUDE_DIR=${NIFTI_INCLUDE_DIR}
        -DNIFTI_LIBRARY=${NIFTI_LIBRARY}
        -DBUILD_SHARED_LIBS:BOOL=NO
   INSTALL_COMMAND $(MAKE) install DESTDIR=${staging_prefix}
   INSTALL_DIR ${staging_prefix}/${install_prefix}
)

SET(GIFTI_LIBRARY     ${staging_prefix}/${install_prefix}/lib/libgiftiio.a )
SET(GIFTI_INCLUDE_DIR ${staging_prefix}/${install_prefix}/include/gifti )
SET(GIFTI_FOUND ON)

endmacro(build_gifti)

