macro(build_itkv3 install_prefix staging_prefix)
  find_package(Threads REQUIRED)

  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif()
  
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    SET(ANTS_CXX_COMPILER "${CMAKE_CXX_COMPILER}" CACHE FILEPATH "C++ Compiler for ITK")
    SET(ANTS_C_COMPILER "${CMAKE_C_COMPILER}" CACHE FILEPATH "C Compiler for ITK")
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
      -DCMAKE_C_COMPILER:FILEPATH=${ANTS_C_COMPILER}
      -DCMAKE_CXX_COMPILER:FILEPATH=${ANTS_CXX_COMPILER}
    )
  endif()
	
  if(MT_BUILD_SHARED_LIBS) 
    SET(ITK_SHARED_LIBRARY "ON")
  else(MT_BUILD_SHARED_LIBS) 
    SET(ITK_SHARED_LIBRARY "OFF")
  endif(MT_BUILD_SHARED_LIBS) 

  ExternalProject_Add(ITKv3
#    URL "http://downloads.sourceforge.net/project/itk/itk/3.20/InsightToolkit-3.20.1.tar.gz"
#    URL_MD5 "90342ffa78bd88ae48b3f62866fbf050"
#    GIT_REPOSITORY "https://github.com/vfonov/ITK.git" #"http://itk.org/ITK.git"
#    GIT_TAG "537ecca3a2762908c96508ab6f667c049aba44f6"
    URL     "https://github.com/vfonov/ITK/archive/release-3.20-fix-libtiff-v1.tar.gz"
    URL_MD5 "d1ac22bcdf75231ba0da830d766ccd80"
    PATCH_COMMAND patch -p 1 -d ${CMAKE_CURRENT_BINARY_DIR}/ITKv3 -u -i ${CMAKE_CURRENT_SOURCE_DIR}/cmake-modules/patch_itkv3_gcc5.patch
    UPDATE_COMMAND ""
    SOURCE_DIR ITKv3
    BINARY_DIR ITKv3-build
    CMAKE_GENERATOR ${CMAKE_GEN}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS:BOOL=${ITK_SHARED_LIBRARY}
        -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
        -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
        -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
        -DCMAKE_EXE_LINKER_FLAGS=${CMAKE_EXE_LINKER_FLAGS}
        -DCMAKE_MODULE_LINKER_FLAGS=${CMAKE_MODULE_LINKER_FLAGS}
        -DCMAKE_SHARED_LINKER_FLAGS=${CMAKE_SHARED_LINKER_FLAGS}
        ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
        -DBUILD_EXAMPLES:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
        -DITK_USE_REVIEW:BOOL=ON
        -DITK_USE_REVIEW_STATISTICS:BOOL=ON
        -DITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON
        -DITK_USE_CENTERED_PIXEL_COORDINATES_CONSISTENTLY:BOOL=ON
        -DITK_USE_TRANSFORM_IO_FACTORIES:BOOL=ON
        -DITK_LEGACY_REMOVE:BOOL=OFF
        -DCMAKE_SKIP_RPATH:BOOL=OFF
        -DCMAKE_SKIP_INSTALL_RPATH:BOOL=OFF
        -DMACOSX_RPATH:BOOL=ON
        -DCMAKE_INSTALL_RPATH:PATH=${install_prefix}/lib${LIB_SUFFIX}
        -DUUID_INCLUDE_DIR:PATH= # to avoid dependecy on libuuid for now
        -DUUID_LIBRARY:FILEPATH= # to avoid dependecy on libuuid for now
        -DKWSYS_USE_MD5:BOOL=ON # Required by SlicerExecutionModel
    INSTALL_COMMAND $(MAKE) install DESTDIR=${staging_prefix}
    INSTALL_DIR ${staging_prefix}/${install_prefix}
  )
  #FORCE_BUILD_CHECK(ITKv3)
  SET(ITK_DIR ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build)
  SET(ITK_USE_FILE  ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/UseITK.cmake)
  SET(ITK_FOUND ON)
  
  SET(ITK_INCLUDE_DIRS 
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Algorithms
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/BasicFilters
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Common
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Numerics
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/IO
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Numerics/FEM
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Numerics/NeuralNetworks
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/SpatialObject
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/MetaIO
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/NrrdIO
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/NrrdIO
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/DICOMParser
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/DICOMParser
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/expat
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/expat
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/nifti/niftilib
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/nifti/znzlib
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/itkExtHdrs
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/vxl/v3p/netlib
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/vxl/vcl
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/vxl/core
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/vxl/v3p/netlib
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/vxl/vcl
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/vxl/core
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/gdcm
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/gdcm/src
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Review
        ${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Review/Statistics)

# The ITK library directories.
  SET(ITK_LIBRARY_DIRS "${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/bin")
  
  SET(ITK_LIBRARIES  
          ITKAlgorithms ITKStatistics 
          ITKNumerics 
          ITKFEM ITKQuadEdgeMesh 
          ITKBasicFilters  ITKIO ITKNrrdIO 
          ITKSpatialObject ITKMetaIO
          ITKDICOMParser ITKEXPAT
          ITKniftiio ITKTransformIOReview  ITKCommon ITKznz 
          itkgdcm itkpng itktiff itkzlib itkvcl 
          itkvcl 
          itkv3p_lsqr  itkvnl_algo itkvnl_inst itkvnl itkv3p_netlib 
          itksys itkjpeg8 itkjpeg12 itkjpeg16 itkopenjpeg
           ${CMAKE_THREAD_LIBS_INIT}
          )
	
	IF(UNIX)
		SET(ITK_LIBRARIES  ${ITK_LIBRARIES} dl)
	ENDIF(UNIX)
	
endmacro(build_itkv3)
